import 'package:fluttertoast/fluttertoast.dart';
import 'package:unicorn_flutter/Constants/strings.dart';
import 'package:unicorn_flutter/Controller/Core/controller_core.dart';
import 'package:unicorn_flutter/Model/Entity/ChronicDisease/chronic_disease.dart';
import 'package:unicorn_flutter/Service/Api/ChronicDisease/chronic_disease_api.dart';

class ChronicDiseaseController extends ControllerCore {
  /// Serviceのインスタンス化
  ChronicDiseaseApi get _chronicDiseaseApi => ChronicDiseaseApi();

  /// initialize()
  @override
  void initialize() {}

  /// 各関数の実装
  /// 持病のlistを取得する関数
  Future<List<ChronicDisease>?> getChronicDiseaseList() async {
    List<ChronicDisease>? chronicDiseaseList =
        await _chronicDiseaseApi.getChronicDiseaseList();
    return chronicDiseaseList;
  }

  /// 持病のlistから選択した持病を削除する関数
  Future<void> deleteChronicDisease(String chronicDiseaseId) async {
    int res = await _chronicDiseaseApi.deleteChronicDisease(
        chronicDiseaseId: chronicDiseaseId);
    if (res != 204) {
      Fluttertoast.showToast(msg: Strings.MEDICINE_ERROR_RESPONSE_TEXT);
    }
  }
}
