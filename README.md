📱 How to Run This App Locally
Follow these steps to install and run the app on your local machine or emulator.

✅ Requirements
Before running the app, make sure you have:

Flutter SDK installed (Flutter Install Guide)

An IDE like Android Studio or VS Code

A connected device or emulator

A Firebase project set up (optional if not using your own Firebase)

🔧 Steps to Run
Clone the Repository

bash
Copy
Edit
git clone https://github.com/your-username/senior_project_2.git
cd senior_project_2
Install Dependencies

bash
Copy
Edit
flutter pub get
Set Up Firebase

Download the google-services.json file from our Firebase project and place it in:

bash
Copy
Edit
android/app/google-services.json
(Optional for iOS) Download GoogleService-Info.plist and place it in:

swift
Copy
Edit
ios/Runner/GoogleService-Info.plist
Note: If you're not using our Firebase, you can set up your own project on Firebase Console and configure Authentication, Firestore, etc.

Environment Variables

If the app uses a .env file for secrets or keys, create a file named .env in the root folder. Example:

ini
Copy
Edit
API_KEY=your_api_key_here
Run the App

bash
Copy
Edit
flutter run
🔐 Firebase Access
This app uses Firebase features such as:

Firebase Authentication (e.g., phone login)

Firestore for storing service and booking data

(Add more if needed: e.g., Storage, Functions)

If you'd like access to our Firebase project for testing, contact us directly.
This app was developed as part of our senior project at King Fahd University of Petroleum and Minerals (KFUPM). It connects customers with service providers through a Flutter frontend and Firebase backend.

