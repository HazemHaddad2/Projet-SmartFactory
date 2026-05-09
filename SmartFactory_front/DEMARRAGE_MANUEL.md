# 🚀 Démarrage Manuel de l'Application Flutter

## Problème Actuel
L'application affiche "Directory listing for /" au lieu de l'interface Flutter.

## ✅ Solution : Utiliser Edge au lieu de Chrome

### Étape 1 : Ouvrir un Terminal PowerShell

1. Ouvrez PowerShell
2. Naviguez vers le dossier du projet :
```powershell
cd C:\Users\user\Desktop\Projet_exam\SmartFactory_front
```

### Étape 2 : Démarrer Flutter avec Edge

```powershell
flutter run -d edge --web-port 8080
```

**Attendez** que la compilation se termine (peut prendre 1-2 minutes la première fois).

Vous verrez :
```
Launching lib\main.dart on Edge in debug mode...
Building application for the web...
...
Application finished.
```

### Étape 3 : Ouvrir l'Application

L'application devrait s'ouvrir automatiquement dans Edge à l'adresse :
```
http://localhost:8080
```

Si elle ne s'ouvre pas automatiquement, ouvrez Edge manuellement et allez sur `http://localhost:8080`

### Étape 4 : Tester le RBAC

#### Test 1 : Connexion Technicien
1. Username: `tech1`
2. Password: `tech123`
3. Cliquez sur "Machines"

**Vérifiez :**
- ❌ Le bouton "+" en bas à droite doit être **INVISIBLE**
- ✅ Vous pouvez voir la liste des machines
- ❌ Le bouton "Modifier" dans les détails doit être **INVISIBLE**

#### Test 2 : Connexion Admin
1. Déconnectez-vous
2. Username: `admin`
3. Password: `admin123`
4. Cliquez sur "Machines"

**Vérifiez :**
- ✅ Le bouton "+" en bas à droite doit être **VISIBLE**
- ✅ Le bouton "Modifier" dans les détails doit être **VISIBLE**

## 🔧 Si l'Application ne Démarre Toujours Pas

### Option 1 : Nettoyer et Reconstruire

```powershell
# Arrêter Flutter (Ctrl+C dans le terminal)

# Nettoyer
flutter clean

# Récupérer les dépendances
flutter pub get

# Redémarrer
flutter run -d edge --web-port 8080
```

### Option 2 : Vérifier que le Port 8080 est Libre

```powershell
# Vérifier si quelque chose utilise le port 8080
netstat -ano | findstr :8080

# Si oui, tuer le processus (remplacez PID par le numéro affiché)
taskkill /PID <PID> /F

# Puis redémarrer Flutter
flutter run -d edge --web-port 8080
```

### Option 3 : Utiliser un Autre Port

```powershell
flutter run -d edge --web-port 8081
```

Puis ouvrez `http://localhost:8081` dans Edge.

## 📊 Tableau de Vérification

| Étape | Action | Résultat Attendu |
|-------|--------|------------------|
| 1 | `flutter run -d edge --web-port 8080` | Compilation réussie |
| 2 | Ouvrir `http://localhost:8080` | Page de connexion visible |
| 3 | Connexion tech1 | Bouton "+" invisible ❌ |
| 4 | Connexion admin | Bouton "+" visible ✅ |

## ⚠️ Note sur le Mode Développeur

Le message "Building with plugins requires symlink support" est juste un avertissement. L'application fonctionnera quand même.

Si vous voulez l'activer (optionnel) :
1. Appuyez sur Windows + I
2. Allez dans "Confidentialité et sécurité" → "Pour les développeurs"
3. Activez "Mode développeur"

## 🎯 Commandes Rapides

```powershell
# Démarrer l'application
cd C:\Users\user\Desktop\Projet_exam\SmartFactory_front
flutter run -d edge --web-port 8080

# Si besoin de nettoyer
flutter clean
flutter pub get
flutter run -d edge --web-port 8080

# Vérifier les devices disponibles
flutter devices

# Voir les logs en temps réel
# (Les logs s'affichent automatiquement dans le terminal où Flutter tourne)
```

## 🆘 Dépannage

### Problème : "Directory listing for /"
**Cause :** Flutter n'a pas compilé correctement
**Solution :** Nettoyer et reconstruire (voir Option 1 ci-dessus)

### Problème : "Cannot find Chrome"
**Cause :** Chrome n'est pas installé
**Solution :** Utiliser Edge avec `-d edge`

### Problème : "Port already in use"
**Cause :** Le port 8080 est déjà utilisé
**Solution :** Utiliser un autre port ou tuer le processus (voir Option 2 ci-dessus)

### Problème : Le bouton "+" est toujours visible pour tech1
**Cause :** Cache du navigateur
**Solution :** 
1. Appuyez sur **Ctrl+Shift+R** dans Edge
2. Ou ouvrez une fenêtre de navigation privée (Ctrl+Shift+N)
3. Allez sur `http://localhost:8080`

## ✅ Succès !

Quand vous voyez :
- Page de connexion qui s'affiche correctement
- Connexion tech1 → Bouton "+" invisible
- Connexion admin → Bouton "+" visible

**Le RBAC fonctionne ! 🎉**
