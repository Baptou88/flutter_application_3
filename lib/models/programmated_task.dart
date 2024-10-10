import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
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

  if (response.statusCode != 200) {}
  final body = json.decode(response.body);
  final List tasks = body["tasks"];
  log("par ici");
  //List<ProgTask> temp = tasks.map((e) => ProgTask.fromJson(e)).toList();
  List<ProgTask> temp = List.empty(growable: true);
  tasks.asMap().forEach((key, value) {
    ProgTask t = ProgTask.fromJson(value);
    t.id = key;
    temp.add(t);
  });
  return temp.toList();
}

Future<Response> updateTask(ProgTask task) {
  final dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 3),
    ),
  );
  return dio.post("http://hydro.hydro-babiat.ovh/updateprogrammateur",
      data: task.toJson(),
      options: Options(
          contentType: ContentType.parse("application/x-www-form-urlencoded")
              .toString()));
  // return  http.post(
  //   Uri.parse('http://hydro.hydro-babiat.ovh/updateprogrammateur'),
  //   headers: <String, String>{
  //     // 'Content-Type': 'application/json; charset=UTF-8',
  //     'Content-Type': 'application/x-www-form-urlencoded',
  //   },
  //   body: jsonEncode(task.toJson()),
  //   encoding: Encoding.getByName('utf-8')
  //   );
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
  return ListView.separated(
    separatorBuilder: (context, index) {
      return const Divider();
    },
    itemCount: tasks.length,
    itemBuilder: (context, index) {
      return ProgTaskWidget(task: tasks[index], index: index);
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
  bool editName = false;
  final TextEditingController myController = TextEditingController();

  final FocusNode fn = FocusNode();

  @override
  void initState() {
    
    super.initState();
    myController.text = widget.task.name;
    log(myController.text);
  }


  @override
  void dispose() {
    
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: newMethod(editName),
      onTap: () {
       setState(() {
          editName = false;
       });
      },
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
              Builder(
                builder: (context) {
                  if (dirty) {
                    return ElevatedButton(
                      onPressed: () {
                        setState(() {
                          updateTask(widget.task).then((value) {
                            if (value.statusCode == 200) {
                              log('success  ${value.data}');

                              dirty = false;
                            } else {
                              log('erreur ${value.statusCode}');
                            }
                          });
                        });
                      },
                      child: const Text("update"),
                    );
                  }
                  return Container();
                },
              )
            ],
          )
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

  Widget newMethod(bool edit) {
    return !edit ? Row(
      children: [
        Text(widget.task.name),
        ElevatedButton(
          child: const Text("Edit Name"),
          onPressed: () {
            setState(() {
              editName = true;
              fn.requestFocus();
              //equivalent ->
              //FocusScope.of(context).requestFocus(fn); 
            });
          },
        )
      ],
    ) 
    : 
    Row(
      children: [
        SizedBox(
          width: 120,
          child: TextField(
            focusNode: fn,
            controller: myController,
            onChanged: (text) {
              setState(() {
                dirty = true;
                widget.task.name = text;
              });
            },
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Test',
            ),
            ),
        )],
          );
  }
}
