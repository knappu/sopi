import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sopi/common/scripts.dart';
import 'package:sopi/models/assets/asset_product_model.dart';
import 'package:sopi/models/orders/order_model.dart';
import 'package:sopi/models/products/product_item_model.dart';
import 'package:sopi/services/orders/order_service.dart';
import 'package:sopi/services/products/product_service.dart';
import 'package:sopi/ui/shared/app_colors.dart';
import 'package:sopi/ui/shared/styles/shared_style.dart';
import 'package:sopi/ui/widgets/common/loadingDataInProgress/loading_data_in_progress_widget.dart';

class EmployeeOrderWaitingItemWidget extends StatefulWidget {
  final AssetProductModel assetProductModel;

  const EmployeeOrderWaitingItemWidget(this.assetProductModel, key)
      : super(key: key);

  @override
  _EmployeeOrderWaitingItemWidgetState createState() =>
      _EmployeeOrderWaitingItemWidgetState(
          this.assetProductModel.oid, this.assetProductModel.pid);
}

class _EmployeeOrderWaitingItemWidgetState
    extends State<EmployeeOrderWaitingItemWidget> {
  final _orderService = OrderService.singleton;
  final String? oid;
  final String? pid;
  late Timer _timer;
  Duration? _timeWaiting;

  _EmployeeOrderWaitingItemWidgetState(this.oid, this.pid);

  late OrderModel _orderModel;
  late ProductItemModel _productItemModel;
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
      _timeWaiting = now.difference(_orderModel.createDate!);
    });
  }

  String get timeWaitingDisplay {
    return durationInMinutes(_timeWaiting);
  }

  Future<void> _loadData() async {
    final productService = ProductService.singleton;
    _orderModel = await _orderService.getOrderById(this.oid);
    _productItemModel = await productService.getProductById(this.pid);

    if (!mounted) return;
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
            shape: shapeCard,
            elevation: defaultElevation,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      '#${_orderModel.humanNumber}',
                      style: textStyle,
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${_productItemModel.name}',
                          style: textStyle,
                        ),
                        Text(
                          'Prepare time: ${widget.assetProductModel.totalPrepareTime}',
                          style: textStyle,
                        ),
                      ],
                    ),
                  ),
                  Expanded(child: Text('$timeWaitingDisplay', style: textStyle))
                ],
              ),
            ),
          );
  }
}
