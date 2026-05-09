# SmartFactory Monitor 🏭

Une application complète de monitoring industriel basée sur une **architecture microservices** avec **Kafka**, **PostgreSQL**, et un **frontend Flutter**.

## 🎯 Objectif

SmartFactory Monitor permet de :
- ✅ Gérer les machines industrielles
- ✅ Suivre les événements en temps réel
- ✅ Générer des alertes automatiques
- ✅ Visualiser les données sur un dashboard

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    Frontend Flutter (Web)                   │
│                    http://localhost:8080                    │
└────────────────────────┬────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────┐
│                    Gateway API (Port 8000)                  │
│              Point d'entrée unique pour tous les services   │
└────────────────────────┬────────────────────────────────────┘
                         │
        ┌────────────────┼────────────────┬──────────────┐
        ▼                ▼                ▼              ▼
    ┌────────┐      ┌────────┐      ┌────────┐    ┌────────┐
    │ User   │      │Machine │      │ Event  │    │ Alert  │
    │Service │      │Service │      │Service │    │Service │
    │(8001)  │      │(8002)  │      │(8003)  │    │(8004)  │
    └────────┘      └────────┘      └────────┘    └────────┘
        │                │                │            │
        └────────────────┼────────────────┴────────────┘
                         │
                         ▼
                    ┌─────────────┐
                    │  PostgreSQL │
                    │  (4 bases)  │
                    └─────────────┘
                         │
                         ▼
                    ┌─────────────┐
                    │   Kafka     │
                    │  (Messaging)│
                    └─────────────┘
```

## 🚀 Démarrage rapide

### 1. Cloner le repository

```bash
git clone https://github.com/kenza21hannafi/SmartFactory-Monitor.git
cd SmartFactory-Monitor
```

### 2. Installer les dépendances

```bash
# Backend
cd SmartFactory-monitor
pip install -r user_service/requirements.txt
pip install -r machine_service/requirements.txt
pip install -r event_service/requirements.txt
pip install -r alert_service/requirements.txt
pip install -r gateway/requirements.txt

# Frontend
cd ../SmartFactory_front
flutter pub get
```

### 3. Configurer les bases de données

```bash
# Créer les bases de données PostgreSQL
psql -U postgres -c "CREATE DATABASE smartfactory_users ENCODING 'UTF8';"
psql -U postgres -c "CREATE DATABASE smartfactory_machines ENCODING 'UTF8';"
psql -U postgres -c "CREATE DATABASE smartfactory_events ENCODING 'UTF8';"
psql -U postgres -c "CREATE DATABASE smartfactory_alerts ENCODING 'UTF8';"
```

### 4. Démarrer les services

Voir [GETTING_STARTED.md](SmartFactory-monitor/GETTING_STARTED.md) pour les instructions détaillées.

## 📚 Documentation

- **[Guide de Démarrage](SmartFactory-monitor/GETTING_STARTED.md)** - Instructions complètes
- **[Architecture](SmartFactory-monitor/ARCHITECTURE.md)** - Détails techniques
- **[Backend README](SmartFactory-monitor/README.md)** - Documentation des services
- **[Gateway API](SmartFactory-monitor/gateway/README.md)** - Documentation du Gateway

## 🛠️ Technologies utilisées

### Backend
- **FastAPI** - Framework web Python
- **SQLAlchemy** - ORM pour les bases de données
- **PostgreSQL** - Base de données relationnelle
- **Apache Kafka** - Message broker
- **Uvicorn** - Serveur ASGI

### Frontend
- **Flutter** - Framework mobile/web
- **Dart** - Langage de programmation
- **HTTP** - Communication avec le backend

### DevOps
- **Docker** - Conteneurisation
- **Docker Compose** - Orchestration
- **Git** - Contrôle de version

## 📊 Flux de données

```
1. Machine Service détecte un changement
   ↓
2. Envoie un événement à Event Service
   ↓
3. Event Service publie dans Kafka
   ↓
4. Alert Service consomme l'événement
   ↓
5. Crée une alerte si nécessaire
   ↓
6. Frontend affiche l'alerte en temps réel
```

## 🔐 Sécurité

- ✅ Authentification par token
- ✅ Validation des entrées
- ✅ CORS configuré
- ⚠️ À implémenter : JWT, hachage des mots de passe

## 📦 Services

| Service | Port | Description |
|---------|------|-------------|
| Gateway | 8000 | Point d'entrée unique |
| User | 8001 | Authentification |
| Machine | 8002 | Gestion des machines |
| Event | 8003 | Événements & Kafka Producer |
| Alert | 8004 | Alertes & Kafka Consumer |
| Frontend | 8080 | Application web |

## 🧪 Tests

```bash
# Tester le flux complet
cd SmartFactory-monitor
python test_flow.py
```

## 🐳 Docker

```bash
# Démarrer tous les services
docker-compose up -d

# Démarrer le consumer Kafka
docker-compose exec alert-service python consumer.py
```

## 📝 Identifiants par défaut

- **Username:** admin
- **Password:** admin123

## 🤝 Contribution

Les contributions sont bienvenues ! Veuillez :

1. Fork le repository
2. Créer une branche (`git checkout -b feature/AmazingFeature`)
3. Committer vos changements (`git commit -m 'Add AmazingFeature'`)
4. Pousser vers la branche (`git push origin feature/AmazingFeature`)
5. Ouvrir une Pull Request

## 📄 Licence

Ce projet est sous licence MIT.

## 👨‍💻 Auteur

**kenza21hannafi**

## 📞 Support

Pour toute question ou problème :
- Ouvrez une [issue](https://github.com/kenza21hannafi/SmartFactory-Monitor/issues)
- Consultez la [documentation](SmartFactory-monitor/GETTING_STARTED.md)

## 🎓 Apprentissages clés

Ce projet démontre :
- ✅ Architecture microservices
- ✅ Communication asynchrone avec Kafka
- ✅ API Gateway pattern
- ✅ Bases de données distribuées
- ✅ Frontend moderne avec Flutter
- ✅ Containerisation avec Docker
- ✅ Gestion des événements en temps réel

---

**Merci d'utiliser SmartFactory Monitor ! 🚀**
