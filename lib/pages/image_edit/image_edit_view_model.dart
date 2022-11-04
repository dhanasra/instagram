import 'package:flutter/material.dart';


class ImageEditViewModel {
  static late ImageEditViewModel _instance;
  factory ImageEditViewModel() {
    _instance = ImageEditViewModel._internal();
    return _instance;
  }

  static String? imagePath;
  static List<String>? images;

  ImageEditViewModel._internal(){
    init();
  }

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final imageEditOptions =[
    {
      "icon":Icons.crop,
      "value":"crop"
    },
    {
      "icon":Icons.flip,
      "value":"flip"
    },
    {
      "icon":Icons.air,
      "value":"hue"
    },
    {
      "icon":Icons.wb_sunny_outlined,
      "value":"brightness"
    },
    {
      "icon":Icons.water_drop_rounded,
      "value":"saturation"
    },
    {
      "icon":Icons.cloud_queue_outlined,
      "value":"fade"
    }
  ];

  void init(){

  }

}