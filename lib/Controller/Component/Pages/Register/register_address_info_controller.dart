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

  List<String> get entryItemStrings => _entryItemStrings;
  LatLng get mapPinPosition => _mapPinPosition;

  void setTextEditingController() {
    if (from == Routes.profile) {
      postalCodeTextController.text = userData.user!.postalCode;
      municipalitiesTextController.text = userData.user!.address;
    } else {
      return;
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

    if (from == Routes.profile) {
      userRequest = UserRequest(
        userId: userData.user!.userId,
        firstName: userData.user!.firstName,
        lastName: userData.user!.lastName,
        email: userData.user!.email,
        gender: userData.user!.gender,
        birthDate: userData.user!.birthDate,
        address:
            "${addressInfo.prefectures}${addressInfo.municipalities}${addressInfo.addressDetail}",
        postalCode: addressInfo.postalCode,
        phoneNumber: userData.user!.phoneNumber,
        iconImageUrl: userData.user!.iconImageUrl,
        bodyHeight: userData.user!.bodyHeight,
        bodyWeight: userData.user!.bodyWeight,
        occupation: userData.user!.occupation,
      );
      ProtectorNotifier().enableProtector();
      Future<int> responceCode =
          _userApi.putUser(userId: userData.user!.userId, body: userRequest);
      ProtectorNotifier().disableProtector();
      if (await responceCode == 200) {
        // シングルトンに登録した値をセットする
        userData.setUser(User.fromJson(userRequest.toJson()));
        Fluttertoast.showToast(msg: Strings.PROFILE_EDIT_COMPLETED_MESSAGE);
        ProfileRoute().push(context);
        return;
      }
      if (await responceCode == 400) {
        Fluttertoast.showToast(msg: Strings.ERROR_RESPONSE_TEXT);
        ProfileRoute().push(context);
        return;
      }
      if (await responceCode == 500) {
        Fluttertoast.showToast(msg: Strings.ERROR_RESPONSE_TEXT);
        ProfileRoute().push(context);
        return;
      }
    }

    userRequest = UserRequest(
      postalCode: addressInfo.postalCode,
      address:
          "${addressInfo.prefectures}${addressInfo.municipalities} ${addressInfo.addressDetail}",
    );

    RegisterUserInfoRoute(from: Routes.registerUserInfo, $extra: userRequest)
        .push(context);

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
