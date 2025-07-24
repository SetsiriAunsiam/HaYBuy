import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:local_shopee/firebase_options.dart';
import 'package:local_shopee/pages/tap.dart';
import 'package:local_shopee/pages/sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:local_shopee/config/environment_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize environment configuration
  await EnvironmentConfig.initialize();
  
  // Print environment info in debug mode
  if (EnvironmentConfig.instance.enableDebugMode) {
    EnvironmentConfig.instance.printAllEnvVars();
  }

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: EnvironmentConfig.instance.appName,
      debugShowCheckedModeBanner: !EnvironmentConfig.instance.isProduction,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const AuthWrapper(),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // If the connection is still waiting, show a loading spinner
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // If user is logged in, show the main app
        if (snapshot.hasData) {
          return const TapBar();
        }

        // If user is not logged in, show sign in page
        return const SignInPage();
      },
    );
  }
}
