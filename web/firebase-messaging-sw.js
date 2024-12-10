// Give the service worker access to Firebase Messaging.
// Note that you can only use Firebase Messaging here.
importScripts('https://www.gstatic.com/firebasejs/9.6.0/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/9.6.0/firebase-messaging-compat.js');

// Initialize the Firebase app in the service worker
firebase.initializeApp({
  apiKey: "AIzaSyB_nQ7kDSgHik_3OBQBH4_ofc-XeYcI-kw",
  authDomain: "gamuda-flutter-homework-01.firebaseapp.com",
  projectId: "gamuda-flutter-homework-01",
  storageBucket: "gamuda-flutter-homework-01.appspot.com",
  messagingSenderId: "1070221102883",
  appId: "1:1070221102883:web:b85a5d091de284241ac696"
});
