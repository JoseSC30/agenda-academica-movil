import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'NuevoComunicadoPage.dart';

class ComunicadosPage extends StatefulWidget {
  final String sessionId;  

  ComunicadosPage({Key? key, required this.sessionId}) : super(key: key);

  @override
  _ComunicadosPageState createState() => _ComunicadosPageState();
}

class _ComunicadosPageState extends State<ComunicadosPage> {
  bool _isLoading = true;
  String errorMessage = '';
  List<dynamic> comunicados = [];

  // Función para obtener los comunicados desde la API
  Future<void> fetchComunicados() async {
    final String url = 'http://13.93.147.122:8069/api/comunicados/general'; 

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Cookie': 'session_id=${widget.sessionId}',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          comunicados = data;
          _isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Error al cargar los comunicados';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'No se pudo conectar al servidor';
        _isLoading = false;
      });
      print('Error al obtener los comunicados: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchComunicados(); // Llamamos a la función al iniciar
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Comunicados", style: TextStyle(color: Colors.white)),
        backgroundColor: Color.fromARGB(255, 103, 127, 118), // Color menta oscuro
      ),
      body: Container(
        color: Color.fromARGB(255, 103, 127, 118), // Fondo de color menta oscuro
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : comunicados.isEmpty
                ? Center(child: Text('No hay comunicados disponibles'))
                : ListView.builder(
                    itemCount: comunicados.length,
                    itemBuilder: (context, index) {
                      final comunicado = comunicados[index];
                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(comunicado['nombre'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.blue[900],),),
                              SizedBox(height: 8),

                              Text(comunicado['descripcion'],style: TextStyle(fontSize: 16),),
                              SizedBox(height: 8),

                              Text(comunicado['fecha'],style: TextStyle(color: Colors.grey[600]),),
                              SizedBox(height: 8),

                              Text(comunicado['visto'] ? "Visto" : "No visto",style: TextStyle(color: comunicado['visto']? Colors.green: Colors.red, fontWeight: FontWeight.bold,),),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
      ),

      ///////////
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final nuevoComunicado = await Navigator.push(context,MaterialPageRoute(builder: (context) => NuevoComunicadoPage(sessionId: widget.sessionId)),);
          if (nuevoComunicado != null) {
            fetchComunicados();
          }
        },
        child: Icon(Icons.add),
        backgroundColor: const Color.fromARGB(255, 124, 135, 156),
        tooltip: 'Crear Nuevo Comunicado',
      ),
      //////////
      
    );
  }


}
