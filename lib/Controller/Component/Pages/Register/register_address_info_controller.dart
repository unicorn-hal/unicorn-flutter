import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:unicorn_flutter/Constants/prefectures.dart';
import 'package:unicorn_flutter/Constants/strings.dart';
import 'package:unicorn_flutter/Controller/Core/controller_core.dart';
import 'package:unicorn_flutter/Model/Data/User/user_data.dart';
import 'package:unicorn_flutter/Model/Entity/User/address_info.dart';
import 'package:unicorn_flutter/Model/Entity/User/user.dart';
import 'package:unicorn_flutter/Model/Entity/User/user_request.dart';
import 'package:unicorn_flutter/Model/Entity/location_address_info.dart';
import 'package:unicorn_flutter/Route/router.dart';
import 'package:unicorn_flutter/Route/routes.dart';
import 'package:unicorn_flutter/Service/Api/User/user_api.dart';
import 'package:unicorn_flutter/Service/Package/Location/location_service.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_text.dart';
import 'package:unicorn_flutter/View/bottom_navigation_bar_view.dart';

class RegisterAddressInfoController extends ControllerCore {
  LocationService get _locationService => LocationService();
  UserApi get _userApi => UserApi();

  RegisterAddressInfoController({
    required this.context,
    required super.from,
  });

  BuildContext context;
  UserData userData = UserData();

  late List<String> _entryItemStrings;
  late LatLng _mapPinPosition;

  int selectedPrefectureIndex = 0;

  ValueNotifier<bool> _protector = ValueNotifier(false);

  /// 入力欄のコントローラー
  TextEditingController postalCodeTextController = TextEditingController();
  TextEditingController municipalitiesTextController = TextEditingController();
  TextEditingController addressDetailTextController = TextEditingController();

  @override
  void initialize() {
    _entryItemStrings = ['未設定'] + Prefectures.list;
    _mapPinPosition =
        const LatLng(35.69168711233464, 139.69700732758113); // HAL東京・仮初期値
  }

  ValueNotifier<bool> get protector => _protector;

  List<String> get entryItemStrings => _entryItemStrings;
  LatLng get mapPinPosition => _mapPinPosition;

  void setTextEditingController() {
    if (from == Routes.profile) {
      List<String> splitedAddress = userData.user!.address.split(',');

      String prefectureFromSplitAddress = splitedAddress[0];
      String municipalitiesFromSplitAddress = splitedAddress[1];
      String? addressDetailFromSplitAddress =
          splitedAddress.length > 2 ? splitedAddress[2] : null;

      postalCodeTextController.text = userData.user!.postalCode;
      selectedPrefectureIndex =
          _entryItemStrings.indexOf(prefectureFromSplitAddress);
      municipalitiesTextController.text = municipalitiesFromSplitAddress;
      if (addressDetailFromSplitAddress != null &&
          addressDetailFromSplitAddress.isNotEmpty) {
        addressDetailTextController.text = addressDetailFromSplitAddress;
      }
    }
  }

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

    AddressInfo(
      postalCode: postalCode!,
      prefectures: prefecture!,
      municipalities: "${city}${town}",
      addressDetail: addressDetailTextController.text,
    );
  }

  /// 現在位置から住所を取得し、入力欄にセットする
  Future<void> setAddressFromLocation() async {
    if (from == Routes.profile) {
      ProtectorNotifier().enableProtector();
    } else {
      _protector.value = true;
    }
    final LocationAddressInfo? currentPositionInfo =
        await _locationService.getAddressFromPosition();
    if (from == Routes.profile) {
      ProtectorNotifier().disableProtector();
    } else {
      _protector.value = false;
    }
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
    if (from == Routes.profile) {
      ProtectorNotifier().enableProtector();
    } else {
      _protector.value = true;
    }
    LocationAddressInfo? addressFromPostalCode = await _locationService
        .getAddressFromPostalCode(postalCodeTextController.text);
    if (from == Routes.profile) {
      ProtectorNotifier().disableProtector();
    } else {
      _protector.value = false;
    }
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

  Future<void> submit(UserRequest userRequest) async {
    if (validateField() == false) {
      return;
    }

    AddressInfo addressInfo = AddressInfo(
      postalCode: postalCodeTextController.text,
      prefectures: _entryItemStrings[selectedPrefectureIndex],
      municipalities: municipalitiesTextController.text,
      addressDetail: addressDetailTextController.text,
    );

    userRequest.postalCode = addressInfo.postalCode;
    userRequest.address =
        "${addressInfo.prefectures},${addressInfo.municipalities},${addressInfo.addressDetail}";

    if (from == Routes.profile) {
      ProtectorNotifier().enableProtector();
      int responceCode = await _userApi.putUser(
          userId: userData.user!.userId, body: userRequest);
      ProtectorNotifier().disableProtector();
      if (responceCode == 400 || responceCode == 500) {
        Fluttertoast.showToast(msg: Strings.ERROR_RESPONSE_TEXT);
        ProfileRoute().go(context);
        return;
      }
      // シングルトンに登録した値をセットする
      userData.setUser(User.fromJson(userRequest.toJson()));
      Fluttertoast.showToast(msg: Strings.PROFILE_EDIT_COMPLETED_MESSAGE);
      ProfileRoute().go(context);
      return;
    }

    RegisterUserInfoRoute($extra: userRequest).push(context);

    return;
  }

  bool validateField() {
    List<String> emptyMessageField = [];
    postalCodeTextController.text.isEmpty
        ? emptyMessageField.add("郵便番号")
        : null;
    _entryItemStrings[selectedPrefectureIndex] == '未設定'
        ? emptyMessageField.add('都道府県')
        : null;
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
