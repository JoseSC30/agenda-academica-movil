import 'package:flutter/material.dart';
//import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';  // Para obtener directorios
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';  // Para permisos
import 'package:open_file/open_file.dart';  

class PdfAudioTexto {
  static Future<void> generarPDF(BuildContext context, String transcriptionResult, String analysisResult) async {
    final pdf = pw.Document();

    // Agregar una página con contenido
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            children: [
             /* pw.Text('Resultado de la Transcripción', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 10),
              pw.Text(transcriptionResult, style: pw.TextStyle(fontSize: 14)),
              pw.SizedBox(height: 20),
              */

              pw.Text('Resultado del Análisis', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 10),
              pw.Text(analysisResult, style: pw.TextStyle(fontSize: 14)),
            ],
          );
        },
      ),
    );

    // Solicitar permisos para acceder al almacenamiento (si es necesario)
    await _requestPermission();

    // Obtener el directorio donde se guardará el PDF
    final output = await getApplicationDocumentsDirectory();
    final folderPath = "${output.path}/MiCarpeta";  // Definir la ruta de la subcarpeta
    final folder = Directory(folderPath);

    // Verificar si la carpeta ya existe, si no, la creamos
    if (!await folder.exists()) {
      await folder.create(recursive: true);  // Crea la carpeta si no existe
    }

    // Guardar el archivo PDF en la subcarpeta
    final file = File("$folderPath/resultado_analisis.pdf");
    await file.writeAsBytes(await pdf.save());
    print("PDF guardado en ${file.path}");

    // Notificar al usuario que el PDF fue guardado
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("PDF guardado en ${file.path}")));

    // Abrir el archivo PDF en el visor predeterminado del dispositivo
    OpenFile.open(file.path);
  }

  // Solicitar permisos para leer y escribir en el almacenamiento (Android)
  static Future<void> _requestPermission() async {
    final status = await Permission.storage.request();
    if (!status.isGranted) {
      print("Permiso no concedido");
    }
  }
}
