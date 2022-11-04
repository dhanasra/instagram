import 'package:flutter/material.dart';

import '../../utils/constants.dart';

class ButtonWL extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onPressed;
  final String label;
  final double width;
  final bool widthChangeOnLoad;
  final bool isBlunt;
  final bool isBorderOnly;
  final EdgeInsets? margin;
  final IconData? icon;
  final Color? bgColor;

  const ButtonWL({
    Key? key,
    required this.isLoading,
    required this.onPressed,
    required this.label,
    this.widthChangeOnLoad = true,
    this.width = 180,
    this.isBlunt = false,
    this.icon,
    this.bgColor,
    this.margin,
    this.isBorderOnly = false
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: ElevatedButton(
          onPressed: onPressed,
          style: ButtonStyle(
              minimumSize: MaterialStateProperty.all(Size(isLoading ? widthChangeOnLoad ? 50 : width : width, 50)),
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(isBlunt ? blunt : circle),
                  side: BorderSide(width: isBorderOnly?1:0, color: bgColor ?? primaryColor)
              )),
              foregroundColor: !isBorderOnly ? MaterialStateProperty.all(Colors.white) : null,
              backgroundColor: bgColor !=null
                  ? MaterialStateProperty.all(bgColor)
                  : (isBorderOnly ? MaterialStateProperty.all(Colors.white) : null),
              elevation: MaterialStateProperty.all(4)
          ),
          child: isLoading
              ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
              : SizedBox(
                child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                          if(icon!=null) Icon(icon, color: isBorderOnly ? primaryColor : null,),
                          if(icon!=null) const SizedBox(width: 10,),
                          Text(label, style: TextStyle(color: isBorderOnly ? primaryColor : null),)
                      ],
                )
              )
      ),
    );
  }
}
