import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sparkline/flutter_sparkline.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  List<double> _data = [];

  int statusLight = 0;
  int _valueLight = 0;

  static const platform = const
  MethodChannel('flutter_iot_lamp');

  _MyHomePageState() {
    platform.setMethodCallHandler(handlerLamp);
  }

  Future handlerLamp(MethodCall call) {
    Map<String, dynamic> dataArgs =
          jsonDecode(call.arguments);
    if (dataArgs["value"] != null) {
      setState(() {
        _valueLight = dataArgs["value"];
        _data.add(double.parse(dataArgs["value"].toString()));
      });
    }
  }


  Future<String> sendData() async {
    http.Response response = await http.get(
      Uri.encodeFull("https://ps.pndsn.com/publish/pub-c-b3c97c3a-4572-44ac-91d4-942e9dcecc86/sub-c-052a7e96-86f4-11e9-9f15-ba4fa582ffed/0/flutter_iot_lamp/0/{\"action\":$statusLight}?uuid=db9c5e39-7c95-40f5-8d71-125765b6f561"),
    );

    print(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter & IoT"),
      ),
      body: StaggeredGridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 12.0,
        mainAxisSpacing: 12.0,
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        children: <Widget>[
          _buildTile(
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column
                (
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>
                  [
                    Material(
                      color: Colors.green,
                      shape: CircleBorder(),
                      child: Padding
                        (
                        padding: const EdgeInsets.all(16.0),
                        child: Icon(Icons.toys, color: Colors.white, size: 30.0),
                      )
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 16.0)
                    ),
                    Text(
                      'Ventilador',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                        fontSize: 22.0)
                    ),
                    Text(
                      'Ligado',
                      style: TextStyle(
                        color: Colors.black45
                      )
                    ),
                  ]
              ),
            ),
          ),
          _buildTile(
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Material(
                      color: statusLight == 0 ? Colors.red : Colors.green,
                      shape: CircleBorder(),
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Icon(Icons.lightbulb_outline, color: Colors.white, size: 30.0),
                      )
                  ),
                  Padding(padding: EdgeInsets.only(bottom: 16.0)),
                  Text('Balada', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 22.0)),
                  Text(statusLight == 0 ? 'Off' : "On", style: TextStyle(color: Colors.black45)),
                ]
              ),
            ),
            callback: (){
              setState(() {
                statusLight = statusLight == 0 ? 1 : 0;
              });
              sendData();
            }
          ),
          _buildTile(
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('Luz:', style: TextStyle(color: Colors.green)),
                          Text("${_valueLight}", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 34.0)),
                        ],
                      ),
                    ],
                  ),
                  Padding(padding: EdgeInsets.only(bottom: 4.0)),
                  _data.length > 1 ?
                  Sparkline(
                    data: _data,
                    pointsMode: PointsMode.all,
                    lineWidth: 5.0,
                    lineColor: Colors.greenAccent,
                  ) : Container()
                ],
              )
            ),
          )
        ],
        staggeredTiles: [
          StaggeredTile.extent(1, 180.0),
          StaggeredTile.extent(1, 180.0),
          StaggeredTile.extent(2, 220.0)
        ],
      )
    );
  }

  Widget _buildTile(Widget content, {Function() callback}) {
    return Material(
        elevation: 14.0,
        borderRadius: BorderRadius.circular(12.0),
        shadowColor: Color(0x802196F3),
        child: InkWell(
            onTap: callback != null ? () => callback() : () { print('Not set yet'); },
            child: content
        )
    );
  }
}
