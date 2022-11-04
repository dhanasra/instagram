import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'app/app.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
      options: const FirebaseOptions(
          projectId: 'instagram-d19fa',
          apiKey: 'AIzaSyCmA4rwt93HEKbQGEkCujxWHrDkqewq5qM',
          messagingSenderId: '572780497261',
          appId: '1:572780497261:android:46bfbdddaaecbecb6ab264'
      )
  );

  await EasyLocalization.ensureInitialized();

  runApp(
      EasyLocalization(
          supportedLocales: const [Locale('en'), Locale('ta')],
          path: 'assets/language',
          fallbackLocale: const Locale('ta'),
          child:  const App() ));
}
