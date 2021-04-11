import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sopi/common/scripts.dart';
import 'package:sopi/models/assets/asset_product_model.dart';
import 'package:sopi/models/orders/order_item_model.dart';
import 'package:sopi/models/products/product_item_model.dart';
import 'package:sopi/services/orders/order_service.dart';
import 'package:sopi/services/products/product_service.dart';
import 'package:sopi/ui/shared/animations.dart';
import 'package:sopi/ui/shared/app_colors.dart';
import 'package:sopi/ui/shared/shared_styles.dart';
import 'package:sopi/ui/widgets/common/loadingDataInProgress/loading_data_in_progress_widget.dart';
import 'package:sopi/ui/widgets/employee/orders/dialogs/order_dialog_addExtraTime_widget.dart';

class OrderWaitingWidget extends StatefulWidget {
  final AssetProductModel assetProductModel;

  const OrderWaitingWidget(this.assetProductModel);

  @override
  _OrderWaitingWidgetState createState() => _OrderWaitingWidgetState(
      this.assetProductModel.oid, this.assetProductModel.pid);
}

class _OrderWaitingWidgetState extends State<OrderWaitingWidget> {
  final _orderService = OrderService.singleton;
  final String oid;
  final String pid;
  Timer _timer;
  Duration _timeWaiting;

  _OrderWaitingWidgetState(this.oid, this.pid);

  OrderItemModel _orderItemModel;
  ProductItemModel _productItemModel;
  bool _isInit = true;
  bool _isLoading = false;

  @override
  void initState() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      _loadData();
      _isInit = false;
      _timer = Timer.periodic(Duration(seconds: 1), (Timer t) => _getTime());
    }

    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _getTime() {
    if (_isLoading) return;
    setState(() {
      final now = DateTime.now();
      _timeWaiting = now.difference(_orderItemModel.createDate);
    });
  }

  String get timeWaitingDisplay {
    return durationInMinutes(_timeWaiting);
  }

  Future<Null> _loadData() async {
    final productService = ProductService.singleton;
    _orderItemModel = await _orderService.getOrderById(this.oid);
    _productItemModel = await productService.getProductById(this.pid);
    setState(() {
      _isLoading = false;
    });
  }

  TextStyle textStyle =
      TextStyle(fontWeight: FontWeight.bold, color: primaryColor);

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? LoadingDataInProgressWidget()
        : Card(
            // color: primaryColor,
            shape: shapeCard,
            elevation: defaultElevation,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '#${_orderItemModel.humanNumber}',
                    style: textStyle,
                  ),
                  Column(
                    children: [
                      Text(
                        '${_productItemModel.name}',
                        style: textStyle,
                      ),
                      Text(
                        'Prepare time: ${_productItemModel.prepareTime}',
                        style: textStyle,
                      ),
                    ],
                  ),
                  Text('$timeWaitingDisplay', style: textStyle)
                ],
              ),
            ),
          );
  }
}