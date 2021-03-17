import 'package:flutter/material.dart';
import 'package:odometro/widgets/send_dialog.dart';
import 'dart:async';
import 'dart:math';
import 'package:pedometer/pedometer.dart';

String formatDate(DateTime d) {
  return d.toString().substring(0, 19);
}

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.teal,
        accentColor: Colors.red,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            primary: Colors.blue,
            onPrimary: Colors.black,
          ),
        ),
        appBarTheme: AppBarTheme(
          textTheme: ThemeData.light().textTheme.copyWith(
                headline6: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
        ),
      ),
      title: "Random Numbers",
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Stream<StepCount> _stepCountStream;
  Stream<PedestrianStatus> _pedestrianStatusStream;
  String _status = '?', _steps = '?';
  int rnd = 60;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  void onStepCount(StepCount event) {
    print(event);
    setState(() {
      _steps = event.steps.toString();
    });
  }

  void onPedestrianStatusChanged(PedestrianStatus event) {
    print(event);
    setState(() {
      _status = event.status;
    });
  }

  void onPedestrianStatusError(error) {
    print('onPedestrianStatusError: $error');
    setState(() {
      _status = 'Pedestrian Status not available';
    });
    print(_status);
  }

  void onStepCountError(error) {
    print('onStepCountError: $error');
    setState(() {
      _steps = rnd.toString();
    });
  }

  void initPlatformState() {
    _pedestrianStatusStream = Pedometer.pedestrianStatusStream;
    _pedestrianStatusStream
        .listen(onPedestrianStatusChanged)
        .onError(onPedestrianStatusError);

    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream.listen(onStepCount).onError(onStepCountError);

    if (!mounted) return;
  }

  void _showSendDialog(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return SendDialog(
          rnd: int.parse(_steps),
          previousContext: ctx,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Random Numbers'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Random Number:',
              style: TextStyle(fontSize: 30),
            ),
            Text(
              rnd.toString(),
              style: TextStyle(fontSize: 60),
            ),
            Divider(
              height: 100,
              thickness: 0,
              color: Colors.white,
            ),
            FloatingActionButton(
              child: Icon(Icons.add_circle),
              onPressed: () {
                setState(() {
                  rnd = Random().nextInt(1000);
                  _steps = rnd.toString();
                });
              },
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.send_rounded),
        onPressed: () {
          _showSendDialog(context);
        },
      ),
    );
  }
}
