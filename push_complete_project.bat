@echo off
echo ========================================
echo    Push PROJET_EXAM COMPLET vers GitHub
echo ========================================

echo.
echo Ce script va pousser tout le projet incluant:
echo - SmartFactory-monitor (Backend)
echo - SmartFactory_front (Frontend Flutter)
echo - Tous les fichiers et dossiers

echo.
echo INSTRUCTIONS:
echo 1. Créez un nouveau repository sur GitHub.com
echo 2. Copiez l'URL du repository (ex: https://github.com/username/Projet-Exam.git)

echo.
set /p github_url="Entrez l'URL de votre repository GitHub: "

echo.
echo Initialisation du repository Git...
git init

echo.
echo Ajout de tous les fichiers du projet...
git add .

echo.
echo Création du commit initial...
git commit -m "Initial commit - Projet Exam complet (SmartFactory Backend + Frontend Flutter)"

echo.
echo Configuration de la branche principale...
git branch -M main

echo.
echo Ajout du remote GitHub...
git remote add origin %github_url%

echo.
echo Push vers GitHub...
git push -u origin main

echo.
echo ========================================
echo ✅ PROJET COMPLET poussé vers GitHub avec succès !
echo ========================================
echo.
echo Votre projet complet est maintenant disponible sur:
echo %github_url%
echo.
echo Contenu poussé:
echo - SmartFactory-monitor/ (Backend avec tous les microservices)
echo - SmartFactory_front/ (Frontend Flutter)
echo - README.md
echo - .gitignore
echo.
pause