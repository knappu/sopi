import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sopi/factory/order_factory.dart';
import 'package:sopi/models/basket/basket_model.dart';
import 'package:sopi/ui/shared/animations.dart';
import 'package:sopi/ui/shared/app_colors.dart';
import 'package:sopi/ui/shared/shared_styles.dart';

import 'dialogs/basket_successAdd_dialog.dart';

class BasketBottomWidget extends StatelessWidget {
  final OrderFactory _orderFactory = OrderFactory.singleton;
  final BasketModel _basket =
      Provider.of<BasketModel>(Get.context, listen: false);

  Future<Null> _confirmOrder() async {
    /// FEATURE'S PAYMENT'S
    final orderNumber = await _orderFactory.createOrder(_basket.productsOrder);
    _basket.clearBasket();
    Get.back();

    showScaleDialog(BasketSuccessAddDialog(orderNumber));
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text(
                'Summary',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(children: [
                ..._basket.products.values
                    .map((product) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              getRoundedSquareButton(product.count),
                              formSizedBoxWidth,
                              Text('${product.name}'),
                              Spacer(),
                              Text('${product.displayTotalPrice}'),
                            ],
                          ),
                        ))
                    .toList(),
                Divider(
                  color: primaryColor,
                ),
                Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Text(
                        '${_basket.displaySummaryPrice}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    )),
              ]),
            ),
            TextButton(
              style: TextButton.styleFrom(backgroundColor: primaryColor),
              onPressed: _confirmOrder,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Confirm',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
