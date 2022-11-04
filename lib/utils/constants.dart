
import 'package:flutter/material.dart';

const appAssets = "assets/images/";

const primaryColor = Color(0xFF2066FF);
const secondaryColor = Color(0xFF01147C);

const tcPrimary = Color(0xFF6B60F1);
const tcBlack = Color(0xFF000000);
const tcGrey = Color(0xFFF0F0F0);
const tcWhite = Color(0xFFFFFFFF);
const promptColor = Color(0xFFD0D0D0);

const ternary = Color(0xFF06B2FF);
const primaryLight = Color(0xFFCFE0FA);
const subText = Color(0xFF9F9F9F);
const info = Color(0xFFB0B0B0);
const iconColor = Color(0xFF1E1E1E);
const error = Color(0xFFFF0000);
const error50 = Color(0xFFCC4444);
const success = Color(0xFF226642);
const warning = Color(0xFFF1C232);

const double blunt = 8;
const double circle = 100;


const splashGradient = LinearGradient(
    colors: [
      Color(0xFF8a3ab9),
      Color(0xFFe95950),
      Color(0xFFbc2a8d),
      Color(0xFFcd486b),
      Color(0xFF4c68d7),
    ],
    stops: [0,0.3,0.4,0.6,1],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight
);

const shimmerGradient = LinearGradient(
    colors: [
      Color(0xFFA0A0A0),
      Color(0xFFD0D0D0),
      Color(0xFFA0A0A0),
    ],
    stops: [0,0.5,1],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight
);