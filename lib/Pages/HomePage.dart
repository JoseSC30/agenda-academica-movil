import 'package:flutter/material.dart';
import 'LoginPage.dart';  // Asegúrate de importar tu LoginPage
import 'ComunicadosPage.dart';
import 'AudioTextoIAPage.dart';
import 'ImagenIAPage.dart';

class HomePage extends StatelessWidget {
  final String? sessionId;
  HomePage({Key? key, required this.sessionId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 103, 127, 118),
      ),
      
      // Drawer para la navegación
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 103, 127, 118),
                //color: const Color.fromARGB(255, 165, 200, 194),
              ),
              child: Text('Menú Agenda',style: TextStyle(color: Colors.white,fontSize: 24),
              ),
            ),

            // Opciones de navegación
            ListTile(
              title: Text('Comunicados'),
              onTap: () {
                Navigator.push(context,MaterialPageRoute(builder: (context) => ComunicadosPage(sessionId: sessionId!),),);
              },
            ),
            ListTile(
              title: Text('Audio y Texto IA'),
              onTap: () {
                Navigator.push(context,MaterialPageRoute(builder: (context) => AudioTextoIAPage()),);
              },
            ),
            ListTile(
              title: Text('Imagenes IA'),
              onTap: () {
                Navigator.push(context,MaterialPageRoute(builder: (context) => ImagenIAPage()),);
              },
            ),
            ListTile(
              title: Text('Cerrar sesión'),
              onTap: () {
                Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => LoginPage()),);
              },
            )
          ],
        ),
      ),
      
      // Contenido principal de la página
      body: Stack(
        children: [
          Positioned.fill(child: Image.asset('assets/images/imagen7.jpeg', fit: BoxFit.cover),),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    color: Colors.white.withOpacity(0.6), // Fondo semi-transparente
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Bienvenido...",style: TextStyle(fontSize: 30, color: Colors.black),),
                  ),
                ),
               // SizedBox(height: 10),
                //Text("session_id: $sessionId",style: TextStyle(fontSize: 16,color: Colors.black,),),
                Text(".",style: TextStyle(fontSize: 20,color: Colors.black,),),
              ],
            ),
          ),
        ],
      ),
    );
  }
}



