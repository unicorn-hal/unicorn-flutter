import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:unicorn_flutter/Constants/prefectures.dart';
import 'package:unicorn_flutter/Controller/Core/controller_core.dart';
import 'package:unicorn_flutter/Model/Entity/User/address_info.dart';
import 'package:unicorn_flutter/Model/Entity/location_address_info.dart';
import 'package:unicorn_flutter/Service/Package/Location/location_service.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_text.dart';

class RegisterAddressInfoController extends ControllerCore {
  LocationService get _locationService => LocationService();

  late List<String> _entryItemStrings;
  late LatLng _mapPinPosition;

  int selectedPrefectureIndex = 0;

  /// 入力欄のコントローラー
  final TextEditingController postalCodeTextController =
      TextEditingController();
  final TextEditingController municipalitiesTextController =
      TextEditingController();
  final TextEditingController addressDetailTextController =
      TextEditingController();

  @override
  void initialize() {
    _entryItemStrings = ['未設定'] + Prefectures.list;
    _mapPinPosition =
        const LatLng(35.69168711233464, 139.69700732758113); // HAL東京・仮初期値
  }

  List<String> get entryItemStrings => _entryItemStrings;
  LatLng get mapPinPosition => _mapPinPosition;

  /// 都道府県のリストを作成
  List<DropdownMenuItem<int>> countryList() {
    final List<DropdownMenuItem<int>> dropdownItems = _entryItemStrings
        .map((e) => DropdownMenuItem(
              value: _entryItemStrings.indexOf(e),
              child: CustomText(
                text: e,
              ),
            ))
        .toList();
    return dropdownItems;
  }

  /// Mapのピンを移動する
  Future<void> updateMapPinPosition() async {
    final String address = _entryItemStrings[selectedPrefectureIndex] +
        municipalitiesTextController.text;
    LatLng? position = await _locationService.getPositionFromAddress(address);
    if (position != null) {
      _mapPinPosition = position;
    }
  }

  /// 入力欄に値をセットする
  void _setValues({
    String? postalCode,
    String? prefecture,
    String? city,
    String? town,
  }) {
    if (postalCode != null) {
      postalCodeTextController.text = postalCode;
    }
    if (city != null && town != null) {
      municipalitiesTextController.text = city + town;
    }
    if (prefecture != null) {
      selectedPrefectureIndex = _entryItemStrings.indexOf(prefecture);
    }
  }

  /// 現在位置から住所を取得し、入力欄にセットする
  Future<void> setAddressFromLocation() async {
    final LocationAddressInfo? currentPositionInfo =
        await _locationService.getAddressFromPosition();
    if (currentPositionInfo == null) {
      return;
    }

    _setValues(
      postalCode: currentPositionInfo.postalCode,
      prefecture: currentPositionInfo.prefecture,
      city: currentPositionInfo.city,
      town: currentPositionInfo.town,
    );

    await updateMapPinPosition();
  }

  /// 郵便番号から住所を取得し、入力欄にセットする
  Future<void> setAddressFromPostalCode() async {
    LocationAddressInfo? addressFromPostalCode = await _locationService
        .getAddressFromPostalCode(postalCodeTextController.text);
    if (addressFromPostalCode == null) {
      return;
    }

    _setValues(
      postalCode: addressFromPostalCode.postalCode,
      prefecture: addressFromPostalCode.prefecture,
      city: addressFromPostalCode.city,
      town: addressFromPostalCode.town,
    );

    await updateMapPinPosition();
  }

  AddressInfo? submit() {
    if (validateField() == false) {
      return null;
    }
    AddressInfo addressInfo = AddressInfo(
        postalCode: postalCodeTextController.text,
        prefectures: _entryItemStrings[selectedPrefectureIndex],
        municipalities: municipalitiesTextController.text,
        addressDetail: addressDetailTextController.text);
    return addressInfo;
  }

  bool validateField() {
    List<String> emptyMessageField = [];
    postalCodeTextController.text.isEmpty
        ? emptyMessageField.add("郵便番号")
        : null;
    _entryItemStrings == ['未設定'] ? emptyMessageField.add('都道府県') : null;
    municipalitiesTextController.text.isEmpty
        ? emptyMessageField.add("市区町村")
        : null;

    if (emptyMessageField.isNotEmpty) {
      Fluttertoast.showToast(msg: "${emptyMessageField.join(',')}が入力されていません。");
      return false;
    }
    return true;
  }
}
