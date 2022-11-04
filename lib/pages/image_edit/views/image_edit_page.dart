
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:instagram/app/app.dart';
import 'package:instagram/app/app_routes.dart';
import 'package:instagram/pages/image_edit/image_edit_view_model.dart';
import 'package:instagram/utils/constants.dart';
import '../widgets/edit_options_builder.dart';
import '../widgets/image_filter.dart';
import '../widgets/slider_builder.dart';

class ImageEditPage extends StatefulWidget {
  const ImageEditPage({Key? key}) : super(key: key);

  @override
  State<ImageEditPage> createState() => _ImageEditPageState();
}

class _ImageEditPageState extends State<ImageEditPage> {
  late double hue;
  late double brightness;
  late double saturation;
  late ImageEditViewModel viewModel;
  late String imagePath;
  late double opacity;
  late bool isFlipped;

  GlobalKey globalKey = GlobalKey();

  @override
  void initState() {
    hue = 0;
    brightness = 0;
    isFlipped = false;
    saturation = 0;
    opacity = 1;
    viewModel = ImageEditViewModel();
    imagePath = ImageEditViewModel.imagePath!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        actions: [
          IconButton(
              onPressed: ()async{
                await captureImage().then((imageBytes) {
                  const App().setNavigation(context, AppRoutes.createPost, args: imageBytes);
                });
              },
              splashRadius: 26,
              icon: const Icon(Icons.check,size: 28,)
          )
        ],
      ),
      body: Container(
      color: Colors.black,
      child: Column(
        children: [

          Expanded(
              child: RepaintBoundary(
                  key: globalKey,
                  child: Transform(
                    transform: Matrix4.rotationY(isFlipped?pi:0),
                    alignment: Alignment.center,
                    child: ImageFilter(
                    hue: hue,
                    brightness: brightness,
                    saturation: saturation,
                    imagePath: imagePath,
                    opacity: opacity,
                  ),
                ),
              )
          ),

          EditOptionsBuilder(
            viewModel: viewModel,
            onFlip: ()=>setState(() { isFlipped=!isFlipped; }),
            changeHue: (){
              showBottomSheet(
                  title: "hue", value: hue,
                  onCancel: ()=>setState(() =>hue=0),
                  onChanged: (val)=>setState(()=>hue=val)
              );
            },
            changeBrightness: (){
              showBottomSheet(
                  title: "brightness", value: brightness,
                  onCancel: ()=>setState(() =>brightness=0),
                  onChanged: (val)=>setState(()=>brightness=val)
              );
            },
            changeSaturation: (){
              showBottomSheet(
                  title: "saturation", value: saturation,
                  onCancel: ()=>setState(() =>saturation=0),
                  onChanged: (val)=>setState(()=>saturation=val)
              );
            },
            changeOpacity: (){
              showBottomSheet(
                  title: "opacity", value: opacity,
                  onCancel: ()=>setState(() =>opacity=0),
                  onChanged: (val)=>setState(()=>opacity=val)
              );
            },
            onCrop: () async{
              await ImageCropper().cropImage(
                sourcePath: imagePath,
                aspectRatioPresets: [
                  CropAspectRatioPreset.square,
                  CropAspectRatioPreset.ratio3x2,
                  CropAspectRatioPreset.original,
                  CropAspectRatioPreset.ratio4x3,
                  CropAspectRatioPreset.ratio16x9
                ],
                uiSettings: [
                  AndroidUiSettings(
                      toolbarTitle: 'Crop Image',
                      toolbarColor: Theme.of(context).scaffoldBackgroundColor,
                      toolbarWidgetColor: primaryColor,
                      initAspectRatio: CropAspectRatioPreset.original,
                      activeControlsWidgetColor: primaryColor,
                      lockAspectRatio: false),
                  IOSUiSettings(
                    title: 'Cropper',
                  ),
                ],
              ).then((value){
                if(value!=null) {
                  setState(() {
                    imagePath=value.path;
                  });
                }
              });
            },
          ),

        ],
      ),
      ),
    );
  }

  Future<Uint8List> captureImage() async {
    RenderRepaintBoundary boundary = globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage();
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List imageBytes = byteData!.buffer.asUint8List();
    return imageBytes;
  }

  void showBottomSheet({
    required String title,
    required double value,
    required VoidCallback onCancel,
    required ValueChanged onChanged,
  }){
    showModalBottomSheet(
        context: context,
        builder: (_){
          return SliderBuilder(
              onChanged: (val)=>onChanged(val),
              onCancel: onCancel,
              title: title,
              value: value
          );
        }
    );
  }

}





