import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_application_3/models/prog_task.dart';
import 'package:http/http.dart' as http;

// List<ProgTask> progTasks = [
//   ProgTask(activate: false, time: const TimeOfDay(hour: 12, minute: 12), name: "name", targetVanne: 20),
//   ProgTask(activate: false, time: const TimeOfDay(hour: 16, minute: 32),name: 'qdze2', targetVanne: 44),
// ];

Future<List<ProgTask>> fetchTasks() async {
  final response = await http
      .get(Uri.parse('http://hydro.hydro-babiat.ovh/programmateurJson'));
  log("par ici1");

  if (response.statusCode != 200) {
    
  }
  final body = json.decode(response.body);
  final List tasks = body["tasks"];
  log("par ici");
  List<ProgTask> temp = tasks.map((e) => ProgTask.fromJson(e)).toList();
  return temp;
}

Future<http.Response> updateTask(ProgTask task, int index)  {
  return  http.post(
    Uri.parse('http://hydro.hydro-babiat.ovh/updateprogrammateur'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'title': 'title',
    }),
    );
}

class ProgTaskListWidget extends StatefulWidget {
  const ProgTaskListWidget({super.key});

  @override
  State<ProgTaskListWidget> createState() => _ProgTaskListWidgetState();
}

class _ProgTaskListWidgetState extends State<ProgTaskListWidget> {
  late Future<List<ProgTask>> progTasks;
  @override
  void initState() {
    super.initState();
    progTasks = fetchTasks();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ProgTask>>(
      future: progTasks,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('errer ${snapshot.error}');
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasData) {
          List<ProgTask> tasks = snapshot.data!;
          return buildTask(tasks);
        } else {
          return const Text("No more Data");
        }
      },
    );
  }
}

Widget buildTask(List<ProgTask> tasks) {
  return ListView.builder(
    itemCount: tasks.length,
    itemBuilder: (context, index) {
      return ProgTaskWidget(task: tasks[index],index:index);
    },
  );
}

class ProgTaskWidget extends StatefulWidget {
  const ProgTaskWidget({super.key, required this.task, required this.index});

  final ProgTask task;
  final int index;
  @override
  State<ProgTaskWidget> createState() => _ProgTaskWidgetState();
}

class _ProgTaskWidgetState extends State<ProgTaskWidget> {
  bool dirty = false;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text("${widget.task.name}  dirty:$dirty"),
      subtitle: Column(
        children: [
          Row(
            children: [
              Text('${widget.task.time}'),
              ElevatedButton(
                  onPressed: () async {
                    final TimeOfDay? time = await showTimePicker(
                        context: context, initialTime: widget.task.time);
                    if (time != null) {
                      setState(() {
                        widget.task.time = time;
                        dirty = true;
                      });
                    }
                  },
                  child: const Text('Select time')),
            ],
          ),
          Row(
          children: [
            Builder(builder: (context) {
              if (dirty) {
                return ElevatedButton(
                  onPressed: () {
                    setState(() async {
                      var response = await updateTask(widget.task, widget.index);
                      if (response.statusCode == 200) {

                        dirty = false;
                      }
                    });
                }, child: const Text("update"),
                );
              }
              return Container();
            },)
        ],)
        ],
      ),
      trailing: Switch(
        value: widget.task.active,
        onChanged: (value) {
          setState(() {
            dirty = true;
            widget.task.active = value;
          });
        },
      ),
    );
  }
}
