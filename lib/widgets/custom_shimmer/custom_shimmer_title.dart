import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CustomShimmerTitle extends StatelessWidget {
  const CustomShimmerTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[400]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          color: Colors.white,
        ),
        width: MediaQuery.of(context).size.width / 2,
        height: 20,
      ),
    );
  }
}




/*

 




*/
