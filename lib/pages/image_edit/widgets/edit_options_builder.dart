
import 'package:flutter/material.dart';

import '../../../utils/constants.dart';
import '../image_edit_view_model.dart';

class EditOptionsBuilder extends StatelessWidget {
  final ImageEditViewModel viewModel;
  final VoidCallback onCrop;
  final VoidCallback onFlip;
  final VoidCallback changeHue;
  final VoidCallback changeBrightness;
  final VoidCallback changeSaturation;
  final VoidCallback changeOpacity;
  const EditOptionsBuilder({
    Key? key,
    required this.viewModel,
    required this.onCrop,
    required this.onFlip,
    required this.changeHue,
    required this.changeBrightness,
    required this.changeSaturation,
    required this.changeOpacity
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Container(
      height: 100,
      alignment: Alignment.center,
      decoration:  BoxDecoration(
          color: Theme.of(context).backgroundColor,
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16))
      ),
      child: ListView(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        children: viewModel.imageEditOptions.map((e){
          var icon = e["icon"] as IconData;
          var value = e["value"] as String;
          return Padding(
            padding: const EdgeInsets.all(12),
            child: GestureDetector(
              onTap: (){
                if(value=="crop"){
                  onCrop();
                }else if(value=="flip"){
                  onFlip();
                }else if(value=="hue"){
                  changeHue();
                }else if(value=="brightness"){
                  changeBrightness();
                }else if(value=="saturation"){
                  changeSaturation();
                }else if(value=="fade"){
                  changeOpacity();
                }
              },
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(circle)
                    ),
                    child: Icon(icon),
                  ),
                  const SizedBox(height: 4,),
                  Text(value)
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}