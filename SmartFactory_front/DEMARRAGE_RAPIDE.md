# 🚀 Démarrage Rapide - Frontend avec RBAC

## Problème Actuel
Le bouton "+" est encore visible pour les techniciens car Flutter utilise l'ancien code en cache.

## ✅ Solution en 3 Étapes

### Étape 1 : Arrêter Flutter
Dans le terminal où Flutter tourne, appuyez sur **Ctrl+C**

### Étape 2 : Nettoyer et Redémarrer
Exécutez ce script PowerShell :

```powershell
cd SmartFactory_front
.\restart_flutter.ps1
```

**OU manuellement :**

```powershell
# Arrêter tous les processus
Get-Process | Where-Object {$_.ProcessName -eq "dart"} | Stop-Process -Force

# Nettoyer le cache
flutter clean

# Récupérer les dépendances
flutter pub get

# Redémarrer
flutter run -d chrome --web-port 8080
```

### Étape 3 : Tester

#### Test 1 : Connexion Technicien
1. Username: `tech1`
2. Password: `tech123`
3. Aller sur "Machines"

**Ce que vous DEVEZ voir :**
- ✅ Liste des machines
- ✅ Bouton "Historique" sur chaque machine
- ❌ **PAS de bouton "+"** en bas à droite
- ❌ **PAS de bouton "Modifier"** dans les détails

**Si vous voyez encore le bouton "+" :**
- Videz le cache du navigateur : **Ctrl+Shift+R** (ou Cmd+Shift+R sur Mac)
- Ou ouvrez en navigation privée

#### Test 2 : Connexion Admin
1. Se déconnecter
2. Username: `admin`
3. Password: `admin123`
4. Aller sur "Machines"

**Ce que vous DEVEZ voir :**
- ✅ Liste des machines
- ✅ **Bouton "+"** en bas à droite
- ✅ **Bouton "Modifier"** dans les détails
- ✅ Bouton "Historique"

## 🔍 Vérification des Modifications

Pour vérifier que les modifications sont bien dans les fichiers :

```powershell
# Vérifier machines_screen.dart
Select-String -Path "lib\screens\machines_screen.dart" -Pattern "isAdmin"

# Vérifier add_edit_machine_screen.dart
Select-String -Path "lib\screens\add_edit_machine_screen.dart" -Pattern "checkUserRole"

# Vérifier user.dart
Select-String -Path "lib\models\user.dart" -Pattern "isAdmin"
```

Vous devriez voir des résultats pour chaque commande.

## ⚠️ Si ça ne marche toujours pas

### Option 1 : Vider complètement le cache du navigateur
1. Ouvrez Chrome DevTools (F12)
2. Clic droit sur le bouton de rafraîchissement
3. Sélectionnez "Vider le cache et effectuer une actualisation forcée"

### Option 2 : Utiliser la navigation privée
1. Ouvrez une fenêtre de navigation privée
2. Allez sur `http://localhost:8080`
3. Testez avec tech1

### Option 3 : Supprimer le dossier build manuellement
```powershell
Remove-Item -Recurse -Force build
Remove-Item -Recurse -Force .dart_tool
flutter pub get
flutter run -d chrome --web-port 8080
```

## 📊 Tableau de Vérification

| Utilisateur | Bouton "+" | Bouton "Modifier" | Peut créer ? | Peut modifier ? |
|-------------|------------|-------------------|--------------|-----------------|
| tech1       | ❌ Caché   | ❌ Caché          | ❌ Non       | ❌ Non          |
| admin       | ✅ Visible | ✅ Visible        | ✅ Oui       | ✅ Oui          |

## 🎯 Test Backend (pour confirmer)

Même si le frontend a un problème, le backend doit bloquer :

```powershell
# Technicien tente de créer (doit échouer)
Invoke-WebRequest -Uri "http://localhost:8000/machines?name=Test&status=idle" `
  -Method POST `
  -Headers @{"Authorization"="Bearer technicien:tech1"} `
  -UseBasicParsing

# Résultat attendu : 403 Forbidden
```

## 📝 Fichiers Modifiés

Les fichiers suivants ont été modifiés pour implémenter le RBAC :

1. **lib/models/user.dart**
   - Ajout de `isAdmin` et `isTechnicien`

2. **lib/screens/machines_screen.dart**
   - Chargement de l'utilisateur courant
   - Bouton "+" conditionnel : `_currentUser?.isAdmin == true`
   - Bouton "Modifier" conditionnel

3. **lib/screens/add_edit_machine_screen.dart**
   - Vérification du rôle au chargement
   - Blocage si pas admin
   - Message d'erreur clair

4. **lib/services/machine_service.dart**
   - Gestion des erreurs 403 (Accès refusé)
   - Gestion des erreurs 401 (Non authentifié)
   - Messages d'erreur explicites

## 🆘 Support

Si après toutes ces étapes le problème persiste :

1. Vérifiez que vous êtes bien connecté en tant que technicien
2. Vérifiez dans les DevTools (F12) → Application → Local Storage que le token est bien "technicien:tech1"
3. Vérifiez dans les DevTools → Network que les requêtes incluent bien le header Authorization
4. Essayez de créer une machine et regardez la réponse dans Network (doit être 403)
