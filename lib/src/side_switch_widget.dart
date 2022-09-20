import 'package:flutter/material.dart';

/// A basic slider for selecting frequencies in hertz.
class SideSwitchWidget extends StatefulWidget {
  /// Creates a new [SideSwitchWidget] given some bounds.
  const SideSwitchWidget({
    super.key,
    required this.label,
    this.onChanged,
  });

  /// The display name of this slider.
  final String label;

  /// The callback that is called when the selected frequency is changed.
  final void Function(bool newValue)? onChanged;

  @override
  State<SideSwitchWidget> createState() => _SideSwitchWidgetState();
}

class _SideSwitchWidgetState extends State<SideSwitchWidget> {
  var _selectedValue = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(widget.label),
        ),
        Switch(
          value: _selectedValue,
          onChanged: (newValue) {
            setState(() {
              _selectedValue = newValue;
            });

            widget.onChanged?.call(_selectedValue);
          },
        ),
      ],
    );
  }
}
