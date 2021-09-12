import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CustomShimmerListtile extends StatelessWidget {
  final String type;
  const CustomShimmerListtile({Key? key, required this.type}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[400]!,
      highlightColor: Colors.grey[100]!,
      child: ListTile(
        leading: CircleAvatar(
          radius: type == "Player" ? 12 : 25,
        ),
        title: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            color: Colors.white,
          ),
          width: double.infinity,
          height: type == "Player" ? 20 : 25,
        ),
        subtitle: Align(
          alignment: Alignment.centerLeft,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              color: Colors.white,
            ),
            width: MediaQuery.of(context).size.width / 3,
            height: 15,
          ),
        ),
      ),
    );
  }
}
