#!/bin/bash

echo "🚀 Iniciando validação local do projeto..."
echo "═══════════════════════════════════════════════════════"
echo ""

FAILED=0

echo "1️⃣  Verificando existência de index.html na raiz..."
if [ ! -f "index.html" ]; then
    echo "❌ ERRO: Arquivo index.html não encontrado na raiz!"
    FAILED=1
else
    echo "✅ index.html encontrado"
fi

echo ""
echo "2️⃣  Validando que index.html não foi renomeado..."
if [ -f "index-teste.html" ] || [ -f "home.html" ] || [ -f "main.html" ]; then
    echo "❌ ERRO: Encontrado arquivo com nome alternativo!"
    FAILED=1
else
    echo "✅ Nome do arquivo está correto"
fi

echo ""
echo "3️⃣  Verificando arquivos maiores que 500KB..."
LARGE_FILES=$(find . -type f -size +500k -not -path './.git/*' -not -path './.github/*' -not -path './node_modules/*' 2>/dev/null)
if [ ! -z "$LARGE_FILES" ]; then
    echo "❌ ERRO: Arquivos maiores que 500KB encontrados:"
    echo "$LARGE_FILES"
    FAILED=1
else
    echo "✅ Todos os arquivos estão dentro do limite"
fi

echo ""
echo "4️⃣  Procurando comentários TODO/FIXME e termos sensíveis..."
VIOLATIONS=0

if grep -r "TODO" --include="*.html" --include="*.css" --include="*.js" . 2>/dev/null | grep -v ".git" | grep -v "node_modules"; then
    echo "❌ Encontrados comentários TODO"
    VIOLATIONS=$((VIOLATIONS + 1))
fi

if grep -r "FIXME" --include="*.html" --include="*.css" --include="*.js" . 2>/dev/null | grep -v ".git" | grep -v "node_modules"; then
    echo "❌ Encontrados comentários FIXME"
    VIOLATIONS=$((VIOLATIONS + 1))
fi

if grep -ri "senha\|password" --include="*.html" --include="*.css" --include="*.js" . 2>/dev/null | grep -v ".git" | grep -v "node_modules"; then
    echo "❌ Encontrados termos sensíveis (senha/password)"
    VIOLATIONS=$((VIOLATIONS + 1))
fi

if [ $VIOLATIONS -eq 0 ]; then
    echo "✅ Nenhuma violação encontrada"
else
    FAILED=1
fi

echo ""
echo "5️⃣  Validando URLs e caminhos em tags link e img..."
LINK_ERRORS=0

# Verificar links de CSS
while IFS= read -r line; do
    if [[ $line =~ href=\"([^\"]+)\" ]]; then
        HREF="${BASH_REMATCH[1]}"
        if [[ "$HREF" =~ \.css$ ]]; then
            if [ ! -f "$HREF" ]; then
                echo "❌ Arquivo CSS não encontrado: $HREF"
                LINK_ERRORS=$((LINK_ERRORS + 1))
            fi
        fi
    fi
done < <(grep -o '<link[^>]*href="[^"]*"' index.html 2>/dev/null)

# Verificar imagens
while IFS= read -r line; do
    if [[ $line =~ src=\"([^\"]+)\" ]]; then
        SRC="${BASH_REMATCH[1]}"
        if [[ ! "$SRC" =~ ^http ]]; then
            if [ ! -f "$SRC" ]; then
                echo "⚠️  Arquivo não encontrado: $SRC"
            fi
        fi
    fi
done < <(grep -o 'src="[^"]*"' index.html 2>/dev/null)

if [ $LINK_ERRORS -eq 0 ]; then
    echo "✅ Caminhos validados"
else
    FAILED=1
fi

echo ""
echo "═══════════════════════════════════════════════════════"

if [ $FAILED -eq 0 ]; then
    echo "✅ VALIDAÇÃO LOCAL PASSOU!"
    echo ""
    echo "Seu código está pronto para fazer push:"
    echo "  git add ."
    echo "  git commit -m 'Mensagem do commit'"
    echo "  git push origin sua-branch"
    echo ""
    exit 0
else
    echo "❌ VALIDAÇÃO LOCAL FALHOU!"
    echo ""
    echo "Corrija os erros acima e tente novamente."
    echo ""
    exit 1
fi
