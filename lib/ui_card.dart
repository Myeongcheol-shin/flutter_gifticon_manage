import 'package:flutter/material.dart';
import 'dart:io';

class CardView extends StatefulWidget {
  final String name, info;
  final String? couponNumber;
  final Color color;
  final String? image;

  const CardView(
      {super.key,
      required this.couponNumber,
      required this.color,
      required this.name,
      required this.info,
      required this.image});

  @override
  State<CardView> createState() => _CardViewState();
}

class _CardViewState extends State<CardView> {
  Future<void> showCouponDialog(
      BuildContext context, String? image, String? couponNumber) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                image != null ? Image.file(File(image)) : const SizedBox(),
                couponNumber != null
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 30,
                          ),
                          Text(
                            "Coupon Number",
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 20,
                                color: Colors.grey[700]),
                          ),
                          Text(
                            couponNumber,
                            style: const TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.w700,
                                color: Colors.black),
                          ),
                        ],
                      )
                    : const SizedBox()
              ],
            ),
            actions: const <Widget>[],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 160,
      decoration: BoxDecoration(
        color: widget.color,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 5.0,
              offset: const Offset(3, 3))
        ],
      ),
      child: Row(
        children: [
          Transform.translate(
            offset: const Offset(-35, 0),
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: const SizedBox(width: 70, height: 80),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          CustomPaint(
            painter: DashedLinePainter(
                axis: Axis.vertical, // 가로 방향으로 점선을 그립니다.
                color: Colors.white, // 점선의 색상을 원하는 색상으로 변경하세요.
                dashWidth: 2, // 점선의 간격 너비를 조절합니다.
                dashHeight: 4, // 점선의 높이를 조절합니다.
                count: 20),
            child: const SizedBox(
              width: 10, // 점선이 그려지는 사각형의 너비
              height: 160, // 점선이 그려지는 사각형의 높이
            ),
          ),
          Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      widget.name,
                      style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          decoration: TextDecoration.none),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      widget.info,
                      style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.none),
                    ),
                    const Spacer(
                      flex: 1,
                    ),
                    widget.image != null || widget.couponNumber != null
                        ? GestureDetector(
                            onTap: () {
                              showCouponDialog(
                                  context, widget.image, widget.couponNumber);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10)),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black.withOpacity(0.3),
                                        blurRadius: 5.0,
                                        offset: const Offset(2, 2))
                                  ]),
                              child: const Text(
                                "Detail",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.black,
                                    decoration: TextDecoration.none),
                              ),
                            ),
                          )
                        : const SizedBox()
                  ],
                ),
              ))
        ],
      ),
    );
  }
}

class DashedLinePainter extends CustomPainter {
  final Axis axis;
  final Color color;
  final double dashWidth;
  final double dashHeight;
  final double count;

  DashedLinePainter({
    required this.axis,
    this.color = Colors.white,
    this.dashWidth = 5,
    this.dashHeight = 1,
    this.count = 10,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = color
      ..strokeWidth = axis == Axis.horizontal ? dashHeight : dashWidth;

    final double primaryAxisSize =
        axis == Axis.horizontal ? size.width : size.height;

    final double dashSpacing = primaryAxisSize / (2 * count - 1);

    final double halfDashSpacing = dashSpacing / 2;
    double currentOffset = 0;

    while (currentOffset < primaryAxisSize) {
      if (axis == Axis.horizontal) {
        canvas.drawLine(
          Offset(currentOffset, 0),
          Offset(currentOffset + dashWidth, 0),
          paint,
        );
      } else {
        canvas.drawLine(
          Offset(0, currentOffset),
          Offset(0, currentOffset + dashHeight),
          paint,
        );
      }

      currentOffset += dashSpacing + halfDashSpacing;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
