import 'package:flutter/material.dart';

import '../../utils/constants.dart';

class GoogleButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;

  const GoogleButton({
    Key? key,
    required this.label,
    required this.onPressed
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ElevatedButton(
          onPressed: onPressed,
          style: ButtonStyle(
              minimumSize: MaterialStateProperty.all(const Size(double.infinity, 50)),
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(blunt),
                side: const BorderSide(color: promptColor)
              )),
              padding: MaterialStateProperty.all(const EdgeInsets.only(left: 10)),
              backgroundColor: MaterialStateProperty.all(Colors.white),
              foregroundColor: MaterialStateProperty.all(subText),
              elevation: MaterialStateProperty.all(4)
          ),
          child: Text(label),
        ),
        Positioned(
          left: 12, top: 0, bottom: 0,
          child: Image.asset(
            "${appAssets}google.png", width: 28, height: 28,),
        ),
      ]
    );
  }
}
