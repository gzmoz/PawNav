import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pawnav/app/router.dart';
import 'package:pawnav/app/supabase_auth_listener.dart';
import 'package:pawnav/core/services/fcm_token_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app/auth/auth_gate.dart';


void main() async{
  FlutterError.onError = (FlutterErrorDetails details) {
    debugPrint(' FLUTTER ERROR ');
    debugPrint(details.exceptionAsString());
    debugPrint(details.stack.toString());
  };

  WidgetsFlutterBinding.ensureInitialized();

  //connect to the Supabase
  await Supabase.initialize(
    url: 'https://vhiiafjiezojyschiaia.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZoaWlhZmppZXpvanlzY2hpYWlhIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjE3NzA3ODAsImV4cCI6MjA3NzM0Njc4MH0.Z38WDjOG5wdVLOQnkccz1pD0zO2EA8I3tJYwIYwvI7s',
  );
  SupabaseAuthListener.initialize();

  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  //await FcmTokenService.init();




  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.immersiveSticky, // alt barı gizler, kaybolmaz
  );

  await dotenv.load(fileName: ".env");

  runApp(
    const AuthGate(
      child: MyApp(),
    ),
  );
  // runApp(const MyApp());
}

init() {
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      title: 'PawNav',
      theme: ThemeData(
        fontFamily: 'Nunito',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      //home: const SplashScreen(),

    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final supabase = Supabase.instance.client;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              "test",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),

    );
  }


}
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}


