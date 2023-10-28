import 'dart:convert';
import 'dart:developer';

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
  final response = await http.get(
    Uri.parse('http://hydro.hydro-babiat.ovh/dataEtang/'
    ));
  //final response = await http.get(Uri.parse('http://192.168.1.18/dataEtang/'));
  //final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1'));
  log(response.statusCode.toString());
  
  if (response.statusCode == 200 ) {
    return DataEtang.fromJson(jsonDecode(response.body) as Map<String,dynamic>);
  } else {
    throw Exception('Failed to Load data Etang');
  }
}
class _MainPageState extends State<MainPage> {
  bool wideScreen = false;
  int selectedIndex = 0;
  late Future<DataEtang> futureDataEtang;
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final double width = MediaQuery.of(context).size.width;
    wideScreen = width > 600;
  }

  @override
  void initState(){
    super.initState();
    futureDataEtang = fetchDataEtang();
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
            FutureBuilder<DataEtang>(
              future: futureDataEtang,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: [
                      Text(snapshot.data!.niveauEtangP.toString()),
                      Text(snapshot.data!.niveauEtang.toString()),
                      LinearProgressIndicator(
                        value: snapshot.data!.niveauEtangP,
                        semanticsLabel: 'Linear progress indicator',)
                    ],
                  );
                } else if(snapshot.hasError){
                  log('${snapshot.error}');
                  
                  return  Text('${snapshot.error}');
                }
                return const CircularProgressIndicator();
              },
            ),
            ElevatedButton(onPressed: (){setState(() {
              futureDataEtang = fetchDataEtang();
            });}, 
            child: const Text('refresh'))
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
  bool wsConnected = false;
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
            subtitle: Text('connected $wsConnected pressed $wsPressed'),
            selected: wsPressed,
            leading: const Icon(Icons.online_prediction),
            onTap: () {
              setState(() {
                wsPressed = !wsPressed;
              });
            },
            trailing: Switch(
              value: wsConnected,
              onChanged: (value) {
                setState(() {
                  wsConnected = value;
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
                const SizedBox(width: 10,),
                ElevatedButton(
                    onPressed: () {
                      setState(() {
                        widget.thememode(ThemeMode.dark);
                      });
                    },
                    child: const Text('Dark')),
                const SizedBox(width: 10,),
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

class Modes extends StatelessWidget {
  const Modes({
    super.key,
    required this.boxDecoration,
  });

  final BoxDecoration boxDecoration;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Column(
              children: [
                Expanded(
                    child: Row(
                  children: [
                    Expanded(
                      child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: boxDecoration,
                          child: const Text("Manouelle")),
                    ),
                  ],
                )),
                Expanded(
                    child: Row(
                  children: [
                    Expanded(
                      child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: boxDecoration,
                          child: const Text("basic")),
                    ),
                  ],
                )),
                Expanded(
                    child: Row(
                  children: [
                    Expanded(
                      child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: boxDecoration,
                          child: const Text("PID")),
                    ),
                  ],
                ))
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              decoration: boxDecoration,
              child: SizedBox(
                  height: 500,
                  //width: 600,
                  child: Slider(
                    value: 0.50,
                    onChanged: (value) {},
                  )),
            ),
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
