import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:unicorn_flutter/Constants/prefectures.dart';
import 'package:unicorn_flutter/Controller/Core/controller_core.dart';
import 'package:unicorn_flutter/Service/Package/Location/location_service.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_text.dart';

class RegisterAddressInfoController extends ControllerCore {
  final TextEditingController addressNumber = TextEditingController();
  final TextEditingController address = TextEditingController();
  final TextEditingController addressDetail = TextEditingController();
  final List<String> entryItemStrings = ['未設定'] + Prefectures.list;

  LocationService locate = LocationService();

  void initialize() {}

  List<DropdownMenuItem<int>> countryList() {
    final List<DropdownMenuItem<int>> dropdownItems = entryItemStrings
        .map((e) => DropdownMenuItem(
              value: entryItemStrings.indexOf(e),
              child: CustomText(
                text: e,
              ),
            ))
        .toList();
    return dropdownItems;
  }

  Future<AddressInfo?> submit() async {
    if (validateField() == false) {
      return null;
    }
    locate.getAddressFromPosition();
    return addressInfo;
  }

  Future<Position?> potisionSubmit() {
    Future<Position?> currentPositionInfo = locate.getCurrentPosition();
    return currentPositionInfo;
  }

  bool validateField() {
    List<String> emptyMessageField = [];
    addressNumber.text.isEmpty ? emptyMessageField.add("郵便番号") : null;
    entryItemStrings == ['未設定'] ? emptyMessageField.add('都道府県') : null;
    address.text.isEmpty ? emptyMessageField.add("市区町村") : null;
    addressDetail.text.isEmpty ? emptyMessageField.add("住所詳細") : null;

    if (emptyMessageField.isNotEmpty) {
      Fluttertoast.showToast(msg: "${emptyMessageField.join(',')}が入力されていません。");
      return false;
    }
    return true;
  }
}
