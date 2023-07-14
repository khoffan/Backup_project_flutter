import 'package:flutter/material.dart';

class CustomRadio extends StatefulWidget {
  final int value, groupValue;
  final Color? color, selectColor;
  final Function(int?)? onChanged;

  const CustomRadio(
      {super.key,
      required this.value,
      required this.groupValue,
      this.color = Colors.grey,
      this.selectColor = Colors.amber,
      this.onChanged});

  @override
  State<CustomRadio> createState() => _CustomRadioState();
}

class _CustomRadioState extends State<CustomRadio> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        bool selected = widget.value != widget.groupValue;
        if (selected) {
          widget.onChanged!(widget.value);
        }
      },
      child: Container(
        height: 20.0,
        width: 20.0,
        decoration: BoxDecoration(
          color: widget.value == widget.groupValue
              ? widget.selectColor
              : widget.color,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
