import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:unicorn_flutter/Constants/prefectures.dart';
import 'package:unicorn_flutter/Controller/Core/controller_core.dart';
import 'package:unicorn_flutter/Model/Entity/location_address_info.dart';
import 'package:unicorn_flutter/Service/Package/Location/location_service.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_text.dart';

class RegisterAddressInfoController extends ControllerCore {
  final TextEditingController postCode = TextEditingController();
  final TextEditingController municipalities = TextEditingController();
  final TextEditingController addressDetail = TextEditingController();

  final List<String> entryItemStrings = ['未設定'] + Prefectures.list;

  LocationService locate = LocationService();
  int? selectedPrefectureIndex = 0;

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

  Future<void> potisionSubmit() async {
    final LocationAddressInfo? currentPositionInfo =
        await locate.getAddressFromPosition();
    if (currentPositionInfo == null) {
      return;
    }
    final String postalCode = currentPositionInfo.postalCode;
    final String prefecture = currentPositionInfo.prefecture;
    final String city = currentPositionInfo.city;
    final String town = currentPositionInfo.town;
    int selectedIndex = entryItemStrings.indexOf(prefecture);
    selectedPrefectureIndex = selectedIndex;
    postCode.text = postalCode;
    municipalities.text = city + town;
  }

  Future<void> postcodeSubmit() async {
    LocationAddressInfo? addressFromPostalCode =
        await locate.getAddressFromPostalCode(postCode.text);
    if (addressFromPostalCode == null) {
      return;
    }
  }

  bool validateField() {
    List<String> emptyMessageField = [];
    postCode.text.isEmpty ? emptyMessageField.add("郵便番号") : null;
    entryItemStrings == ['未設定'] ? emptyMessageField.add('都道府県') : null;
    municipalities.text.isEmpty ? emptyMessageField.add("市区町村") : null;

    if (emptyMessageField.isNotEmpty) {
      Fluttertoast.showToast(msg: "${emptyMessageField.join(',')}が入力されていません。");
      return false;
    }
    return true;
  }
}
