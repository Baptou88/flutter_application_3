import 'package:flutter/material.dart';

class ProgTask {
  ProgTask(
      {required this.activate,
      required this.time,
      
      required this.name,
      required this.targetVanne});

  String name;
  bool activate;
  int targetVanne;
  TimeOfDay time;

  factory ProgTask.fromJson(Map<String, dynamic> json) {
    
    return ProgTask(
        activate: json['activate'],
        time: TimeOfDay(hour: json['h'], minute: json['m']),
        name: json['name'],
        targetVanne: json['targetVanne']);
  }
}

List<ProgTask> progTasks = [
  ProgTask(activate: false, time: const TimeOfDay(hour: 12, minute: 12), name: "name", targetVanne: 20),
  ProgTask(activate: false, time: const TimeOfDay(hour: 16, minute: 32),name: 'qdze2', targetVanne: 44),
];

class ProgTaskWidget extends StatefulWidget {
  const ProgTaskWidget({super.key, required this.task});

  final ProgTask task;
  @override
  State<ProgTaskWidget> createState() => _ProgTaskWidgetState();
}

class _ProgTaskWidgetState extends State<ProgTaskWidget> {
  //var task = State.of<
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.task.name),
      subtitle: Row(
        children: [
          Text('${widget.task.time}'),
          ElevatedButton(
            onPressed: () async {
              final TimeOfDay? time = await showTimePicker(context: context, initialTime: widget.task.time);
              if (time != null) {
                setState(() {
                  widget.task.time = time;
                });
              }
            },
             child: const Text('Select time')),
        ],
      ),
      trailing: Switch(
        value: widget.task.activate,
        onChanged: (value) {
          setState(() {
            widget.task.activate = value;
          });
        },
      ),
    );
  }
}
