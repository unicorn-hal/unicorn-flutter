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
import 'package:unicorn_flutter/Service/Log/log_service.dart';
import 'package:unicorn_flutter/View/bottom_navigation_bar_view.dart';

class DiseaseSearchController extends ControllerCore {
  /// Serviceのインスタンス化
  DiseaseApi get _diseaseApi => DiseaseApi();
  ChronicDiseaseApi get _chronicDiseaseApi => ChronicDiseaseApi();

  /// コンストラクタ
  DiseaseSearchController(this._chronicDiseaseList);
  List<ChronicDisease>? _chronicDiseaseList;

  /// 変数の定義
  TextEditingController diseaseTextController = TextEditingController();
  List<Disease>? _diseaseList = [];
  List<Disease>? _famousDiseaseList;
  late List<bool> _registrationCheck = [];
  late bool _isSearched = false;

  /// initialize()
  @override
  void initialize() {}

  /// 各関数の実装

  List<Disease>? get diseaseList => _diseaseList;
  void setDiseaseList(int index) {
    _diseaseList!.removeAt(index);
  }

  List<bool> get registrationCheck => _registrationCheck;
  void setRegistrationCheck(int index) {
    _registrationCheck[index] = true;
  }

  bool get isSearched => _isSearched;
  void setIsSearched() {
    _isSearched = true;
  }

  /// 検索内容から病気のlistを取得する関数
  Future<void> getDiseaseList() async {
    ProtectorNotifier().enableProtector();
    if (!_isSearched) {
      setIsSearched();
    }
    try {
      _diseaseList = await _diseaseApi.getDiseaseList(
          diseaseName: diseaseTextController.text);
      if (_diseaseList == null) {
        Fluttertoast.showToast(msg: Strings.MEDICINE_ERROR_RESPONSE_TEXT);
        throw ('Disease search failed');
      }
      if (_famousDiseaseList == null) {
        _diseaseList = null;
        throw ('famousDisease get failed');
      }

      /// 検索結果からよくあるお悩みを排除
      _diseaseList = _diseaseList!
          .where((disease) => !_famousDiseaseList!
              .any((famous) => famous.diseaseName == disease.diseaseName))
          .toList();
      if (_chronicDiseaseList == null) {
        throw ('chronicDisease is null');
      }

      /// 検索結果から持病を排除
      _diseaseList = _diseaseList!
          .where((disease) => !_chronicDiseaseList!
              .any((chronic) => chronic.diseaseName == disease.diseaseName))
          .toList();
    } catch (e) {
      Log.echo('error: $e');
    } finally {
      ProtectorNotifier().disableProtector();
    }
  }

  /// 固定のよくある病気を取得する関数
  Future<List<Disease>?> getFamousDiseaseList() async {
    _registrationCheck = [];
    _famousDiseaseList = await _diseaseApi.getFamousDiseaseList();
    if (_famousDiseaseList == null) {
      Fluttertoast.showToast(msg: Strings.MEDICINE_ERROR_RESPONSE_TEXT);
      return null;
    }
    if (_chronicDiseaseList == null) {
      for (int i = 0; i < _famousDiseaseList!.length; i++) {
        _registrationCheck.add(false);
      }
      ProtectorNotifier().disableProtector();
      return _famousDiseaseList;
    }

    /// よくあるお悩みが持病登録されているかを配列で返す
    for (Disease famous in _famousDiseaseList!) {
      _registrationCheck.add(_chronicDiseaseList!
          .any((chronic) => chronic.diseaseName == famous.diseaseName));
    }
    return _famousDiseaseList;
  }

  /// 空文字チェックする関数
  bool checkEmpty() {
    RegExp regExp = RegExp(r'^\s*$');
    if (diseaseTextController.text.isEmpty == true ||
        regExp.hasMatch(diseaseTextController.text)) {
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

  /// 持病のリストを更新する関数(よくあるお悩みを持病に登録時のみ使用)
  Future<void> updateChronicDiseaseList() async {
    ProtectorNotifier().enableProtector();
    _chronicDiseaseList = await _chronicDiseaseApi.getChronicDiseaseList();
    if (_chronicDiseaseList == null) {
      Fluttertoast.showToast(msg: Strings.MEDICINE_ERROR_RESPONSE_TEXT);
    }
    ProtectorNotifier().disableProtector();
  }
}
