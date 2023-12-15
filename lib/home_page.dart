import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_application_3/models/ws_data.dart';
import 'package:flutter_application_3/providers/ws.dart';
import 'global.dart' as global;
import 'models/data_etang.dart';
import 'package:http/http.dart' as http;

import 'models/data_turbine.dart';

Future<DataEtang> fetchDataEtang() async {
  final response =
      await http.get(Uri.parse('http://hydro.hydro-babiat.ovh/dataEtang/'));

  if (response.statusCode == 200) {
    return DataEtang.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    throw Exception('Failed to Load data Etang');
  }
}

Future<DataTurbine> fetchDataTurbine() async {
  final response =
      await http.get(Uri.parse('http://hydro.hydro-babiat.ovh/dataTurbine/'));

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
        StreamBuilder<WsData>(
          stream: widget.provider.dataEtangStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.connectionState == ConnectionState.active &&
                snapshot.hasData) {
              return Center(
                child: Text(
                  '${snapshot.data?.data}: ${snapshot.data}',
                  style: const TextStyle(
                    color: Color.fromARGB(255, 11, 11, 12),
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
              return  Center(
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
