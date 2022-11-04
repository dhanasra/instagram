import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../utils/constants.dart';

enum Tags {
  error,
  info,
  success
}

class Toaster {

  static snack({
    required String content,
    Tags tag = Tags.error
  }){
    return SnackBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      padding: const EdgeInsets.symmetric(
          vertical: 10, horizontal: 20),
      content: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: const [BoxShadow(
              color: Colors.grey,
              offset: Offset(0, 5),
              blurRadius: 6.0,
              spreadRadius: 2.0
            )],
            borderRadius: BorderRadius.circular(blunt)
        ),
        child: Row(
          children: [
            Icon(
              tag == Tags.error ? Icons.close : tag == Tags.success ? Icons.check : Icons.warning_amber_rounded,
              color: tag == Tags.error ? error : tag == Tags.success ? success : warning,
              size: 18,
            ),
            const SizedBox(width: 10,),
            Expanded(
                child: Text(
                  content,
                  style: TextStyle(
                      color: tag == Tags.error ? error : tag == Tags.success ? success : warning,
                      height: 1.4,
                      fontSize: 12,
                      fontWeight: FontWeight.w400
                  ),
                ).tr()
            )
          ],
        ),
      ),
    );
  }

}