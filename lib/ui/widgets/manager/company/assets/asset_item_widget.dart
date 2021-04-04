import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sopi/factory/field_builder_factory.dart';
import 'package:sopi/models/assets/asset_item_model.dart';
import 'package:sopi/models/assets/assets_model.dart';
import 'package:sopi/models/assets/enums/assets_enum_bookmark.dart';
import 'package:sopi/ui/shared/app_colors.dart';
import 'package:sopi/ui/shared/shared_styles.dart';
import 'assign/employee/asset_employee_item_widget.dart';
import 'assign/employee/asset_employee_unassigned_widget.dart';

class AssetItemWidget extends StatefulWidget {
  final AssetItemModel asset;
  final bool assigned;
  final Function removeHandler;

  AssetItemWidget(this.asset, this.assigned, this.removeHandler);

  @override
  _AssetItemWidgetState createState() => _AssetItemWidgetState(this.asset);
}

class _AssetItemWidgetState extends State<AssetItemWidget> {
  final AssetItemModel _asset;
  bool _isInit = true;
  AssetsEnumBookmark _displayBookmarks;

  _AssetItemWidgetState(this._asset);

  final FieldBuilderFactory _formFactory = FieldBuilderFactory();
  final GlobalKey _assetItemKey = GlobalKey();
  Size _assetItemSize;
  Offset cardPosition;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => getSizeAndPosition());
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      _displayBookmarks = Provider.of<AssetsModel>(context).displayBookmarks;
      _isInit = false;
    }

    super.didChangeDependencies();
  }

  void getSizeAndPosition() {
    if (_assetItemKey.currentContext != null) {
      RenderBox _cardBox = _assetItemKey.currentContext.findRenderObject();
      _assetItemSize = _cardBox.size;
    }
  }

  void _changeEditMode(AssetItemModel asset) {
    if (asset.editMode) {
      asset.updateName();
    }
    setState(() {
      asset.editMode = !asset.editMode;
    });
  }

  void _removeEmployee(String id) {
    setState(() {
      _asset.removeAssignedEmployee(id);
    });
  }

  @override
  Widget build(BuildContext context) {
    getSizeAndPosition();
    final textColor = widget.assigned ? Colors.white : Colors.black;

    return Transform.scale(
      scale: widget.assigned ? 1.075 : 1.0,
      child: Material(
        borderRadius: BorderRadius.circular(22.0),
        elevation: widget.assigned ? 8.0 : 4.0,
        color: widget.assigned ? primaryColor : Colors.white,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 10.0,
            vertical: 10.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (_asset.editMode) _buildRemoveAssetButton(_asset),
                  _asset.editMode
                      ? Expanded(
                          child: _formFactory.buildTextField(
                          initialValue: _asset.name,
                          onChangedHandler: (value) => _asset.name = value,
                        ))
                      : Text(
                          _asset.name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: fontSize20,
                            color: textColor,
                          ),
                        ),
                  _buildEditModeAssetNameButtons(_asset),
                ],
              ),
              Container(
                key: _assetItemKey,
                child: !widget.assigned
                ///TODO opakować i przerzucić
                    ? _asset.getAssign(_displayBookmarks).length == 0
                        ? AssetEmployeeUnassignedWidget()
                        : SingleChildScrollView(
                            child: Wrap(
                              spacing: 5,
                              children: _asset.getAssign(_displayBookmarks)
                                  .map((employee) => AssetEmployeeWidget(
                                        employee,
                                        onDeleteHandler: _asset.editMode
                                            ? _removeEmployee
                                            : null,
                                      ))
                                  .toList(),
                            ),
                          )
                    : Container(
                        height: _assetItemSize.height,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.double_arrow, color: textColor),
                            Center(
                              child: Text(
                                'Drop here to assign',
                                style: TextStyle(
                                    color: textColor, fontSize: fontSize20),
                              ),
                            ),
                          ],
                        ),
                      ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRemoveAssetButton(AssetItemModel asset) {
    return IconButton(
      onPressed: () => widget.removeHandler(asset),
      icon: FaIcon(
        FontAwesomeIcons.trash,
        color: Colors.red,
        size: 18,
      ),
    );
  }

  Widget _buildEditModeAssetNameButtons(AssetItemModel asset) {
    return IconButton(
      onPressed: () => _changeEditMode(asset),
      icon: FaIcon(
        asset.editMode ? FontAwesomeIcons.save : FontAwesomeIcons.pencilAlt,
        color: Colors.blue,
        size: 18,
      ),
    );
  }
}
