import 'package:flutter/material.dart';

class MapButtonWidget extends StatelessWidget {

  final void Function() onpress;
  final Color color;
  final Icon icon;

  const MapButtonWidget({Key? key, required this.onpress, required this.color, required this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onpress,
      materialTapTargetSize: MaterialTapTargetSize.padded,
      backgroundColor: color,
      child: icon,
    );
  }
}
