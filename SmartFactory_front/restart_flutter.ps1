# Script pour redémarrer Flutter proprement avec les nouvelles modifications

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Redémarrage Flutter avec RBAC" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Étape 1 : Arrêter tous les processus Flutter
Write-Host "1. Arrêt des processus Flutter..." -ForegroundColor Yellow
Get-Process | Where-Object {$_.ProcessName -eq "dart" -or $_.ProcessName -eq "dartvm"} | Stop-Process -Force -ErrorAction SilentlyContinue
Start-Sleep -Seconds 2
Write-Host "   ✅ Processus arrêtés" -ForegroundColor Green
Write-Host ""

# Étape 2 : Nettoyer le cache
Write-Host "2. Nettoyage du cache Flutter..." -ForegroundColor Yellow
flutter clean | Out-Null
Write-Host "   ✅ Cache nettoyé" -ForegroundColor Green
Write-Host ""

# Étape 3 : Récupérer les dépendances
Write-Host "3. Récupération des dépendances..." -ForegroundColor Yellow
flutter pub get | Out-Null
Write-Host "   ✅ Dépendances récupérées" -ForegroundColor Green
Write-Host ""

# Étape 4 : Démarrer Flutter
Write-Host "4. Démarrage de l'application..." -ForegroundColor Yellow
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  IMPORTANT - Après le démarrage:" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "1. Connectez-vous en tant que TECHNICIEN:" -ForegroundColor White
Write-Host "   Username: tech1" -ForegroundColor White
Write-Host "   Password: tech123" -ForegroundColor White
Write-Host ""
Write-Host "2. Vérifiez que:" -ForegroundColor White
Write-Host "   ❌ Le bouton '+' est INVISIBLE" -ForegroundColor Red
Write-Host "   ✅ Vous pouvez voir les machines" -ForegroundColor Green
Write-Host "   ❌ Le bouton 'Modifier' est INVISIBLE" -ForegroundColor Red
Write-Host ""
Write-Host "3. Déconnectez-vous et connectez-vous en tant qu'ADMIN:" -ForegroundColor White
Write-Host "   Username: admin" -ForegroundColor White
Write-Host "   Password: admin123" -ForegroundColor White
Write-Host ""
Write-Host "4. Vérifiez que:" -ForegroundColor White
Write-Host "   ✅ Le bouton '+' est VISIBLE" -ForegroundColor Green
Write-Host "   ✅ Le bouton 'Modifier' est VISIBLE" -ForegroundColor Green
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Lancer Flutter
flutter run -d edge --web-port 8080
