# 🏭 SmartFactory Monitor - Frontend

Application Flutter pour la gestion de production industrielle en temps réel.

## 📋 Description

SmartFactory Monitor est une plateforme de gestion de production industrielle qui permet de :
- 📊 Suivre les machines/stations en temps réel
- 🚨 Détecter les pannes et anomalies
- 🔧 Gérer les interventions techniques
- 📈 Analyser les événements en temps réel via Kafka

## 🏗️ Architecture

### Microservices Backend (FastAPI)
1. **User Service** - Gestion des utilisateurs et authentification
2. **Machine Service** - CRUD des machines et stations
3. **Event Service** - Réception et envoi d'événements vers Kafka
4. **Alert Service** - Consommation Kafka et déclenchement d'alertes
5. **Maintenance Service** - Gestion des tickets d'intervention

### Frontend (Flutter Web)
- **Login** - Authentification JWT
- **Dashboard** - Vue d'ensemble avec statistiques
- **Machines** - Liste et détails des machines
- **Events** - Événements en temps réel
- **Alerts** - Alertes actives
- **Maintenance** - Tickets d'intervention

## 🚀 Installation

### Prérequis
- Flutter SDK 3.11.0 ou supérieur
- Dart SDK
- Backend SmartFactory en cours d'exécution

### Configuration

1. Cloner le projet
```bash
git clone <votre-repo>
cd SmartFactory_front
```

2. Installer les dépendances
```bash
flutter pub get
```

3. Configurer l'API
Modifier `lib/config/api_config.dart` avec vos URLs backend :
```dart
static const String baseUrl = 'http://localhost:8000';
```

4. Activer le support web (si nécessaire)
```bash
flutter create .
```

## 🎯 Lancement

### Mode développement (Edge)
```bash
flutter run -d edge
```

### Mode développement (Chrome)
```bash
flutter run -d chrome
```

### Build production
```bash
flutter build web
```

Les fichiers seront générés dans `build/web/`

## 📁 Structure du projet

```
lib/
├── config/
│   └── api_config.dart          # Configuration API
├── models/
│   ├── user.dart                # Modèle utilisateur
│   ├── machine.dart             # Modèle machine
│   ├── event.dart               # Modèle événement
│   ├── alert.dart               # Modèle alerte
│   └── maintenance_ticket.dart  # Modèle ticket
├── services/
│   ├── auth_service.dart        # Service authentification
│   └── machine_service.dart     # Service machines
├── screens/
│   ├── login_screen.dart        # Écran de connexion
│   ├── dashboard_screen.dart    # Tableau de bord
│   └── machines_screen.dart     # Liste des machines
├── utils/
│   └── logger.dart              # Utilitaire de logging
└── main.dart                    # Point d'entrée
```

## 🔧 Technologies utilisées

- **Flutter** - Framework UI
- **HTTP/Dio** - Requêtes API
- **Provider** - State management
- **SharedPreferences** - Stockage local
- **FL Chart** - Graphiques
- **WebSocket** - Communication temps réel

## 🎨 Fonctionnalités

### ✅ Implémentées
- [x] Authentification JWT
- [x] Dashboard avec statistiques
- [x] Liste des machines avec filtres
- [x] Détails des machines
- [x] Gestion du statut (active, en panne, maintenance)

### 🚧 À venir
- [ ] Événements en temps réel (WebSocket)
- [ ] Gestion des alertes
- [ ] Tickets de maintenance
- [ ] Graphiques et analytics
- [ ] Notifications push
- [ ] Mode hors ligne

## 🔐 Authentification

L'application utilise JWT pour l'authentification :
1. Login avec username/password
2. Réception du token JWT
3. Stockage sécurisé dans SharedPreferences
4. Envoi du token dans les headers : `Authorization: Bearer <token>`

## 🌐 Configuration Edge

Pour utiliser Microsoft Edge au lieu de Chrome :

1. Définir la variable d'environnement :
```bash
$env:CHROME_EXECUTABLE = "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"
```

2. Ou ajouter dans les variables système Windows :
   - Nom : `CHROME_EXECUTABLE`
   - Valeur : Chemin vers `msedge.exe`

## 📝 Notes de développement

### Endpoints API attendus

**User Service**
- POST `/users/login` - Connexion

**Machine Service**
- GET `/machines` - Liste des machines
- GET `/machines/{id}` - Détails d'une machine
- POST `/machines` - Créer une machine
- PUT `/machines/{id}` - Modifier une machine
- DELETE `/machines/{id}` - Supprimer une machine

**Event Service**
- GET `/events` - Liste des événements
- POST `/events` - Créer un événement
- WS `/ws` - WebSocket temps réel

**Alert Service**
- GET `/alerts` - Liste des alertes
- PUT `/alerts/{id}/resolve` - Résoudre une alerte

**Maintenance Service**
- GET `/maintenance` - Liste des tickets
- POST `/maintenance` - Créer un ticket
- PUT `/maintenance/{id}` - Modifier un ticket

## 🐛 Dépannage

### Erreur SDK constraint
```bash
# Vérifier que pubspec.yaml contient :
environment:
  sdk: ^3.11.0
```

### Erreur web support
```bash
flutter create .
```

### Erreur de connexion API
Vérifier que le backend est lancé et accessible sur l'URL configurée.

## 👥 Contributeurs

Votre nom - Projet d'examen

## 📄 Licence

Ce projet est réalisé dans le cadre d'un examen académique.
