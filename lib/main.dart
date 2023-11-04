import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stars/firebase_options.dart';
import 'package:stars/mainpage.dart';
import 'package:stars/pages/loginpage.dart';

import 'models/colorpallet.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    const ProviderScope(
      child: Stars(),
    ),
  );
}

class Stars extends ConsumerWidget {
  const Stars({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasData) {
            return const MainPage();
          } else {
            return const LoginPage();
          }
        },
      ),
      theme: ThemeData().copyWith(
        useMaterial3: true,
        colorScheme: LightColorPallete.lightThemeColor,
        textTheme: LightColorPallete.textTheme,
        iconTheme: LightColorPallete.iconTheme,
        chipTheme: LightColorPallete.chipTheme,
        elevatedButtonTheme: LightColorPallete.elevatedButtonTheme,
        textButtonTheme: LightColorPallete.textButtonTheme,
        scaffoldBackgroundColor: LightColorPallete.backgroundColor,
        shadowColor: LightColorPallete.textColor,
      ),
      darkTheme: ThemeData.dark().copyWith(
        useMaterial3: true,
        colorScheme: DarkColorPallet.themeColor,
        textTheme: DarkColorPallet.textTheme,
        iconTheme: DarkColorPallet.iconTheme,
        chipTheme: DarkColorPallet.chipTheme,
        elevatedButtonTheme: DarkColorPallet.elevatedButtonTheme,
        textButtonTheme: DarkColorPallet.textButtonTheme,
        scaffoldBackgroundColor: DarkColorPallet.backgroundColor,
        shadowColor: DarkColorPallet.textColor,
      ),
      // showPerformanceOverlay: true,
    );
  }
}
