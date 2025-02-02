/*import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class NuevoComunicadoPage extends StatefulWidget {
  final String sessionId;

  NuevoComunicadoPage({required this.sessionId});

  @override
  _NuevoComunicadoPageState createState() => _NuevoComunicadoPageState();
}

class _NuevoComunicadoPageState extends State<NuevoComunicadoPage> {
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();
  final TextEditingController _fechaController = TextEditingController();
  bool _isSubmitting = false;

  // Función para mostrar el DatePicker y seleccionar la fecha
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // Fecha inicial
      firstDate: DateTime(2020), // Fecha mínima seleccionable
      lastDate: DateTime(2101), // Fecha máxima seleccionable
    );
    if (picked != null && picked != DateTime.now()) {
      setState(() {
        _fechaController.text = "${picked.toLocal()}".split(' ')[0]; // Formato yyyy-mm-dd
      });
    }
  }

  // Función para crear el comunicado
  Future<void> crearComunicado() async {
    //final url = Uri.parse('http://13.93.147.122:8069/api/comunicados/nuevo');
    final url = Uri.parse('http://10.0.2.2:8069/api/comunicados/general');

    setState(() {
      _isSubmitting = true;
    });

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Cookie': 'session_id=${widget.sessionId}',
        },
        body: jsonEncode({
          'nombre': _nombreController.text,
          'descripcion': _descripcionController.text,
          'fecha': _fechaController.text, // Incluir la fecha
          'visto': false, // Por defecto, no visto
        }),
      );

      if (response.statusCode == 200) {
        Navigator.pop(context, true); // Regresar a la pantalla anterior si la creación fue exitosa
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al crear el comunicado')),
        );
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Crear Comunicado")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _nombreController, decoration: InputDecoration(labelText: "Nombre"),),
            TextField(controller: _descripcionController, decoration: InputDecoration(labelText: "Descripción"),maxLines: 3,),
            TextField(controller: _fechaController, decoration: InputDecoration(labelText: "Fecha",hintText: "Seleccione una fecha",),
              readOnly: true, 
              onTap: () => _selectDate(context), // Mostrar el selector de fecha
            ),
            SizedBox(height: 20),

            ElevatedButton(
              onPressed: _isSubmitting ? null : crearComunicado,
              child: _isSubmitting
                  ? CircularProgressIndicator()
                  : Text("Guardar Comunicado"),
            ),
          ],
        ),
      ),
    );
  }
} */


import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class NuevoComunicadoPage extends StatefulWidget {
  final String sessionId; // ID de la sesión del usuario

  NuevoComunicadoPage({required this.sessionId});

  @override
  _NuevoComunicadoPageState createState() => _NuevoComunicadoPageState();
}

class _NuevoComunicadoPageState extends State<NuevoComunicadoPage> {
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();
  final TextEditingController _fechaController = TextEditingController();
  bool _isSubmitting = false;

  // Función para mostrar el DatePicker y seleccionar la fecha
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // Fecha inicial
      firstDate: DateTime(2020), // Fecha mínima seleccionable
      lastDate: DateTime(2101), // Fecha máxima seleccionable
    );
    if (picked != null && picked != DateTime.now()) {
      setState(() {
        _fechaController.text = "${picked.toLocal()}".split(' ')[0]; // Formato yyyy-MM-dd
      });
    }
  }

  // Función para crear el comunicado
  Future<void> crearComunicado() async {
    //final url = Uri.parse('http://10.0.2.2:8069/api/comunicados/general');  //Emulador
    final url = Uri.parse('http://13.93.147.122:8070/api/comunicados/general'); // Máquina virtual
    setState(() {
      _isSubmitting = true;
    });

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Cookie': 'session_id=${widget.sessionId}', // Enviamos la sesión al servidor
        },
        body: jsonEncode({
          'nombre': _nombreController.text,
          'descripcion': _descripcionController.text,
          'fecha': _fechaController.text, // Incluir la fecha correctamente
          'visto': true, 
        }),
      );

      if (response.statusCode == 200) {
        // Si el servidor responde correctamente
        Navigator.pop(context, true); // Regresar a la pantalla anterior si la creación fue exitosa
      } else {
        // Manejar el error si el servidor responde con un error
        print('Respuesta del servidor: ${response.body}'); // Imprimir la respuesta para debuguear
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al crear el comunicado')),
        );
      }
    } catch (e) {
      print('Error: $e');
      // Mostrar mensaje de error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se pudo conectar al servidor')),
      );
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Crear Comunicado")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nombreController,
              decoration: InputDecoration(labelText: "Nombre"),
            ),
            TextField(
              controller: _descripcionController,
              decoration: InputDecoration(labelText: "Descripción"),
              maxLines: 3,
            ),
            TextField(
              controller: _fechaController,
              decoration: InputDecoration(labelText: "Fecha", hintText: "Seleccione una fecha"),
              readOnly: true,
              onTap: () => _selectDate(context), // Mostrar el selector de fecha
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isSubmitting ? null : crearComunicado,
              child: _isSubmitting
                  ? CircularProgressIndicator()
                  : Text("Guardar Comunicado"),
            ),
          ],
        ),
      ),
    );
  }
}
