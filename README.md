🛡️ Women Safety App

A Flutter-based mobile application designed to provide quick access to emergency assistance and safety features for women.

📱 About the Project

Women Safety App is a mobile application developed using Flutter and Dart to provide users with quick and accessible emergency assistance.

The application focuses on making emergency support simple and easy to access through a dedicated SOS button, emergency contacts, location sharing, and important emergency service numbers.

The main focus of the application is to make emergency assistance quick, accessible, and easy to use.

✨ Features
🚨 Emergency SOS

The application provides a dedicated Emergency SOS button for quick assistance.

When the user activates the Emergency button:

📞 The app automatically calls the first two saved emergency contacts
💬 An SOS message is automatically sent to all saved emergency contacts
📍 The message contains the user's current location
🗺️ The location is shared through a Google Maps link
👥 Emergency Contacts
Add and manage emergency contacts
Store multiple emergency contacts
View saved emergency contacts
The first two contacts are used for automatic emergency calls
SOS messages are sent to all saved emergency contacts
📍 Location Sharing

During an emergency, the application retrieves the user's current location and generates a Google Maps location link.

The location link is included in the SOS message sent to the saved emergency contacts.

📞 Emergency Numbers

The application provides quick access to important emergency services such as:

Police
Fire
Ambulance
Women Helpline
Emergency Services
🔥 Firebase Integration

Firebase is integrated into the application to support its backend-related functionality and configuration.

🎨 Simple and User-Friendly UI

The application provides a simple interface that allows users to quickly access important safety features during an emergency.

🚨 Emergency Workflow
User presses the Emergency SOS button.
The app retrieves the user's current location.
The app automatically calls the first two saved emergency contacts.
An SOS message is automatically sent to all saved emergency contacts.
The message contains a Google Maps link to the user's current location.
🛠️ Technologies Used
Flutter
Dart
Firebase
Android
Git & GitHub
📂 Project Structure
women_safety_app/
│
├── android/
├── ios/
├── lib/
│   ├── main.dart
│   ├── splash_screen.dart
│   └── firebase_options.dart
│
├── assets/
├── test/
├── web/
├── windows/
├── linux/
├── macos/
├── pubspec.yaml
└── README.md
📸 Application Screenshots
🏠 Home Screen

The main screen provides quick access to the Emergency SOS functionality and other safety features.

👥 Emergency Contacts

Users can add and manage the emergency contacts that will receive emergency assistance.

🚨 Emergency SOS

The Emergency SOS feature automatically calls the first two saved emergency contacts and sends an SOS message to all saved emergency contacts.

💬 SOS Message

The automatic SOS message contains the user's current location through a Google Maps link, allowing emergency contacts to identify the user's location.

📞 Emergency Numbers

The application provides quick access to important emergency service numbers.

🚀 Getting Started
Prerequisites

Make sure you have the following installed:

Flutter SDK
Dart SDK
Android Studio or VS Code
Git
Installation

Clone the repository:

git clone https://github.com/snehalterdalkar-blip/women_safety_app.git

Navigate to the project directory:

cd women_safety_app

Install dependencies:

flutter pub get

Run the application:

flutter run
👩‍💻 Development

This project was designed and developed independently, including the application structure, user interface, emergency SOS functionality, emergency contact management, location sharing, and Firebase integration.

🔮 Future Improvements
📍 Real-time location sharing with trusted contacts
🚨 Enhanced emergency alert system
📱 Background emergency detection
🔔 Push notifications for emergency alerts
🆘 Additional safety resources
🎨 Enhanced UI and accessibility
🔐 Improved data security and privacy
📌 Project Status

Completed

The current version implements the core emergency assistance features, including emergency contact management, SOS calling, automated SMS alerts, location sharing, and emergency service numbers.

