import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 28;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Primeiro App Flutter FIAP"),
        backgroundColor: Colors.lightGreen,
      ),
      body: SizedBox(
        height: 250,
        child: Card(
          child: Column(
            children: [
              ListTile(
                title: TextField(
                  obscureText: false,
                  decoration: InputDecoration(
                    labelText: "Seu nome"
                  ),
                ),
                subtitle: Text('*Como gosta de ser chamado'),
                leading: Icon(
                  Icons.person,
                  color: Colors.blue[500],
                ),
              ),
              Divider(),
              ListTile(
                title: TextField(
                  obscureText: false,
                  decoration: InputDecoration(
                    labelText: "Telefone"
                  ),
                ),
                leading: Icon(
                  Icons.contact_phone,
                  color: Colors.blue[500],
                ),
              ),
              ListTile(
                title: Text('Idade: ${_counter}'),
                leading: Icon(
                  Icons.contact_mail,
                  color: Colors.blue[500],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
    );
  }
}
