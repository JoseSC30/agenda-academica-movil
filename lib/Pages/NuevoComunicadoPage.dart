import 'package:flutter/material.dart';
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
    final url = Uri.parse('http://13.93.147.122:8069/api/comunicados/nuevo');
    final body = jsonEncode({
      'nombre': _nombreController.text,
      'descripcion': _descripcionController.text,
      'fecha': _fechaController.text, // Incluir la fecha
    });

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
        body: body,
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
}
