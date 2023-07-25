import 'package:flutter/material.dart';
import 'dart:io';

class Cards {
  final String name, info;
  final String? couponNumber;
  final Color color;
  final File? image;

  Cards(this.name, this.info, this.color, this.image, this.couponNumber);
}
