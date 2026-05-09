# 🚀 SmartFactory Monitor - Setup Guide

## ✅ Project Status

All files have been successfully recreated and the project is ready to run!

## 📦 What Was Created

### Core Architecture
- **Config** - API configuration (`lib/config/api_config.dart`)
- **Models** - Data structures for User, Machine, Event, Alert, MaintenanceTicket
- **Services** - Business logic for Authentication and Machine management
- **Screens** - UI for Login, Dashboard, and Machines list
- **Utils** - Logging utilities

### Files Structure
```
lib/
├── config/api_config.dart
├── models/
│   ├── user.dart
│   ├── machine.dart
│   ├── event.dart
│   ├── alert.dart
│   └── maintenance_ticket.dart
├── services/
│   ├── auth_service.dart
│   └── machine_service.dart
├── screens/
│   ├── login_screen.dart
│   ├── dashboard_screen.dart
│   └── machines_screen.dart
├── utils/
│   └── logger.dart
└── main.dart
```

## 🎯 Quick Start

### 1. Install Dependencies
```bash
flutter pub get
```

### 2. Run the App
```bash
# On Edge
flutter run -d edge

# On Chrome
flutter run -d chrome
```

### 3. Build for Web
```bash
flutter build web
```

## 🔧 Configuration

### Update Backend URLs
Edit `lib/config/api_config.dart`:
```dart
static const String baseUrl = 'http://localhost:8000';
```

## 📋 Features Implemented

✅ **Authentication**
- JWT token management
- Secure login/logout
- Local storage with SharedPreferences

✅ **Dashboard**
- Machine statistics (total, active, failed, maintenance)
- Quick action buttons
- User information display

✅ **Machines Management**
- List all machines
- Filter by status (active, failed, maintenance)
- View machine details
- Machine status indicators

## 🚧 Features To Implement

- [ ] Real-time events (WebSocket)
- [ ] Alerts management
- [ ] Maintenance tickets
- [ ] Analytics and charts
- [ ] Push notifications
- [ ] Offline mode

## 🔐 Authentication Flow

1. User enters username/password on Login screen
2. Credentials sent to `POST /users/login`
3. Backend returns JWT token
4. Token stored in SharedPreferences
5. Token included in all API requests as `Authorization: Bearer <token>`

## 📱 Screens Overview

### Login Screen
- Username and password input
- Form validation
- Error handling
- Beautiful gradient background

### Dashboard Screen
- Welcome message with user info
- 4 stat cards (Total, Active, Failed, Maintenance)
- Quick action buttons
- Refresh functionality

### Machines Screen
- List of all machines
- Filter chips (All, Active, Failed, Maintenance)
- Machine cards with status badges
- Bottom sheet details view
- Edit and history buttons

## 🌐 API Endpoints Expected

### User Service
- `POST /users/login` - Login

### Machine Service
- `GET /machines` - List all
- `GET /machines/{id}` - Get one
- `POST /machines` - Create
- `PUT /machines/{id}` - Update
- `DELETE /machines/{id}` - Delete

### Event Service
- `GET /events` - List events
- `POST /events` - Create event
- `WS /ws` - WebSocket connection

### Alert Service
- `GET /alerts` - List alerts
- `PUT /alerts/{id}/resolve` - Resolve alert

### Maintenance Service
- `GET /maintenance` - List tickets
- `POST /maintenance` - Create ticket
- `PUT /maintenance/{id}` - Update ticket

## 🐛 Troubleshooting

### App won't start
```bash
flutter clean
flutter pub get
flutter run -d edge
```

### API connection errors
- Check backend is running on `http://localhost:8000`
- Update `api_config.dart` with correct URL
- Check network connectivity

### Build errors
```bash
flutter pub get
flutter analyze
```

## 📝 Next Steps

1. **Connect to Backend**
   - Ensure all microservices are running
   - Update API URLs in `api_config.dart`

2. **Test Login**
   - Create test user in backend
   - Test authentication flow

3. **Add More Screens**
   - Events screen with real-time updates
   - Alerts management
   - Maintenance tickets

4. **Implement WebSocket**
   - Real-time machine events
   - Live notifications

## 💡 Tips

- Use `flutter run -d edge` for development
- Check console output for API errors
- Use Flutter DevTools for debugging
- Test on different screen sizes

## 📞 Support

For issues or questions, check:
- Flutter documentation: https://flutter.dev
- Dart documentation: https://dart.dev
- Project README.md for more details
