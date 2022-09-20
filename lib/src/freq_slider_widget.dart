import 'package:flutter/material.dart';

/// A basic slider for selecting frequencies in hertz.
class FreqSliderWidget extends StatefulWidget {
  /// Creates a new [FreqSliderWidget] given some bounds.
  const FreqSliderWidget({
    super.key,
    required this.label,
    required this.minFreq,
    required this.maxFreq,
    required this.interval,
    required this.initFreq,
    this.onChanged,
  });

  /// The display name of this slider.
  final String label;

  /// The minimum selectable frequency.
  final double minFreq;

  /// The maximum selectable frequency.
  final double maxFreq;

  /// The interval between frequencies to parition with.
  final double interval;

  /// The starting frequency.
  final double initFreq;

  /// The callback that is called when the selected frequency is changed.
  final void Function(double newValue)? onChanged;

  @override
  State<FreqSliderWidget> createState() => _FreqSliderWidgetState();
}

class _FreqSliderWidgetState extends State<FreqSliderWidget> {
  late var _selectedHz = widget.initFreq;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(widget.label),
        ),
        Slider(
          value: _selectedHz,
          min: widget.minFreq,
          max: widget.maxFreq,
          divisions:
              ((widget.maxFreq - widget.minFreq) / widget.interval).round(),
          label: '${_selectedHz.toInt()} Hz',
          onChanged: (newValue) {
            setState(() {
              _selectedHz = newValue;
            });

            widget.onChanged?.call(_selectedHz);
          },
        ),
      ],
    );
  }
}
