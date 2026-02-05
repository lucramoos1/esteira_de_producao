# Script de Validação Local - PowerShell (Windows)
# Execute: .\validate.ps1

Write-Host "🚀 Iniciando validação local do projeto..." -ForegroundColor Cyan
Write-Host "═══════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""

$FAILED = 0

# 1. Verificar index.html
Write-Host "1️⃣  Verificando existência de index.html na raiz..." -ForegroundColor Yellow
if (-Not (Test-Path ".\index.html")) {
    Write-Host "❌ ERRO: Arquivo index.html não encontrado na raiz!" -ForegroundColor Red
    $FAILED = 1
} else {
    Write-Host "✅ index.html encontrado" -ForegroundColor Green
}

Write-Host ""

# 2. Validar nome do arquivo
Write-Host "2️⃣  Validando que index.html não foi renomeado..." -ForegroundColor Yellow
if ((Test-Path ".\index-teste.html") -or (Test-Path ".\home.html") -or (Test-Path ".\main.html")) {
    Write-Host "❌ ERRO: Encontrado arquivo com nome alternativo!" -ForegroundColor Red
    $FAILED = 1
} else {
    Write-Host "✅ Nome do arquivo está correto" -ForegroundColor Green
}

Write-Host ""

# 3. Verificar arquivos > 500KB
Write-Host "3️⃣  Verificando arquivos maiores que 500KB..." -ForegroundColor Yellow
$LARGE_FILES = Get-ChildItem -Recurse -File | Where-Object {
    $_.Length -gt 500KB -and 
    $_.FullName -notmatch "\.git" -and 
    $_.FullName -notmatch "node_modules"
}

if ($LARGE_FILES.Count -gt 0) {
    Write-Host "❌ ERRO: Arquivos maiores que 500KB encontrados:" -ForegroundColor Red
    $LARGE_FILES | ForEach-Object { Write-Host "   - $($_.FullName) ($($_.Length / 1MB)MB)" }
    $FAILED = 1
} else {
    Write-Host "✅ Todos os arquivos estão dentro do limite" -ForegroundColor Green
}

Write-Host ""

# 4. Procurar TODO, FIXME e termos sensíveis
Write-Host "4️⃣  Procurando comentários TODO/FIXME e termos sensíveis..." -ForegroundColor Yellow
$VIOLATIONS = 0

# Buscar em arquivos HTML, CSS e JS
$FILES_TO_CHECK = Get-ChildItem -Recurse -Include "*.html", "*.css", "*.js" | 
    Where-Object { $_.FullName -notmatch "\.git|node_modules" }

# TODO
$TODO_FOUND = $FILES_TO_CHECK | Select-String -Pattern "TODO" -ErrorAction SilentlyContinue
if ($TODO_FOUND) {
    Write-Host "❌ Encontrados comentários TODO:" -ForegroundColor Red
    $TODO_FOUND | ForEach-Object { Write-Host "   $_" }
    $VIOLATIONS++
}

# FIXME
$FIXME_FOUND = $FILES_TO_CHECK | Select-String -Pattern "FIXME" -ErrorAction SilentlyContinue
if ($FIXME_FOUND) {
    Write-Host "❌ Encontrados comentários FIXME:" -ForegroundColor Red
    $FIXME_FOUND | ForEach-Object { Write-Host "   $_" }
    $VIOLATIONS++
}

# senha/password
$SENSITIVE_FOUND = $FILES_TO_CHECK | Select-String -Pattern "senha|password" -ErrorAction SilentlyContinue
if ($SENSITIVE_FOUND) {
    Write-Host "❌ Encontrados termos sensíveis (senha/password):" -ForegroundColor Red
    $SENSITIVE_FOUND | ForEach-Object { Write-Host "   $_" }
    $VIOLATIONS++
}

if ($VIOLATIONS -eq 0) {
    Write-Host "✅ Nenhuma violação encontrada" -ForegroundColor Green
} else {
    $FAILED = 1
}

Write-Host ""

# 5. Validar URLs e caminhos
Write-Host "5️⃣  Validando URLs e caminhos em tags link e img..." -ForegroundColor Yellow

if (Test-Path ".\index.html") {
    $HTML_CONTENT = Get-Content ".\index.html" -Raw
    $LINK_ERRORS = 0
    
    # Verificar CSS
    $CSS_LINKS = [regex]::Matches($HTML_CONTENT, 'href="([^"]+\.css)"')
    foreach ($match in $CSS_LINKS) {
        $CSS_FILE = $match.Groups[1].Value
        if (-Not (Test-Path ".\$CSS_FILE")) {
            Write-Host "❌ Arquivo CSS não encontrado: $CSS_FILE" -ForegroundColor Red
            $LINK_ERRORS++
        }
    }
    
    # Verificar imagens locais
    $IMG_LINKS = [regex]::Matches($HTML_CONTENT, 'src="([^"]+)"')
    foreach ($match in $IMG_LINKS) {
        $IMG_FILE = $match.Groups[1].Value
        if (-Not ($IMG_FILE -match "^http")) {
            if (-Not (Test-Path ".\$IMG_FILE")) {
                Write-Host "⚠️  Arquivo não encontrado: $IMG_FILE" -ForegroundColor Yellow
            }
        }
    }
    
    if ($LINK_ERRORS -eq 0) {
        Write-Host "✅ Caminhos validados" -ForegroundColor Green
    } else {
        $FAILED = 1
    }
}

Write-Host ""
Write-Host "═══════════════════════════════════════════════════════" -ForegroundColor Cyan

if ($FAILED -eq 0) {
    Write-Host "✅ VALIDAÇÃO LOCAL PASSOU!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Seu código está pronto para fazer push:" -ForegroundColor Green
    Write-Host "  git add ."
    Write-Host "  git commit -m 'Mensagem do commit'"
    Write-Host "  git push origin sua-branch"
    Write-Host ""
    exit 0
} else {
    Write-Host "❌ VALIDAÇÃO LOCAL FALHOU!" -ForegroundColor Red
    Write-Host ""
    Write-Host "Corrija os erros acima e tente novamente." -ForegroundColor Red
    Write-Host ""
    exit 1
}
