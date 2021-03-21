import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sopi/ui/shared/app_colors.dart';
import 'package:sopi/ui/shared/shared_styles.dart';

class BasketSuccessAddDialog extends StatelessWidget {
  final int orderNumber;

  BasketSuccessAddDialog(this.orderNumber);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: shapeDialog,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Lottie.asset('assets/animations/success.json', repeat: false),
          Text(
            'Your\'s order #$orderNumber',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: primaryColor),
          ),
          backDialogButton,
        ],
      ),
    );
  }
}