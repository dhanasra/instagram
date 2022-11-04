import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LoadingShimmer extends StatelessWidget {
  const LoadingShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.withOpacity(0.2),
      highlightColor: Colors.grey.withOpacity(0.4),
      enabled: true,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children:  [
            Row(children: [
              const CircleAvatar(),
              const SizedBox(width: 10,),
              Container(
                width: 130,
                height: 30,
                decoration: BoxDecoration(
                    color: Colors.white,borderRadius: BorderRadius.circular(4)),
              )
            ],),
            const SizedBox(height: 10,),
            Container(
              width: double.infinity,
              height: 280 ,
              decoration: BoxDecoration(
                  color: Colors.white,borderRadius: BorderRadius.circular(4)),
            ),
            const SizedBox(height: 10,),
            Container(
              width: double.infinity,
              height: 30 ,
              decoration: BoxDecoration(
                  color: Colors.white,borderRadius: BorderRadius.circular(4)),
            ),
          ],
        ),
      ),
    );
  }
}
