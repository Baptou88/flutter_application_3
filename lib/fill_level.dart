import 'package:flutter/material.dart';

class FillLevel extends StatefulWidget {
  final double fillLevel; // Niveau de Remplissage entre 0 et 100

  const FillLevel({super.key, required this.fillLevel});

  @override
  State<FillLevel> createState() => _FillLevelState();
}

class _FillLevelState extends State<FillLevel> {
  double _currentFillLevel = 0.0;

  @override
  void initState() {
    super.initState();
    _currentFillLevel = widget.fillLevel;
  }

  @override
  void didUpdateWidget(covariant FillLevel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.fillLevel != _currentFillLevel) {
      setState(() {
        _currentFillLevel = widget.fillLevel;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(seconds: 1),
      curve: Curves.easeInOut,
      width: 100,
      height: 200,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 2.0),
        color: Theme.of(context).secondaryHeaderColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: AnimatedContainer(
              duration: const Duration(seconds: 1),
              curve: Curves.easeInOut,
              height: widget.fillLevel * 200,
              //color: Colors.blue,
              decoration: BoxDecoration(
                color: Colors.blue[400],
                //border: Border.all(color: Colors.black, width: 2.0),
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(10),
                  top: Radius.circular(10)
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
