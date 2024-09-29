import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_application_3/fill_level.dart';
import 'package:flutter_application_3/models/ws_data.dart';
import 'package:flutter_application_3/providers/ws.dart';
import 'global.dart' as global;
import 'models/data_etang.dart';
import 'package:http/http.dart' as http;

import 'models/data_turbine.dart';

Future<DataEtang> fetchDataEtang() async {
  log('fetch dataEtang');
  final response =
      await http.get(Uri.parse('http://hydro.hydro-babiat.ovh/dataEtang/'));

  log(response.body.toString());
  if (response.statusCode == 200) {
    return DataEtang.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    throw Exception('Failed to Load data Etang');
  }
}

Future<DataTurbine> fetchDataTurbine() async {
  log('fetch dataTurbine');
  final response =
      await http.get(Uri.parse('http://hydro.hydro-babiat.ovh/dataTurbine/'));
  log(response.body.toString());
  if (response.statusCode == 200) {
    return DataTurbine.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    throw Exception('Failed to Load data Etang');
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.wideScreen, required this.provider});
  final bool wideScreen;
  final Ws provider;
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<DataEtang> futureDataEtang;
  late Future<DataTurbine> futureDataTurbine;

  @override
  void initState() {
    super.initState();
    //futureDataEtang = fetchDataEtang();
    //futureDataTurbine = fetchDataTurbine();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showMyDialog();
    });
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Welcome'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('This is a popup dialog shown on start.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Approve'),
              onPressed: () {
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text('Hello World ! wideScreen:${widget.wideScreen.toString()}'),
        const Divider(),
        // FutureBuilder<DataEtang>(
        //   future: futureDataEtang,
        //   builder: (context, snapshot) {
        //     if (snapshot.hasData) {
        //       return Column(
        //         children: [
        //           Text(snapshot.data!.niveauEtangP.toString()),
        //           Text(snapshot.data!.niveauEtang.toString()),
        //           Padding(
        //             padding: const EdgeInsets.all(8.0),
        //             child: LinearProgressIndicator(
        //               value: snapshot.data!.niveauEtangP / 100,
        //               semanticsLabel: 'Linear progress indicator',
        //             ),
        //           )
        //         ],
        //       );
        //     } else if (snapshot.hasError) {
        //       log('${snapshot.error}');

        //       return Text('${snapshot.error}');
        //     }
        //     return const CircularProgressIndicator();
        //   },
        // ),
        ElevatedButton(
            onPressed: () {
              setState(() {
                futureDataEtang = fetchDataEtang();
              });
            },
            child: const Text('refresh')),
        // FutureBuilder<DataTurbine>(
        //   future: futureDataTurbine,
        //   builder: (context, snapshot) {
        //     if (snapshot.hasData) {
        //       return Column(
        //         children: [
        //           Text(snapshot.data!.positionVanne.toString()),
        //           Text(snapshot.data!.positionVanneTarget.toString()),
        //           Padding(
        //             padding: const EdgeInsets.all(8.0),
        //             child: LinearProgressIndicator(
        //               value: snapshot.data!.positionVanne / 100,
        //               semanticsLabel: 'Linear progress indicator',
        //             ),
        //           ),
        //           Slider(
        //               value: snapshot.data!.positionVanneTarget,
        //               divisions: 100,
        //               label: snapshot.data!.positionVanneTarget.toString(),
        //               min: 0,
        //               max: 100,
        //               onChanged: (double value) {
        //                 setState(() {
        //                   snapshot.data!.positionVanneTarget = value;
        //                 });
        //               })
        //         ],
        //       );
        //     } else if (snapshot.hasError) {
        //       log('${snapshot.error}');

        //       return Text('${snapshot.error}');
        //     }
        //     return const CircularProgressIndicator();
        //   },
        // ),
        ElevatedButton(
            onPressed: () {
              setState(() {
                futureDataTurbine = fetchDataTurbine();
              });
            },
            child: const Text('refresh turbine')),
        Text('ws ${global.ws}'),
        const Divider(),
        const FillLevel(fillLevel: 0.50),
        const SliderValue(),
        StreamBuilder<WsData>(
          stream: widget.provider.dataEtangStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Column(
                  children: [
                    const CircularProgressIndicator(),
                    Text('hasdata ${snapshot.hasData}'),
                    Text('hasdata ${snapshot.connectionState}'),
                  ],
                ),
              );
            }
            if (snapshot.connectionState == ConnectionState.active &&
                snapshot.hasData) {
              return Center(
                child: Text(
                  'hasData: ${snapshot.hasData} ${snapshot.data?.data2.mode}: ${snapshot.data?.data2.dataEtang.niveauEtangP}',
                  style: const TextStyle(
                    color: Color.fromARGB(255, 32, 32, 129),
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            }

            if (snapshot.connectionState == ConnectionState.done) {
              return const Center(
                child: Text('No more data'),
              );
            }
            if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            }
            return const Center(
              child: Text('No data'),
            );
          },
        )
      ],
    );
  }
}

class SliderValue extends StatefulWidget {
  const SliderValue({
    super.key,
  });

  @override
  State<SliderValue> createState() => _SliderValueState();
}

class _SliderValueState extends State<SliderValue> {
  double _value = 0;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: "er");
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Slider(
        value: _value,
        min: 0,
        max: 100,
        divisions: 100,
        label: _value.round().toString(),
        onChanged: (value) {
          setState(() {
            _value = value;
          });
        },
      ),
      Text('value: $_value'),
      SizedBox(
        width: 120,
        child: TextField(
          controller: _controller,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Test',
          ),
          onSubmitted: (String newvalue) {
            if (newvalue.isNotEmpty) {
              log("par ici $newvalue");
              _value = double.parse(newvalue);
              
            }
          },
        ),
      )
    ]);
  }
}
