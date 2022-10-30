import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LoadingElement extends StatelessWidget {
  final double height;
  final double width;
  final Axis scrollDirection;

  const LoadingElement({
    Key? key,
    required this.height,
    required this.width,
    required this.scrollDirection,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.25,
      child: ListView.separated(
        shrinkWrap: true,
        scrollDirection: scrollDirection,
        itemBuilder: (context, index) {
          return Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            period: const Duration(seconds: 2),
            child: Material(
              elevation: 8.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Container(
                width: width,
                height: height,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey[400]!,
                ),
              ),
            ),
          );
        },
        separatorBuilder: (context, index) => const SizedBox(
          height: 15,
          width: 15,
        ),
        itemCount: 20,
      ),
    );
  }
}
