import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:examen3/database_helper.dart';
import 'package:examen3/user_model.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final String apiUrl =
      'http://nrweb.com.mx/api_prueba/examen/parcial3.php?nombre=Oscar%20Enrique%20S%C3%A1nchez%20Mart%C3%ADnez&clave=297525&hora=7';

  // Lista de usuarios obtenida de la API
  List<Map<String, dynamic>> users = [];

  // Método para realizar la llamada a la API
Future<void> fetchData() async {
  try {
    final response = await http.get(Uri.parse(apiUrl), headers: {
      "Access-Control-Allow-Origin": "*",
      'Content-Type': 'application/json',
      'Accept': '*/*'
    });

    if (response.statusCode == 200) {
      setState(() {
        users = List<Map<String, dynamic>>.from(
          jsonDecode(response.body)['respuesta'] ?? [],
        );
      });

      // Guardar datos en la base de datos local
      await DatabaseHelper.initDatabase();
      for (var userMap in users) {
        final userModel = UserModel(
          nombre: userMap['nombre'],
          apellidoPaterno: userMap['apellido_paterno'],
          apellidoMaterno: userMap['apellido_materno'],
          edad: userMap['edad'],
          paisOrigen: userMap['pais_origen'],
          calificacion: userMap['calificacion'],
        );
        await DatabaseHelper.insertUser(userModel);
      }
    } else {
      print('Error en la solicitud a la API. Código de estado: ${response.statusCode}');
    }
  } catch (error) {
    print('Error en la solicitud a la API: $error');
  }
}

   // Método para obtener el color de fondo de la tarjeta según el país
  Color getCardColor(String pais) {
    return pais.toLowerCase() == 'méxico' ? Colors.lightBlue : Colors.black;
  }

  // Método para obtener el estilo de texto según la calificación
  TextStyle getTextStyle(int calificacion) {
    if (calificacion > 80) {
      return const TextStyle(fontSize: 20, color: Colors.green);
    } else if (calificacion > 60) {
      return const TextStyle(fontSize: 18, color: Colors.orange);
    } else {
      return const TextStyle(fontSize: 15, color: Colors.red);
    }
  }

    // Método para mostrar un AlertDialog de confirmación
  Future<void> _showConfirmationDialog(String action, Function() onConfirmed) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmación'),
          content: Text('¿Estás seguro de que deseas $action este usuario?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Confirmar'),
              onPressed: () {
                onConfirmed();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home View'),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              fetchData();
            },
            child: const Text('Solicitar nuevos usuarios'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    color: getCardColor(user['pais_origen']),
                    child: ListTile(
                      leading: const Icon(Icons.person),
                      title: Text(
                        'Nombre: ${user['nombre']} ${user['apellido_paterno']} ${user['apellido_materno']}',
                        style: const TextStyle(fontSize: 16, color: Colors.white),
                      ),
                      subtitle: Text(
                        'Edad: ${user['edad']}, País: ${user['pais_origen']}, Calificación: ${user['calificacion']}',
                        style: getTextStyle(user['calificacion']),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.update),
                            onPressed: () {
                              _showConfirmationDialog('actualizar', () {
                        
                              });
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              _showConfirmationDialog('eliminar', () {
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}