# Script de Validação Local - PowerShell (Windows)
# Execute: .\validate.ps1

Write-Host "🚀 Iniciando validação local do projeto..." -ForegroundColor Cyan
Write-Host "═══════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""

$FAILED = 0

# 1. Verificar pasta src/
Write-Host "1️⃣  Verificando existência de pasta src/ na raiz..." -ForegroundColor Yellow
if (-Not (Test-Path ".\src")) {
    Write-Host "❌ ERRO: Pasta src/ não encontrada!" -ForegroundColor Red
    $FAILED = 1
} else {
    Write-Host "✅ Pasta src/ encontrada" -ForegroundColor Green
}

Write-Host ""

# 2. Verificar index.html em src/
Write-Host "2️⃣  Verificando existência de index.html em src/..." -ForegroundColor Yellow
if (-Not (Test-Path ".\src\index.html")) {
    Write-Host "❌ ERRO: Arquivo src/index.html não encontrado!" -ForegroundColor Red
    $FAILED = 1
} else {
    Write-Host "✅ src/index.html encontrado" -ForegroundColor Green
}

Write-Host ""

# 3. Verificar style.css em src/css/
Write-Host "3️⃣  Verificando existência de style.css em src/css/..." -ForegroundColor Yellow
if (-Not (Test-Path ".\src\css\style.css")) {
    Write-Host "❌ ERRO: Arquivo src/css/style.css não encontrado!" -ForegroundColor Red
    $FAILED = 1
} else {
    Write-Host "✅ src/css/style.css encontrado" -ForegroundColor Green
}

Write-Host ""

# 4. Verificar link CSS em index.html
Write-Host "4️⃣  Verificando link do CSS no HTML..." -ForegroundColor Yellow
$htmlContent = Get-Content ".\src\index.html" -Raw
if ($htmlContent -match 'href="css/style.css"') {
    Write-Host "✅ Caminho CSS está correto" -ForegroundColor Green
} else {
    Write-Host "❌ ERRO: Caminho CSS incorreto! Esperado: href=`"css/style.css`"" -ForegroundColor Red
    $FAILED = 1
}

Write-Host ""

# 5. Verificar arquivos > 500KB
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

# 6. Procurar TODO, FIXME e termos sensíveis
Write-Host "6️⃣  Procurando comentários TODO/FIXME e termos sensíveis..." -ForegroundColor Yellow
$VIOLATIONS = 0

# Buscar em arquivos HTML, CSS e JS dentro de src/
$FILES_TO_CHECK = Get-ChildItem -Path ".\src" -Recurse -Include "*.html", "*.css", "*.js" | 
    Where-Object { $_.FullName -notmatch "\.git" }

# TODO
$TODO_FOUND = $FILES_TO_CHECK | Select-String -Pattern "\bTODO\b|\bTODO:" -ErrorAction SilentlyContinue
if ($TODO_FOUND) {
    Write-Host "❌ Encontrados comentários TODO:" -ForegroundColor Red
    $TODO_FOUND | ForEach-Object { Write-Host "   $_" }
    $VIOLATIONS++
}

# FIXME
$FIXME_FOUND = $FILES_TO_CHECK | Select-String -Pattern "\bFIXME\b|\bFIXME:" -ErrorAction SilentlyContinue
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

# 7. Validar footer com nome do aluno
Write-Host "7️⃣  Validando footer com nome do aluno..." -ForegroundColor Yellow
if ($htmlContent -match "<footer>" -and $htmlContent -imatch "lucas araujo") {
    Write-Host "✅ Footer encontrado com nome do aluno 'Lucas Araujo'" -ForegroundColor Green
} else {
    Write-Host "❌ ERRO: Footer não contém o nome do aluno!" -ForegroundColor Red
    $FAILED = 1
}

Write-Host ""
Write-Host "═══════════════════════════════════════════════════════" -ForegroundColor Cyan

if ($FAILED -eq 0) {
    Write-Host ""
    Write-Host "🎉 VALIDAÇÃO CONCLUÍDA COM SUCESSO!" -ForegroundColor Green
    Write-Host "═══════════════════════════════════════════════════════" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "✅ O código do aluno Lucas Araujo foi auditado," -ForegroundColor Green
    Write-Host "está seguindo as normas corretas e está pronto para o deploy!" -ForegroundColor Green
    Write-Host ""
    exit 0
} else {
    Write-Host ""
    Write-Host "❌ VALIDAÇÃO FALHOU! Corrija os erros acima." -ForegroundColor Red
    Write-Host "═══════════════════════════════════════════════════════" -ForegroundColor Cyan
    Write-Host ""
    exit 1
}

