import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; // Importa dotenv
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'pdf_audio_texto.dart'; // Importamos la clase PdfAudioTexto

class AudioTextoIAPage extends StatefulWidget {
  const AudioTextoIAPage({super.key});

  @override
  _AudioTextoIAPageState createState() => _AudioTextoIAPageState();
}

class _AudioTextoIAPageState extends State<AudioTextoIAPage> {
  String _transcriptionResult = '';
  String _analysisResult = '';
  bool _isLoading = false;
  File? _selectedFile;

  // Función para seleccionar el archivo de audio
  Future<void> _pickAudioFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
    );

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
      });
    }
  }

  // Función para realizar la transcripción (con texto estático)
  Future<void> _transcribeAudio() async {
    if (_selectedFile == null) {
      setState(() {
        _transcriptionResult = 'Por favor, selecciona un archivo de audio primero.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _transcriptionResult = '';
    });

    // Simulamos la respuesta de transcripción con texto estático para pruebas
    setState(() {
      _transcriptionResult = 'El tema de la tarea es el sistema solar. Deberan traer un dibujo de todos los planetas en formato Word, y la fecha de presentación es el jueves 2 de octubre.';
      _isLoading = false;
    });

    // Después de la transcripción, hacemos el análisis con ChatGPT
    await _analyzeTranscription(_transcriptionResult);
  }


  /*
  // Función para enviar el archivo a la API OpenAI Whisper para la transcripción (me quedan 4 consultas) NO ELIMINAR!!!!
  Future<void> _transcribeAudio() async {
    if (_selectedFile == null) {
      setState(() {
        _transcriptionResult = 'Por favor, selecciona un archivo de audio primero.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _transcriptionResult = '';
    });

    final apiKey = dotenv.env['RAPIDAPI_KEY']!;
    final apiHost = dotenv.env['RAPIDAPI_HOST']!;
    final url = Uri.parse('https://$apiHost/transcribe');

    try {
      // Crear una solicitud POST con multipart/form-data
      final request = http.MultipartRequest('POST', url);
      request.headers.addAll({
        'x-rapidapi-key': apiKey,
        'x-rapidapi-host': apiHost,
      });

      // Añadir el archivo de audio
      request.files.add(await http.MultipartFile.fromPath('file', _selectedFile!.path));

      // Parámetros adicionales para la solicitud
      request.fields['type'] = 'RAPID';  
      request.fields['response_format'] = 'JSON';  

      // Enviar la solicitud
      final response = await request.send();

      // Leer la respuesta de la API
      final responseData = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        print("Respuesta de la API: $responseData");  
        final data = json.decode(responseData);

        // Verificar si el campo 'response' y 'text' están presentes
        if (data.containsKey('response') && data['response'].containsKey('text')) {
          setState(() {
            _transcriptionResult = data['response']['text'] ?? 'Transcripción no disponible';
          });
        } else {
          setState(() {
            _transcriptionResult = 'Transcripción no disponible. Respuesta inesperada: $responseData';
          });
        }
      } else {
        setState(() {
          _transcriptionResult = 'Error en la transcripción: ${response.reasonPhrase}';
        });
      }
    } catch (error) {
      setState(() {
        _transcriptionResult = 'Error de red: $error';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
    await _analyzeTranscription(_transcriptionResult); // Después de la transcripción, hacemos el análisis con ChatGPT
  }*/

  // Función para analizar el texto de transcripción con ChatGPT
  Future<void> _analyzeTranscription(String transcription) async {
    setState(() {
      _isLoading = true;
      _analysisResult = '';
    });

    final openAIApiKey = dotenv.env['OPENAI_API_KEY']!;
    final openAIOrgId = dotenv.env['OPENAI_ORG_ID']!;
    final url = Uri.parse('https://api.openai.com/v1/chat/completions');

    final prompt = '''
    A partir de la siguiente transcripción de audio, extrae los puntos importantes como fecha de presentación, formato y título de la tarea.
    
    Transcripción:
    "$transcription"
    
    Responde con una lista clara y concisa de los puntos importantes.
    ''';

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $openAIApiKey',
          'OpenAI-Organization': openAIOrgId,
        },
        body: json.encode({
          "model": "gpt-3.5-turbo",
          "messages": [
            {"role": "system", "content": "Actúa como un asistente que analiza tareas, proyectos, exámenes."},
            {"role": "user", "content": prompt}
          ]
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final chatGptResponse = data['choices'][0]['message']['content'];

        setState(() {
          _analysisResult = chatGptResponse ?? 'Análisis no disponible';
        });
      } else {
        setState(() {
          _analysisResult = 'Error en el análisis: ${response.reasonPhrase}';
        });
      }
    } catch (error) {
      setState(() {
        _analysisResult = 'Error de red: $error';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Función para generar PDF
  void _generatePDF() {
    PdfAudioTexto.generarPDF(context, _transcriptionResult, _analysisResult);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Audio y Texto IA Análisis', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 103, 127, 118),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: _pickAudioFile,
              child: const Text('Seleccionar Audio', style: TextStyle(color: Colors.black)),
              style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 165, 200, 194)),
            ),
            
            if (_selectedFile != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text('Archivo seleccionado: ${_selectedFile!.path.split('/').last}',style: const TextStyle(fontWeight: FontWeight.bold)),
              ),

            ElevatedButton(
              onPressed: _isLoading ? null : _transcribeAudio,
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  //: const Text('Transcripción y Análisis', style: TextStyle(color: Colors.black)),
                  : const Text('Análizar', style: TextStyle(color: Colors.black)),
              style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 165, 200, 194)),
            ),

            /*const SizedBox(height: 24.0),
            const Text('Resultado de la Transcripción:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8.0),
            Text(_transcriptionResult),
            */

            const SizedBox(height: 24.0),
            const Text('Resultado del Análisis:',style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8.0),
            Text(_analysisResult),

            // Botón para generar el PDF
            ElevatedButton(
              onPressed: _isLoading ? null : _generatePDF,
              child: const Text('Generar PDF', style: TextStyle(color: Colors.black)),
              style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 165, 200, 194)),
            ),
          ],
        ),
      ),
    );
  }
}
