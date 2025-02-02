import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'Pages/Notificaciones/NotificationService.dart';
import 'Pages/LoginPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Inicializa Flutter en modo async
  await dotenv.load(); // Carga las variables de entorno

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('Firebase inicializado correctamente');
  } catch (e) {
    print('Error al inicializar Firebase: $e');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: NotificationInitializer(child: LoginPage()),
    );
  }
}

class NotificationInitializer extends StatefulWidget {
  final Widget child;

  const NotificationInitializer({Key? key, required this.child}) : super(key: key);

  @override
  _NotificationInitializerState createState() => _NotificationInitializerState();
}

class _NotificationInitializerState extends State<NotificationInitializer> {
  @override
  void initState() {
    super.initState();
    // Inicializa NotificationService con un contexto válido
    NotificationService().initialize(context);
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}


