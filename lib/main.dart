import 'package:drag/theme/app_theme.dart';
import 'package:drag/utils/firebase_options_web.dart';
import 'package:drag/viewmodels/auth_viewmodel.dart';
import 'package:drag/viewmodels/task_viewmodel.dart';
import 'package:drag/views/auth_screen/auth_screen.dart';
import 'package:drag/views/home_screen.dart';
import 'package:drag/views/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    // 웹용 Firebase 초기화 옵션
    options();
  } else {
    // 모바일용 Firebase 자동 초기화
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_)=> AuthViewModel()),
        ChangeNotifierProvider(create: (_)=> TaskViewModel()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: AppTheme.lightTheme,
        // darkTheme: AppTheme.darkTheme,
        home: SplashScreen(),
      ),
    );
  }
}