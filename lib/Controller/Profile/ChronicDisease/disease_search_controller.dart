import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:unicorn_flutter/Controller/Core/controller_core.dart';
import 'package:unicorn_flutter/Model/Entity/ChronicDisease/chronic_disease.dart';
import 'package:unicorn_flutter/Model/Entity/ChronicDisease/chronic_disease_request.dart';
import 'package:unicorn_flutter/Model/Entity/Disease/disease.dart';
import 'package:unicorn_flutter/Service/Api/ChronicDisease/chronic_disease_api.dart';
import 'package:unicorn_flutter/Service/Api/Disease/disease_api.dart';

class DiseaseSearchController extends ControllerCore {
  /// Serviceのインスタンス化
  DiseaseApi get _diseaseApi => DiseaseApi();
  ChronicDiseaseApi get _chronicDiseaseApi => ChronicDiseaseApi();

  /// コンストラクタ
  DiseaseSearchController();

  /// 変数の定義
  TextEditingController diseaseController = TextEditingController();
  late bool _initial;

  /// initialize()
  @override
  void initialize() {
    _initial = true;
  }

  /// 各関数の実装
  bool get initial => _initial;
  void setInitial() {
    _initial = false;
  }

  /// 検索内容から病気のlistを取得する関数
  Future<List<Disease>?> getDiseaseList() async {
    List<ChronicDisease>? chronicDiseaseList =
        await _chronicDiseaseApi.getChronicDiseaseList();
    if (chronicDiseaseList == null) {
      return null;
    }
    List<Disease>? diseaseList =
        await _diseaseApi.getDiseaseList(diseaseName: diseaseController.text);
    if (diseaseList == null) {
      return null;
    }
    for (int i = 0; i < chronicDiseaseList.length; i++) {
      for (int j = 0; j < diseaseList.length; j++) {
        if (chronicDiseaseList[i].diseaseName == diseaseList[j].diseaseName) {
          diseaseList.removeAt(j);
        }
      }
    }
    return diseaseList;
  }

  /// 固定のよくある病気を取得する関数
  Future<List<Disease>?> getFamousDiseaseList() async {
    return await _diseaseApi.getFamousDiseaseList();
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
    ChronicDiseaseRequest disease = ChronicDiseaseRequest(diseaseId: diseaseId);
    await _chronicDiseaseApi.postChronicDisease(body: disease);
  }
}
