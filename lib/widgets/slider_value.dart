

import 'dart:developer';

import 'package:flutter/material.dart';

class SliderValue extends StatefulWidget {
  const SliderValue({
    super.key,
  });

  @override
  State<SliderValue> createState() => _SliderValueState();
}

class _SliderValueState extends State<SliderValue> {
  double _value = 0;
  final _controller =  TextEditingController() ;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_setvalue);
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
        onChangeEnd: (value) {
          
        },
        onChanged: (value) {
          setState(() {
            _value = value;
            _controller.text = _value.toString();
          });
        },
      ),
      Text('value: $_value'),
      SizedBox(
        width: 120,
        child: TextField(
          controller: _controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Test',
          ),
          onEditingComplete: () {
            log('editcomplete');
          },
          onSubmitted: (String newvalue) {
            if (newvalue.isNotEmpty ) {
              log("par ici $newvalue");
              _value = double.parse(newvalue);
              
            }
          },
        ),
      )
    ]);
  }

  void _setvalue() {
    setState(() {
      _value = double.parse(_controller.text).roundToDouble();
    });
  }
}