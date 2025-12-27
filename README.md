# 💬 KuraKani – Real-Time Chat Application

KuraKani is a real-time one-to-one chat application built using **Flutter** and **Firebase**.  
The project focuses on clean UI, real-time messaging, and proper state handling, making it suitable as a **portfolio-level Flutter project**.

---



## 📸 App Screenshots

### Login & Registration
![Login Screen](assets/login.png)
![Register Screen](assets/sign_up.png)

### Home & Chat
![Home Screen](assets/home.png)
![Dark Mode](assets/dark_mode.png)
![Chat page](assests/chat_page.png)
![Dark_Mode_chat_page](assets/dark_mode_page.png)

## 📌 Features

- 🔐 **User Authentication**  
  Login and registration using Firebase Authentication (Email & Password).

- 💬 **Real-Time Messaging**  
  One-to-one chat powered by Cloud Firestore with real-time updates.

- 🔍 **User Search**  
  Search registered users and start conversations instantly.

- 📜 **Auto Scroll Chat**  
  Automatically scrolls to the latest message, including correct behavior when the on-screen keyboard opens.

- 🌙 **Dark Mode Support**  
  Switch between light and dark themes dynamically for better user experience.
  Dark mode is implemented using Flutter's ThemeData with Provider to persist the theme across the app.

- 🧩 **Reusable UI Components**  
  Custom chat bubble widgets for sent and received messages.

- 🚪 **Logout Functionality**  
  Secure sign-out using Firebase Authentication.

---

## 🛠 Tech Stack

- **Frontend:** Flutter (Dart)
- **Backend:** Firebase
  - Firebase Authentication
  - Cloud Firestore
- **State Management:**  
  - Provider (for shared app-level state such as authentication)
  - StreamBuilder (for real-time Firestore data)
- **UI:** Material Design

---

## 📂 Project Structure 

lib
├── components
│   ├── chat_bubble.dart
│   ├── my_button.dart
│   ├── my_drawer.dart
│   ├── my_textfields.dart
│   └── user_tile.dart
├── firebase_options.dart
├── main.dart
├── models
│   └── message.dart
├── pages
│   ├── chat_page.dart
│   ├── home_page.dart
│   ├── login_page.dart
│   ├── register_page.dart
│   ├── search_user_page.dart
│   └── settings_page.dart
├── services
│   ├── auth
│   │   ├── auth_gate.dart
│   │   ├── auth_service.dart
│   │   └── login_or_register.dart
│   └── chat
│       └── chat_services.dart
└── theme
    ├── dark_mode.dart
    ├── light_mode.dart
    └── theme_provider.dart





The project follows a clear separation of **UI**, **services**, and **reusable components**, making it easy to maintain and extend.

---

## 🔐 Firebase Setup

1. Create a Firebase project
2. Enable **Authentication → Email/Password**
3. Enable **Cloud Firestore**
4. Add Firebase config files:
   - `google-services.json` (Android)
   - `GoogleService-Info.plist` (iOS)
5. Configure Firebase in your Flutter project

---



## 🚀 Getting Started

```bash
# Clone the repository
git clone https://github.com/39laxmann/KuraKani_.git

# Navigate to the project directory
cd KuraKani_

# Install dependencies
flutter pub get

# Run the app
flutter run


