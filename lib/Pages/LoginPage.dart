import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'HomePage.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isLoading = false;
  String errorMessage = "";
  String odooUrl = 'http://13.93.147.122:8069';

  Future<void> login() async {
    setState(() {
      _isLoading = true;
      errorMessage = "";
    });

    final String email = emailController.text.trim();
    final String password = passwordController.text.trim();
    print("Correo Electrónico ingresado: $email");
    print("Contraseña ingresada: $password");

    final String loginUrl = '$odooUrl/web/session/authenticate';

    final Map<String, dynamic> data = {
      "params": {
        "db": "odoo_scholl",
        "login": email,
        "password": password,
      }
    };

    try {
      final response = await http.post(
        Uri.parse(loginUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> result = jsonDecode(response.body);

        String? sessionId;
        if (response.headers.containsKey('set-cookie')) {
          final cookies = response.headers['set-cookie'];
          final sessionIdMatch = RegExp(r"session_id=([^;]+)").firstMatch(cookies ?? "");
          if (sessionIdMatch != null) {
            sessionId = sessionIdMatch.group(1);
            print("session_id: $sessionId");
          }
        }

        if (result['result'] != null) {
          final userSession = result['result'];
          print("Sesión iniciada. Usuario ID: ${userSession['uid']}");

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomePage(sessionId: sessionId)),
          );
        } else {
          setState(() {
            errorMessage = "Credenciales inválidas.";
          });
        }
      } else {
        setState(() {
          errorMessage = "Error en la conexión con el servidor. Código: ${response.statusCode}";
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = "No se pudo conectar al servidor. Verifique su conexión.";
      });
      print("Error capturado: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, 
      body: Stack(
        children: [
          Positioned.fill(child: Image.asset('assets/images/imagen9.jpeg', fit: BoxFit.cover,),),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Título del formulario, centrado
                SizedBox(height: 100),
                Align(
                  alignment: Alignment.topCenter,
                  child: Text('AGENDA 2024',style: TextStyle(fontSize: 45,fontWeight: FontWeight.bold, color: Colors.black,),),
                ),
                SizedBox(height: 40),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Correo Electrónico',
                    labelStyle: TextStyle(color: Colors.black),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    fillColor: Colors.white.withOpacity(0.5),
                    filled: true,
                  ),
                ),

                SizedBox(height: 10),
                TextField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: 'Contraseña',
                    labelStyle: TextStyle(color: Colors.black),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    fillColor: Colors.white.withOpacity(0.5),
                    filled: true,
                  ),
                  obscureText: true,
                ),
                SizedBox(height: 20),
                // Botón de inicio de sesión
                ElevatedButton(
                  onPressed: _isLoading ? null : login,
                  child: _isLoading ? CircularProgressIndicator() : Text("Iniciar Sesión",style: TextStyle( color: Colors.black),),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 165, 200, 194), // Color del botón
                    minimumSize: Size(double.infinity,50), 
                  ),
                ),
                Spacer(),
                if (errorMessage.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Text(errorMessage,style: TextStyle(color: Colors.red),textAlign: TextAlign.center,),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}