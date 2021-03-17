import 'dart:io';
import 'package:flutter/material.dart';
import '../models/data.dart';
import 'package:http/http.dart' as http;

class SendDialog extends StatefulWidget {
  final int rnd;
  final BuildContext previousContext;

  SendDialog({this.rnd, this.previousContext});

  @override
  _SendDialogState createState() => _SendDialogState();
}

class _SendDialogState extends State<SendDialog> {
  //TextEditingController _nameController = TextEditingController();
  //TextEditingController _emailController = TextEditingController();
  final Uri _url =
      Uri.parse('https://apirandomlaura.azurewebsites.net/api/data');

  Future<String> _sendData() async {
    Data data = Data(
      dateAndTime: DateTime.now(),
      steps: widget.rnd,
    );
    var response = await http.post(
      _url,
      headers: {
        HttpHeaders.contentTypeHeader: "application/json",
      },
      body: dataToJson(data),
    );
    return response.body;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.lightGreen,
      padding: EdgeInsets.all(20),
      height: 300,
      child: SingleChildScrollView(
        child: Card(
          elevation: 10,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Text(
                  "Enviar datos:",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                ElevatedButton.icon(
                  label: Text("Enviar Datos"),
                  icon: Icon(Icons.send_rounded),
                  onPressed: () async {
                    Navigator.of(context).pop();
                    String respuesta = await _sendData();
                    ScaffoldMessenger.of(widget.previousContext).showSnackBar(
                      SnackBar(
                        content: Text(respuesta),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
