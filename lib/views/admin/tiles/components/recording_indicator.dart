import 'package:flutter/material.dart';

class RecordingIndicator extends StatefulWidget {
  final bool _recording;
  final double _fromSize;
  final double _toSize;
  final started = DateTime.now();
  var _expanding = true;

  RecordingIndicator(this._recording, this._fromSize, this._toSize,
      {super.key});

  @override
  State<StatefulWidget> createState() => _RecordingIndicatorState();
}

class _RecordingIndicatorState extends State<RecordingIndicator> {
  late double _size;
  static const duration = 600;

  @override
  void initState() {
    _size = widget._fromSize;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(milliseconds: duration), () {
      if (!mounted) return;

      setState(() {
        _size = widget._expanding ? widget._toSize : widget._fromSize;
      });
      widget._expanding = !widget._expanding;
    });

    if (widget._recording) {
      return AnimatedContainer(
          duration: const Duration(milliseconds: duration),
          decoration: BoxDecoration(
              color: Colors.red, borderRadius: BorderRadius.circular(_size)),
          width: _size,
          height: _size,
          child: Center(
              child: Text(
                  DateTime.now()
                      .difference(widget.started)
                      .inSeconds
                      .toString(),
                  style: const TextStyle(color: Colors.white))));
    } else {
      return Container(
          height: widget._fromSize,
          width: widget._fromSize,
          decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(widget._fromSize)));
    }
  }
}
