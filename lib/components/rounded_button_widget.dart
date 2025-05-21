import 'package:flutter/material.dart';

class RoundedButtonWidget extends StatelessWidget {
  const RoundedButtonWidget({
    Key? key,
    required this.onPressed,
    this.iconData = Icons.close,
  }) : super(key: key);

  final VoidCallback onPressed;
  final IconData iconData;

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: onPressed,
      fillColor: Colors.black.withOpacity(0.2),
      padding: const EdgeInsets.all(15),
      shape: const CircleBorder(),
      child: Icon(
        iconData,
        color: Colors.white,
      ),
    );
  }
}
