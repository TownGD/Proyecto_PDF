# Script de prueba rápida para compresión v1.1
# Uso: powershell -ExecutionPolicy Bypass -File test_compresion.ps1

Write-Host "🚀 Test de Compresión PDF v1.1" -ForegroundColor Green
Write-Host "================================`n"

# Configuración
$archivoOrigen = "tu_archivo.pdf"  # ← Cambia esto por tu PDF
$servidor = "http://localhost:5000"
$niveles = @("baja", "media", "alta", "ultra")

# Verificar que el archivo existe
if (-not (Test-Path $archivoOrigen)) {
    Write-Host "❌ Error: No encontré $archivoOrigen" -ForegroundColor Red
    Write-Host "`nPasos:" -ForegroundColor Yellow
    Write-Host "1. Edita este script (línea 8)"
    Write-Host "2. Cambia 'tu_archivo.pdf' por tu PDF real"
    Write-Host "3. Copia el PDF aquí: $(Get-Location)"
    exit
}

$tamanoOrigen = (Get-Item $archivoOrigen).Length / 1MB
Write-Host "📄 Archivo original: $archivoOrigen" -ForegroundColor Cyan
Write-Host "📊 Tamaño original: {0:F2} MB`n" -f $tamanoOrigen -ForegroundColor Cyan

# Probar cada nivel
foreach ($nivel in $niveles) {
    $salida = "resultado_${nivel}.pdf"
    
    Write-Host "🔄 Probando nivel: $nivel" -ForegroundColor Yellow
    
    $response = curl -s `
        -F "archivo=@$archivoOrigen" `
        -F "nivel=$nivel" `
        "$servidor/api/compresion" `
        -o $salida
    
    if (Test-Path $salida) {
        $tamanoNuevo = (Get-Item $salida).Length / 1MB
        $reduccion = (1 - ($tamanoNuevo / $tamanoOrigen)) * 100
        
        Write-Host "   ✅ Comprimido: {0:F2} MB" -f $tamanoNuevo -ForegroundColor Green
        Write-Host "   📉 Reducción: {0:F1}%" -f $reduccion -ForegroundColor Green
        Write-Host ""
    } else {
        Write-Host "   ❌ Error en compresión" -ForegroundColor Red
    }
}

Write-Host "✨ Test completado!" -ForegroundColor Green
Write-Host "`nArchivos de prueba creados:" -ForegroundColor Cyan
Get-ChildItem "resultado_*.pdf" | ForEach-Object {
    $size = $_.Length / 1MB
    Write-Host "   - $($_.Name) ({0:F2} MB)" -f $size
}
