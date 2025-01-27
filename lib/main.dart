import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:udemy_chat_app/firebase_options.dart';
import 'package:udemy_chat_app/firestore/room_firestore.dart';
import 'package:udemy_chat_app/firestore/user_firestore.dart';
import 'package:udemy_chat_app/pages/top_page.dart';
import 'package:udemy_chat_app/utils/shared_prefs.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await SharedPrefs.setPrefsInstance();
  String? uid = SharedPrefs.fetchUid();
  if (uid == null) await UserFirestore.createUser();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const TopPage(),
    );
  }
}
