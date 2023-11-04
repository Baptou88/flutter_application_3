import 'dart:convert';
import 'dart:developer';
import 'global.dart' as global;
import 'package:flutter_application_3/models/data_turbine.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:flutter_application_3/destinations.dart';
import 'package:flutter_application_3/models/programmated_task.dart';

import 'models/data_etang.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  ThemeMode themeMode = ThemeMode.system;

  void setThemeMode(ThemeMode mode) {
    setState(() {
      themeMode = mode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          useMaterial3: true,
        ),
        themeMode: themeMode,
        darkTheme: ThemeData(colorScheme: const ColorScheme.dark()),
        home: MainPage(
          themMode: setThemeMode,
        ));
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key, required this.themMode});
  final Function(ThemeMode) themMode;

  @override
  State<MainPage> createState() => _MainPageState();
}

Future<DataEtang> fetchDataEtang() async {
  final response =
      await http.get(Uri.parse('http://hydro.hydro-babiat.ovh/dataEtang/'));

  log(response.statusCode.toString());

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

  log(response.statusCode.toString());

  if (response.statusCode == 200) {
    return DataTurbine.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    throw Exception('Failed to Load data Etang');
  }
}

class _MainPageState extends State<MainPage> {
  bool wideScreen = false;
  int selectedIndex = 0;
  late Future<DataEtang> futureDataEtang;
  late Future<DataTurbine> futureDataTurbine;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final double width = MediaQuery.of(context).size.width;
    wideScreen = width > 600;
  }

  @override
  void initState() {
    super.initState();
    futureDataEtang = fetchDataEtang();
    futureDataTurbine = fetchDataTurbine();
  }

  @override
  Widget build(BuildContext context) {
    Widget page;
    var boxDecoration = BoxDecoration(
        color: Theme.of(context).secondaryHeaderColor,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(width: 2, color: Theme.of(context).primaryColor));

    switch (selectedIndex) {
      case 0:
        page = Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Hello World ! wideScreen:${wideScreen.toString()}'),
            const Divider(),
            StreamBuilder(
              stream: global.wsTest.channel.stream,
              builder: (context,snapshot){
                if (snapshot.hasData) {
                  return Text(snapshot.data);
                } else if (snapshot.hasError){
                  return Text(snapshot.error.toString());
                } else {
                  return const Text('error ws');
                }
            }),
            const Divider(),
            FutureBuilder<DataEtang>(
              future: futureDataEtang,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: [
                      Text(snapshot.data!.niveauEtangP.toString()),
                      Text(snapshot.data!.niveauEtang.toString()),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: LinearProgressIndicator(
                          value: snapshot.data!.niveauEtangP / 100,
                          semanticsLabel: 'Linear progress indicator',
                        ),
                      )
                    ],
                  );
                } else if (snapshot.hasError) {
                  log('${snapshot.error}');

                  return Text('${snapshot.error}');
                }
                return const CircularProgressIndicator();
              },
            ),
            ElevatedButton(
                onPressed: () {
                  setState(() {
                    futureDataEtang = fetchDataEtang();
                  });
                },
                child: const Text('refresh')),
            FutureBuilder<DataTurbine>(
              future: futureDataTurbine,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: [
                      Text(snapshot.data!.positionVanne.toString()),
                      Text(snapshot.data!.positionVanneTarget.toString()),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: LinearProgressIndicator(
                          value: snapshot.data!.positionVanne / 100,
                          semanticsLabel: 'Linear progress indicator',
                        ),
                      ),
                      Slider(
                          value: snapshot.data!.positionVanneTarget,
                          divisions: 100,
                          label: snapshot.data!.positionVanneTarget.toString(),
                          min: 0,
                          max: 100,
                          onChanged: (double value) {
                            setState(() {
                              snapshot.data!.positionVanneTarget = value;
                            });
                          })
                    ],
                  );
                } else if (snapshot.hasError) {
                  log('${snapshot.error}');

                  return Text('${snapshot.error}');
                }
                return const CircularProgressIndicator();
              },
            ),
            ElevatedButton(
                onPressed: () {
                  setState(() {
                    futureDataTurbine = fetchDataTurbine();
                  });
                },
                child: const Text('refresh turbine')),
            Text('ws ${global.ws}')
          ],
        );
        break;
      case 1:
        page = Modes(boxDecoration: boxDecoration);
        break;
      case 2:
        page = ListView.builder(
            itemCount: progTasks.length,
            itemBuilder: (context, index) {
              return ProgTaskWidget(task: progTasks[index]);
            });
        break;

      case 3:
        page = Settings(
          thememode: widget.themMode,
        );
        break;
      default:
        throw UnimplementedError('not implemented page $selectedIndex');
    }
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            fetchDataEtang();
            fetchDataTurbine();
          });
        },
        child: const Icon(Icons.refresh),
      ),
      bottomNavigationBar: wideScreen
          ? null
          : HorizNav(
              selectedIndex: selectedIndex,
              onDestinationSelected: (value) {
                setState(() {
                  selectedIndex = value;
                });
              },
            ),
      body: Row(
        children: [
          if (wideScreen)
            VerticNav(
              selectedIndex: selectedIndex,
              onDestinationSelected: (value) {
                setState(() {
                  selectedIndex = value;
                });
              },
            ),
          Expanded(
            child: Center(
              child: page,
            ),
          ),
        ],
      ),
    );
  }
}

