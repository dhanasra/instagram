
import 'package:flutter/material.dart';

import '../../../app/app.dart';

class SliderBuilder extends StatefulWidget {
  final ValueChanged onChanged;
  final VoidCallback onCancel;
  final double value;
  final String title;
  const SliderBuilder({
    Key? key,
    required this.onChanged,
    required this.onCancel,
    required this.title,
    required this.value
  }) : super(key: key);

  @override
  State<SliderBuilder> createState() => _SliderBuilderState();
}

class _SliderBuilderState extends State<SliderBuilder> {

  late double sliderValue;

  @override
  void initState() {
    sliderValue = widget.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              IconButton(onPressed: widget.onCancel, icon: const Icon(Icons.close), splashRadius: 20,),
              Text("Adjust ${widget.title}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),),
              const Spacer(),
              IconButton(
                onPressed: (){
                  const App().setBackNavigation(context);
                },
                icon: const Icon(Icons.check),
                splashRadius: 20,
              ),
            ],
          ),
          Slider(
              value: sliderValue,
              onChanged: (val){
                setState(() {
                  sliderValue = val;
                });
                widget.onChanged(val);
              }
          )
        ],
      ),
    );
  }
}