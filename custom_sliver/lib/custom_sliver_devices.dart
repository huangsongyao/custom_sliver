import 'dart:io';

import 'package:flutter/material.dart';

abstract class HSYDevicesStatus {
  static num bottomsPadding(BuildContext context) {
    return (MediaQuery.of(context).padding.bottom ?? 0.0);
  }

  static bool hasBottomsPadding(BuildContext context) {
    return (Platform.isIOS
        ? (HSYDevicesStatus.bottomsPadding(context) > 0)
        : false);
  }
}

class HSYIosBottomSafeWidget extends StatelessWidget {
  final Color color;

  HSYIosBottomSafeWidget({
    this.color = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: HSYDevicesStatus.bottomsPadding(context),
      color: this.color,
    );
  }
}