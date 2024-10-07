import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_application_3/fill_level.dart';
import 'package:flutter_application_3/models/ws_data.dart';
import 'package:flutter_application_3/providers/ws.dart';
import 'package:flutter_application_3/widgets/slider_value.dart';
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
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   _showMyDialog();
    // });
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
    return SingleChildScrollView(
      child: Column(
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
                      Text('connection state: ${snapshot.connectionState}'),
                    ],
                  ),
                );
              }
              if (snapshot.connectionState == ConnectionState.active &&
                  snapshot.hasData) {
                return Center(
                  child: Column(
                    children: [
                      FillLevel(fillLevel: snapshot.data!.data2.dataEtang.niveauEtangP),
                      Text(
                        'hasData: ${snapshot.hasData} ${snapshot.data?.data2.mode}: ${snapshot.data?.data2.dataEtang.niveauEtangP}',
                        style: const TextStyle(
                          color: Color.fromARGB(255, 32, 32, 129),
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text('tacky : ${snapshot.data?.data2.dataTurbine.tacky} rpm'),
                      Text('I : ${snapshot.data?.data2.dataTurbine.intensite} A'),
                      Text('U : ${snapshot.data?.data2.dataTurbine.tension} V'),
                      Text('Vanne : ${snapshot.data?.data2.dataTurbine.positionVanne} %'),
                      Text('Target : ${snapshot.data?.data2.dataTurbine.positionVanneTarget} %'),
                      Column(
                        children: [
                          Row(children: [
                            const Text("Notification"),
                            Checkbox(value: (snapshot.data!.data2.notification == 0) ?false:true, onChanged: (bool ?value) {
                              if (value == null) {
                                return;
                              }
                              widget.provider.send("Notification=${value?'true':'false'}");
                              
                            },)
                          ],),
                          Row(children: [
                            const Text("Notification Group"),
                            Switch(value: (snapshot.data!.data2.notificationGroup == 0) ?false:true, onChanged: (bool ?value) {
                              if (value == null) {
                                return;
                              }
                              log('switch : $value');
                              widget.provider.send("NotificationGroup=${value?'true':'false'}");
                              
                            }),
                            
                          ],),
                        ],
                      )
                    ],
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
              return  Center(
                child: Column(
                  children: [
                    const Text('No data'),
                    ElevatedButton(onPressed: () {
                      widget.provider.enable;
                    }, child: const Text('Reload'))
                  ],
                ),
              );
            },
          )
        ],
      ),
    );
  }
}


