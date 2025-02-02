import 'package:flutter/material.dart';

class ImagenIAPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Imagen IA", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 103, 127, 118),
      ),
      body: Center(child: Text("Contenido de la Vista ")),
    );
  }
}
