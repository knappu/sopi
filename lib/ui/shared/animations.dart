import 'package:get/get.dart';
import 'package:flutter/material.dart';

showScaleDialog(Widget dialog) {
  showGeneralDialog(
    transitionBuilder: (context, a1, a2, widget) {
      return Transform.scale(
        scale: a1.value,
        child: Opacity(
          opacity: a1.value,
          child: dialog,
        ),
      );
    },
    transitionDuration: Duration(milliseconds: 200),
    context: Get.context,
    // ignore: missing_return
    pageBuilder: (context, animation1, animation2) {},
  );
}
