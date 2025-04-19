import 'package:firebase_core/firebase_core.dart' show Firebase;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruity/Register/cubit/bloc_observer.dart' show MyBlocObserver;
import 'package:fruity/layout/home_screen.dart';
import 'package:google_sign_in/google_sign_in.dart' show GoogleSignIn;
import 'Login/login_screen.dart';
import 'compoents/components.dart' show setup;
import 'firebase_options.dart' show DefaultFirebaseOptions;
import 'layout/Cubit/cubit.dart';
import 'network/local/cache helper.dart';
import 'onBoarding/onboarding_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize local cache
  await CacheHelper.init();

  // Initialize dependency injection
  setup();

  // Configure Google Sign-In
  final GoogleSignIn googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
    clientId: '', // Only needed for iOS/web
  );

  // Set up BLoC observer
  Bloc.observer = MyBlocObserver();

  // Determine initial route
  bool? onBoarding = CacheHelper.getData(key: 'onBoarding') as bool?;
  String? token = CacheHelper.getData(key: 'token') as String?;
  bool? isGoogleSignedIn = CacheHelper.getData(key: 'isGoogleSignedIn') as bool?;

  Widget startWidget = const OnBoardingScreen(); // Default

  if (onBoarding != null && onBoarding) {
    if ((token != null && token.isNotEmpty) ||
        (isGoogleSignedIn != null && isGoogleSignedIn)) {
      startWidget = const Home();
    } else {
      startWidget = const LoginScreen();
    }
  }

  runApp(MyApp(startWidget: startWidget));
}

class MyApp extends StatelessWidget {
  final Widget startWidget;
  const MyApp({super.key, required this.startWidget});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => ShopCubit(),
      child: MaterialApp(
        theme: ThemeData(
          fontFamily: 'Roboto',
          appBarTheme: const AppBarTheme(
            iconTheme: IconThemeData(color: Colors.black),
            backgroundColor: Colors.white,
            elevation: 0,
            titleTextStyle: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            actionsIconTheme: IconThemeData(color: Colors.black),
          ),
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue,
            brightness: Brightness.light,
          ),
        ),
        debugShowCheckedModeBanner: false,
        home: startWidget,
      ),
    );
  }
}