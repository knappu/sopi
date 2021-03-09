import 'package:flutter/material.dart';
import 'package:get/get.dart';

const RoundedRectangleBorder shapeDialog = const RoundedRectangleBorder(
  borderRadius: const BorderRadius.all(
    Radius.circular(8.0),
  ),
);

/// SIZED BOX
const SizedBox formSizedBoxHeight = SizedBox(height: 10);
const SizedBox formSizedBoxWidth = SizedBox(width: 10);

FlatButton cancelDialogButton = FlatButton(
  child: Text(
    'Cancel',
  ),
  onPressed: () => Get.back(),
);


BoxDecoration getBoxDecoration(Color color,
    {withOpacity = 0.7,
      all = true,
      double topLeft = 0.0,
      double topRight = 0.0,
      double  bottomLeft = 0.0,
      double  bottomRight = 0.0}) {
  return BoxDecoration(
    gradient: LinearGradient(
      colors: [
        color.withOpacity(withOpacity),
        color,
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    borderRadius: all
        ? BorderRadius.all(Radius.circular(8.0))
        : BorderRadius.only(
      topLeft: Radius.circular(topLeft),
      topRight: Radius.circular(topRight),
      bottomLeft: Radius.circular(bottomLeft),
      bottomRight: Radius.circular(bottomRight),
    ),
  );
}