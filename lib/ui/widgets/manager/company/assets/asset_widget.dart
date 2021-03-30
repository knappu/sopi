import 'package:flutter/material.dart';
import 'package:sopi/models/assets/asset_item_model.dart';
import 'package:sopi/models/user/user_model.dart';
import 'package:sopi/ui/widgets/manager/company/assets/assets_list_widget.dart';
import 'package:sopi/ui/widgets/manager/company/assets/employee/asset_employee_list_widget.dart';
import 'package:provider/provider.dart';
import 'package:sopi/models/assets/assets_model.dart';
import 'package:sopi/ui/widgets/common/loadingDataInProgress/loading_data_in_progress_widget.dart';

class AssetWidget extends StatefulWidget {
  @override
  _AssetWidgetState createState() => _AssetWidgetState();
}

class _AssetWidgetState extends State<AssetWidget>
    with TickerProviderStateMixin {
  bool _isInit = true;
  bool _isLoading = false;
  List<AssetItemModel> _assets = [];
  List<UserModel> _employees = [];

  Future<Null> _loadData() async {
    AssetsModel assets = Provider.of<AssetsModel>(context);
    if (!assets.isInit) {
      await assets.fetchAssets();
    }
    _assets = assets.assets;
    _employees = await UserModel.fetchAllEmployees();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      _loadData();
      _isInit = false;
    }
    super.didChangeDependencies();
  }

  void _removeAsset(AssetItemModel asset) {
    asset.removeAsset();

    setState(() {
      _assets.removeWhere((element) => element.aid == asset.aid);
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? LoadingDataInProgressWidget()
        : Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    flex: 3,
                    child: AssetListWidget(_assets, _removeAsset),
                  ),
                  Expanded(child: AssetEmployeeListWidget(_employees)),
                ],
              ),
            ],
          );
  }
}
