// Firebase SDK (add these lines)
// For Firebase JS SDK v7.20.0 and later, measurementId is optional
import { initializeApp } from "firebase/app";
import {
  getAuth,
  GoogleAuthProvider,
  signInWithPopup,
  onAuthStateChanged,
} from "firebase/auth";

// Your web app's Firebase configuration
const firebaseConfig = {
  apiKey: "AIzaSyBpMWelPTiUlrvoMM_TBx4AFnYmwkE7Ozk",
  authDomain: "inventory-app-29fc2.firebaseapp.com",
  databaseURL:
    "https://inventory-app-29fc2-default-rtdb.asia-southeast1.firebasedatabase.app",
  projectId: "inventory-app-29fc2",
  storageBucket: "inventory-app-29fc2.firebasestorage.app",
  messagingSenderId: "40401298274",
  appId: "1:40401298274:web:ecb4c9ed0f55a0ef06423b",
  measurementId: "G-VGWTNXJ86M",
};

// Initialize Firebase
const app = initializeApp(firebaseConfig);
const auth = getAuth(app);
const googleProvider = new GoogleAuthProvider();

// Function to handle Google Sign-In
window.signInWithGoogle = function () {
  signInWithPopup(auth, googleProvider)
    .then((result) => {
      // This gives you a Google Access Token. You can use it to access the Google API.
      const credential = GoogleAuthProvider.credentialFromResult(result);
      const token = credential.accessToken;
      // The signed-in user info.
      const user = result.user;

      console.log("Firebase user signed in:", user);
      console.log("Firebase ID Token:", user.accessToken); // AccessToken for database auth

      // Send the Firebase ID Token to your Rails backend for verification
      sendFirebaseIdTokenToRails(user.accessToken); // We will define this function
    })
    .catch((error) => {
      // Handle Errors here.
      const errorCode = error.code;
      const errorMessage = error.message;
      // The email of the user's account used.
      const email = error.customData.email;
      // The AuthCredential type that was used.
      const credential = GoogleAuthProvider.credentialFromError(error);

      console.error("Google Sign-In Error:", errorMessage);
      alert("Google Sign-In failed: " + errorMessage);
    });
};

// Function to send Firebase ID Token to Rails Backend
function sendFirebaseIdTokenToRails(idToken) {
  fetch("/auth/google/callback", {
    // This will be your Rails endpoint
    method: "POST",
    headers: {
      "Content-Type": "application/json",
      "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content, // For Rails CSRF protection
    },
    body: JSON.stringify({ id_token: idToken }),
  })
    .then((response) => response.json())
    .then((data) => {
      if (data.status === "success") {
        console.log("Backend verification successful:", data.message);
        // Redirect or update UI as needed after successful backend login
        window.location.href = "/"; // Example: redirect to homepage
      } else {
        console.error("Backend verification failed:", data.message);
        alert("Login failed: " + data.message);
      }
    })
    .catch((error) => {
      console.error("Error sending token to backend:", error);
      alert("An error occurred during login.");
    });
}

// Optional: Keep track of the user's sign-in status (good for overall app state)
onAuthStateChanged(auth, (user) => {
  if (user) {
    // User is signed in, see docs for a list of available properties
    // https://firebase.google.com/docs/reference/js/firebase.User
    console.log("User is signed in:", user.uid);
  } else {
    // User is signed out
    console.log("User is signed out.");
  }
});

// Make signInWithGoogle accessible globally if not using a module system
window.signInWithGoogle = signInWithGoogle;
