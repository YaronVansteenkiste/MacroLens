# MacroLens

<p align="center">
  <img src="assets/icons/icon.png" alt="MacroLens Logo" width="150">
</p>

MacroLens is a Flutter application designed to help you track what you eat. This app is developed as part of a college project at **Thomas More** for the course **Native Apps**.

## Features

- **Barcode Scanner**: Quickly scan food items to get nutritional information.
- **Meal Tracking**: Track your meals throughout the day.
- **Nutritional Summary**: Get a daily summary of your nutritional intake.
- **User Authentication**: Secure login and registration using Firebase.

## Screenshots

<p align="center">
  <img src="assets/showcase/homescreen.png" alt="Home Screen" width="250">
  <img src="assets/showcase/dashboard.png" alt="Dashboard" width="250">
  <img src="assets/showcase/profile.png" alt="Profile" width="250">
  <img src="assets/showcase/scanning.png" alt="Scanning" width="250">
</p>

## Getting Started

To get started with MacroLens, follow these steps:

1. **Clone the repository**:
    ```bash
    git clone https://github.com/YaronVansteenkiste/MacroLens-Eindopdracht.git
    cd macrolens_eindopdracht
    ```

2. **Install dependencies**:
    ```bash
    flutter pub get
    ```
3. **Get API from Firebase
    Get the following data and save in .env file :
     ```js
    API_KEY=
    AUTH_DOMAIN=
    PROJECT_ID=
    STORAGE_BUCKET=
    MESSAGING_SENDER_ID=
    APP_ID=
    MEASUREMENT_ID=

    WEB_API_KEY=
    WEB_APP_ID=
    WEB_MESSAGING_SENDER_ID=
    WEB_PROJECT_ID=
    WEB_AUTH_DOMAIN=
    WEB_STORAGE_BUCKET=
    WEB_MEASUREMENT_ID=
    
    ANDROID_API_KEY=
    ANDROID_APP_ID=
    ANDROID_MESSAGING_SENDER_ID=
    ANDROID_PROJECT_ID=
    ANDROID_STORAGE_BUCKET=
    
    IOS_API_KEY=
    IOS_APP_ID=
    IOS_MESSAGING_SENDER_ID=
    IOS_PROJECT_ID=
    IOS_STORAGE_BUCKET=
    IOS_BUNDLE_ID=
    
    MACOS_API_KEY=
    MACOS_APP_ID=
    MACOS_MESSAGING_SENDER_ID=
    MACOS_PROJECT_ID=
    MACOS_STORAGE_BUCKET=
    MACOS_BUNDLE_ID=
    
    WINDOWS_API_KEY=
    WINDOWS_MESSAGING_SENDER_ID=
    WINDOWS_PROJECT_ID=
    WINDOWS_AUTH_DOMAIN=
    WINDOWS_STORAGE_BUCKET=
    WINDOWS_MEASUREMENT_ID=
    ```

4. **Run the app**:
    ```bash
    flutter run
    ```

## Project Structure

```plaintext
lib/
├── app_state.dart
├── barcode_scanner.dart
├── bottom_nav_bar.dart
├── dashboard_page.dart
├── firebase_options.dart
├── food_detail_page.dart
├── home_content.dart
├── library.dart
├── login_page.dart
├── main.dart
├── meal_info.dart
├── profile_page.dart
├── register_page.dart
└── video_player.dart
```

## Test user credentials:
Contact me for .env, and put that in your root folder. 
The following account includes example data:
- **Email**: admin@macrolens.be
- **Password**: admin123
