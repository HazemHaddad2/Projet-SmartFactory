@echo off
echo ========================================
echo    Push vers un NOUVEAU repository GitHub
echo ========================================

echo.
echo INSTRUCTIONS:
echo 1. Créez un nouveau repository sur GitHub.com
echo 2. Copiez l'URL du repository (ex: https://github.com/username/SmartFactory-Monitor.git)
echo 3. Ce script va supprimer l'ancien remote et créer un nouveau

echo.
set /p github_url="Entrez l'URL de votre NOUVEAU repository GitHub: "

echo.
echo Suppression de l'ancien remote...
git remote remove origin 2>nul

echo.
echo Ajout du nouveau remote GitHub...
git remote add origin %github_url%

echo.
echo Ajout de tous les fichiers...
git add .

echo.
echo Création du commit...
git commit -m "Initial commit - Complete SmartFactory project"

echo.
echo Configuration de la branche principale...
git branch -M main

echo.
echo Push vers le nouveau repository GitHub...
git push -u origin main

echo.
echo ========================================
echo ✅ Projet poussé vers le nouveau repository avec succès !
echo ========================================
echo.
echo Votre projet est maintenant disponible sur:
echo %github_url%
echo.
pause