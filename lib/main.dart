import 'package:flutter_application_3/home_page.dart';
import 'package:flutter_application_3/providers/ws.dart';


import 'global.dart' as global;



import 'package:flutter/material.dart';
import 'package:flutter_application_3/destinations.dart';
import 'package:flutter_application_3/models/programmated_task.dart';



void main() {
  // final channel = WebSocketChannel.connect(Uri.parse("ws://hydro.hydro-babiat.ovh/ws"));
  // channel.stream.listen((event) {
  //   log(event);
  // },
  // onError: (error) => log(error),
  // onDone: () => log("done"),
  // );
  runApp(MainApp());
  //channel.sink.close();
}

class MainApp extends StatefulWidget {
   MainApp({super.key});
   final Ws _provider = Ws();
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
          provider: widget._provider,
        ));
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key, required this.themMode, required this.provider});
  final Function(ThemeMode) themMode;
  final Ws provider;
  
  @override
  State<MainPage> createState() => _MainPageState();
}





class _MainPageState extends State<MainPage> {
  bool wideScreen = false;
  int selectedIndex = 0; 


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final double width = MediaQuery.of(context).size.width;
    wideScreen = width > 600;
  }

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    Widget page;
    var boxDecoration = BoxDecoration(
        color: Theme.of(context).secondaryHeaderColor,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(width: 2, color: Theme.of(context).primaryColor));

    //log((global.wsTest == null).toString());
    switch (selectedIndex) {
      case 0:
        page = HomePage(wideScreen: wideScreen,provider: widget.provider);
        break;
      case 1:
        page = Modes(boxDecoration: boxDecoration);
        break;
      case 2:
        page = ListView.separated(
            itemCount: progTasks.length,
            separatorBuilder: (context, index) { return const Divider();},
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
            child: SingleChildScrollView(
              child: Center(
                child: page,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
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
  const Modes({super.key, required this.boxDecoration});

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
