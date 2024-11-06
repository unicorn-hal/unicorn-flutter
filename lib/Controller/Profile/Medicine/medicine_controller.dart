import 'package:unicorn_flutter/Controller/Core/controller_core.dart';
import 'package:unicorn_flutter/Model/Entity/Medicine/medicine.dart';
import 'package:unicorn_flutter/Service/Api/Medicine/medicine_api.dart';

class MedicineController extends ControllerCore {
  /// Serviceのインスタンス化
  MedicineApi get _medicineApi => MedicineApi();

  /// コンストラクタ
  MedicineController();

  /// 変数の定義

  /// initialize()
  @override
  void initialize() {
    print('Controller Init');
  }

  /// 各関数の実装
  Future<List<Medicine>?> getMedicineList() async {
    List<Medicine>? medicineList = await _medicineApi.getMedicineList();
    if (medicineList == null) {
      return medicineList;
    }
    print(medicineList[0].medicineName);
    return medicineList;
  }
}
