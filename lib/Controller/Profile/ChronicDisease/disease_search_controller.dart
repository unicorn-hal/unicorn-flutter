import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:unicorn_flutter/Constants/strings.dart';
import 'package:unicorn_flutter/Controller/Core/controller_core.dart';
import 'package:unicorn_flutter/Model/Entity/ChronicDisease/chronic_disease.dart';
import 'package:unicorn_flutter/Model/Entity/ChronicDisease/chronic_disease_request.dart';
import 'package:unicorn_flutter/Model/Entity/Disease/disease.dart';
import 'package:unicorn_flutter/Service/Api/ChronicDisease/chronic_disease_api.dart';
import 'package:unicorn_flutter/Service/Api/Disease/disease_api.dart';
import 'package:unicorn_flutter/View/bottom_navigation_bar_view.dart';

class DiseaseSearchController extends ControllerCore {
  /// Serviceのインスタンス化
  DiseaseApi get _diseaseApi => DiseaseApi();
  ChronicDiseaseApi get _chronicDiseaseApi => ChronicDiseaseApi();

  /// コンストラクタ
  DiseaseSearchController();

  /// 変数の定義
  TextEditingController diseaseController = TextEditingController();
  late List<Disease>? _diseaseList;
  late List<bool> _registrationCheck;

  /// initialize()
  @override
  void initialize() {
    _diseaseList = [];
    _registrationCheck = [];
  }

  /// 各関数の実装

  List<Disease>? get diseaseList => _diseaseList;
  void setDiseaseList(int index) {
    _diseaseList!.removeAt(index);
  }

  List<bool> get registrationCheck => _registrationCheck;

  /// 検索内容から病気のlistを取得する関数
  Future<void> getDiseaseList() async {
    ProtectorNotifier().enableProtector();
    List<ChronicDisease>? chronicDiseaseList =
        await _chronicDiseaseApi.getChronicDiseaseList();
    if (chronicDiseaseList == null) {
      Fluttertoast.showToast(msg: Strings.MEDICINE_ERROR_RESPONSE_TEXT);
      ProtectorNotifier().disableProtector();
      return;
    }
    _diseaseList =
        await _diseaseApi.getDiseaseList(diseaseName: diseaseController.text);
    if (_diseaseList == null) {
      Fluttertoast.showToast(msg: Strings.MEDICINE_ERROR_RESPONSE_TEXT);
      ProtectorNotifier().disableProtector();
      return;
    }
    for (int i = 0; i < chronicDiseaseList.length; i++) {
      for (int j = 0; j < _diseaseList!.length; j++) {
        if (chronicDiseaseList[i].diseaseName == _diseaseList![j].diseaseName) {
          _diseaseList!.removeAt(j);
        }
      }
    }
    ProtectorNotifier().disableProtector();
  }

  /// 固定のよくある病気を取得する関数
  Future<List<Disease>?> getFamousDiseaseList() async {
    _registrationCheck = [];
    List<ChronicDisease>? chronicDiseaseList =
        await _chronicDiseaseApi.getChronicDiseaseList();
    if (chronicDiseaseList == null) {
      Fluttertoast.showToast(msg: Strings.MEDICINE_ERROR_RESPONSE_TEXT);
      return null;
    }
    List<Disease>? famousDiseaseList = await _diseaseApi.getFamousDiseaseList();
    if (famousDiseaseList == null) {
      Fluttertoast.showToast(msg: Strings.MEDICINE_ERROR_RESPONSE_TEXT);
      return null;
    }
    List<String> chronicDiseaseNameList = chronicDiseaseList
        .map((chronicDisease) => chronicDisease.diseaseName)
        .toList();
    for (int i = 0; i < famousDiseaseList.length; i++) {
      if (chronicDiseaseNameList.contains(famousDiseaseList[i].diseaseName)) {
        _registrationCheck.add(true);
      } else {
        _registrationCheck.add(false);
      }
    }
    return famousDiseaseList;
  }

  /// 空文字チェックする関数
  bool checkEmpty() {
    RegExp regExp = RegExp(r'^\s*$');
    if (diseaseController.text.isEmpty == true ||
        regExp.hasMatch(diseaseController.text)) {
      Fluttertoast.showToast(msg: '何も入力されていません');
      return true;
    } else {
      return false;
    }
  }

  /// 持病に登録する関数
  Future<void> registrationDisease(int diseaseId) async {
    ProtectorNotifier().enableProtector();
    ChronicDiseaseRequest disease = ChronicDiseaseRequest(diseaseId: diseaseId);
    int res = await _chronicDiseaseApi.postChronicDisease(body: disease);
    if (res != 200) {
      Fluttertoast.showToast(msg: Strings.MEDICINE_ERROR_RESPONSE_TEXT);
    }
    ProtectorNotifier().disableProtector();
  }
}