class Settings extends StatefulWidget {
  const Settings({super.key, required this.thememode});

  final Function(ThemeMode mode) thememode;
  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool wsPressed = false;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const Card(
          child: ListTile(
            title: Text('Toggle Led'),
            subtitle: Text("tese"),
            leading: FlutterLogo(duration: Duration(milliseconds: 500)),
          ),
        ),
        Card(
          child: ListTile(
            title: const Text('Websocket'),
            subtitle: Text('connected ${global.ws} pressed $wsPressed'),
            selected: wsPressed,
            leading: const Icon(Icons.online_prediction),
            onTap: () {
              setState(() {
                wsPressed = !wsPressed;
              });
            },
            trailing: Switch(
              value: global.ws,
              onChanged: (value) {
                setState(() {
                  global.ws = value;
                });
              },
            ),
          ),
        ),
        Card(
          child: ListTile(
            title: const Text('Websocket class'),
            subtitle: Text('connected ${global.wsTest.enable} pressed $wsPressed'),
            selected: wsPressed,
            leading: const Icon(Icons.online_prediction),
            onTap: () {
              setState(() {
                wsPressed = !wsPressed;
              });
            },
            trailing: Switch(
              value: global.wsTest.enable,
              onChanged: (value) {
                setState(() {
                  global.wsTest.toggle();
                });
              },
            ),
          ),
        ),
        Card(
          child: ListTile(
            title: const Text('ThemeMode'),
            subtitle: Card(
                child: Row(
              children: [
                ElevatedButton(
                    onPressed: () {
                      setState(() {
                        widget.thememode(ThemeMode.light);
                      });
                    },
                    child: const Text('Light')),
                const SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                    onPressed: () {
                      setState(() {
                        widget.thememode(ThemeMode.dark);
                      });
                    },
                    child: const Text('Dark')),
                const SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                    onPressed: () {
                      setState(() {
                        widget.thememode(ThemeMode.system);
                      });
                    },
                    child: const Text('System')),
              ],
            )),
          ),
        )
      ],
    );
  }
}

class Modes extends StatefulWidget {
  const Modes({ super.key, required this.boxDecoration});

  final BoxDecoration boxDecoration;
  @override
  State<Modes> createState() => _ModesState();
}

class _ModesState extends State<Modes> {
  int selected = -1;

  List<String> name = <String>["Manu", "Basic", "PID"];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Row(
        children: [
          Expanded(
              child: ListView.separated(
            padding: const EdgeInsets.all(8),
            itemCount: name.length,
            separatorBuilder: (context, index) => const Divider(),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selected = index;
                  });
                },
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                          color: selected == index
                              ? Colors.blueAccent
                              : Colors.amber,
                          padding: const EdgeInsets.all(10),
                          //decoration: widget.boxDecoration,
                          child: Text(name[index])),
                    ),
                  ],
                ),
              );
            },
          )),
          Expanded(
            flex: 3,
            
            child: SizedBox(
                height: 500,
                //width: 600,
                
                child: Slider(
                  value: 0.50,
                  onChanged: (value) {},
                )),
          )
        ],
      ),
    );
  }
}

class HorizNav extends StatelessWidget {
  const HorizNav({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  final int selectedIndex;
  final ValueChanged<int>? onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: selectedIndex,
      onDestinationSelected: onDestinationSelected,
      labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
      destinations: destinations.map<NavigationDestination>((d) {
        return NavigationDestination(icon: Icon(d.icon), label: d.label);
      }).toList(),
    );
  }
}

class VerticNav extends StatelessWidget {
  const VerticNav({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  final int selectedIndex;
  final ValueChanged<int>? onDestinationSelected;
  @override
  Widget build(BuildContext context) {
    return NavigationRail(
        //vertical
        backgroundColor: Theme.of(context).secondaryHeaderColor,
        indicatorColor: Colors.amber,
        leading: const FlutterLogo(),
        trailing: const Text("Trailing"),
        labelType: NavigationRailLabelType.selected,
        destinations: destinations.map((d) {
          return NavigationRailDestination(
            icon: Icon(d.icon),
            label: Text(d.label),
          );
        }).toList(),
        onDestinationSelected: onDestinationSelected,
        selectedIndex: selectedIndex);
  }
}
