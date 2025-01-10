import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:moocexam/todooo/todo.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: "AIzaSyDfbgTbxhZINNawAnUjYFFsl79SgmjFW3M",
        appId: "1:700804282933:android:4912e7b1895a0ea04b8f7c",
        messagingSenderId: " ",
        projectId: "moocexam",
        storageBucket: "moocexam.firebasestorage.app"
    ),
  );
  runApp(MaterialApp(home: TodoApppp(),
    debugShowCheckedModeBanner: false,));
}





