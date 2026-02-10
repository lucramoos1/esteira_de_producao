#!/bin/bash

echo "🚀 Iniciando validação local do projeto..."
echo "═══════════════════════════════════════════════════════"
echo ""

FAILED=0

echo "1️⃣  Verificando existência de pasta src/ na raiz..."
if [ ! -d "src" ]; then
    echo "❌ ERRO: Pasta src/ não encontrada na raiz!"
    FAILED=1
else
    echo "✅ Pasta src/ encontrada"
fi

echo ""
echo "2️⃣  Verificando existência de index.html em src/..."
if [ ! -f "src/index.html" ]; then
    echo "❌ ERRO: Arquivo src/index.html não encontrado!"
    FAILED=1
else
    echo "✅ src/index.html encontrado"
fi

echo ""
echo "3️⃣  Verificando existência de style.css em src/css/..."
if [ ! -f "src/css/style.css" ]; then
    echo "❌ ERRO: Arquivo src/css/style.css não encontrado!"
    FAILED=1
else
    echo "✅ src/css/style.css encontrado"
fi

echo ""
echo "4️⃣  Verificando link do CSS no HTML..."
if grep -q 'href="css/style.css"' src/index.html; then
    echo "✅ Caminho CSS está correto"
else
    echo "❌ ERRO: Caminho CSS incorreto! Esperado: href=\"css/style.css\""
    FAILED=1
fi

echo ""
echo "5️⃣  Verificando arquivos maiores que 500KB..."
LARGE_FILES=$(find . -type f -size +500k -not -path './.git/*' -not -path './.github/*' -not -path './node_modules/*' 2>/dev/null)
if [ ! -z "$LARGE_FILES" ]; then
    echo "❌ ERRO: Arquivos maiores que 500KB encontrados:"
    echo "$LARGE_FILES"
    FAILED=1
else
    echo "✅ Todos os arquivos estão dentro do limite"
fi

echo ""
echo "6️⃣  Procurando comentários TODO/FIXME e termos sensíveis..."
VIOLATIONS=0

if grep -rE "\bTODO\b|\bTODO:" --include="*.html" --include="*.css" --include="*.js" src/ 2>/dev/null; then
    echo "❌ Encontrados comentários TODO"
    VIOLATIONS=$((VIOLATIONS + 1))
fi

if grep -rE "\bFIXME\b|\bFIXME:" --include="*.html" --include="*.css" --include="*.js" src/ 2>/dev/null; then
    echo "❌ Encontrados comentários FIXME"
    VIOLATIONS=$((VIOLATIONS + 1))
fi

if grep -ri "senha\|password" --include="*.html" --include="*.css" --include="*.js" src/ 2>/dev/null; then
    echo "❌ Encontrados termos sensíveis (senha/password)"
    VIOLATIONS=$((VIOLATIONS + 1))
fi

if [ $VIOLATIONS -eq 0 ]; then
    echo "✅ Nenhuma violação encontrada"
else
    FAILED=1
fi

echo ""
echo "7️⃣  Validando footer com nome do aluno..."
if grep -q "<footer>" src/index.html && grep -iq "lucas araujo" src/index.html; then
    echo "✅ Footer encontrado com nome do aluno 'Lucas Araujo'"
else
    echo "❌ ERRO: Footer não contém o nome do aluno!"
    FAILED=1
fi

echo ""
echo "═══════════════════════════════════════════════════════"

if [ $FAILED -eq 0 ]; then
    echo ""
    echo "🎉 VALIDAÇÃO CONCLUÍDA COM SUCESSO!"
    echo "═══════════════════════════════════════════════════════"
    echo ""
    echo "✅ O código do aluno Lucas Araujo foi auditado,"
    echo "está seguindo as normas corretas e está pronto para o deploy!"
    echo ""
    exit 0
else
    echo ""
    echo "❌ VALIDAÇÃO FALHOU! Corrija os erros acima."
    echo "═══════════════════════════════════════════════════════"
    echo ""
    exit 1
fi
        if [[ "$HREF" =~ \.css$ ]]; then
            if [ ! -f "$HREF" ]; then
                echo "❌ Arquivo CSS não encontrado: $HREF"
                LINK_ERRORS=$((LINK_ERRORS + 1))
            fi
        fi
    fi
done < <(grep -o '<link[^>]*href="[^"]*"' index.html 2>/dev/null)
