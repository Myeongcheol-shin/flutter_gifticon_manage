import 'package:flutter/material.dart';

class Cards {
  final String name, info;
  final String? couponNumber;
  final Color color;
  final bool hasImage;

  Cards(this.name, this.info, this.color, this.hasImage, this.couponNumber);
}
