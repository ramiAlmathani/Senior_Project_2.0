# 📱 Senior Projec (Handz)

A complete Flutter + Firebase mobile application developed as a senior project at **King Fahd University of Petroleum and Minerals (KFUPM)**.

---

## 🚀 How to Run the App Locally

Follow the steps below to install and run the app on your device or emulator.

### ✅ Requirements

- [Flutter SDK](https://docs.flutter.dev/get-started/install)
- Android Studio or VS Code
- A physical or virtual device
- Firebase project access (or your own Firebase setup)

---

### 🔧 Setup Instructions

#### 1. Clone the Repository

```bash
git clone https://github.com/your-username/senior_project_2.git
cd senior_project_2
2. Install Dependencies
bash
Copy
Edit
flutter pub get
3. Firebase Configuration
Download google-services.json from the Firebase Console.

Place it in the following directory:

bash
Copy
Edit
android/app/google-services.json
✅ (Optional for iOS)
Download GoogleService-Info.plist and place it in:

swift
Copy
Edit
ios/Runner/GoogleService-Info.plist
🔒 You can also set up your own Firebase project and enable:

Authentication

Firestore

Any other required services

4. Set Up Environment Variables (If Required)
If the project uses a .env file for secrets or config:

Create a file called .env in the root directory.

Example content:

ini
Copy
Edit
API_KEY=your_api_key_here
5. Run the App
bash
Copy
Edit
flutter run
This will launch the app on your connected device or emulator.

