
import 'dart:io';

import 'package:flutter/material.dart';

import '../../../utils/color_filter_generator.dart';

class ImageFilter extends StatelessWidget {
  final double brightness;
  final double saturation;
  final double hue;
  final String imagePath;
  final Color color;
  final double opacity;
  const ImageFilter({
    Key? key,
    required this.imagePath,
    required this.brightness,
    required this.hue,
    required this.saturation,
    required this.opacity,
    this.color = Colors.transparent
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {


    return ColorFiltered(
        colorFilter: ColorFilter.matrix(
          ColorFilterGenerator.brightnessAdjustMatrix(
            value: brightness,
          ),

        ),
        child: ColorFiltered(
            colorFilter: ColorFilter.matrix(
                ColorFilterGenerator.saturationAdjustMatrix(
                  value: saturation,
                )
            ),
            child: ColorFiltered(
              colorFilter: ColorFilter.matrix(
                  ColorFilterGenerator.hueAdjustMatrix(
                    value: hue,
                  )
              ),
              child: ColorFiltered(
                colorFilter: ColorFilter.mode(color, BlendMode.hue),
                child: Opacity(
                  opacity: opacity,
                  child: Image.file(File(imagePath)),
                ),
              ),
            )
        )
    );
  }
}