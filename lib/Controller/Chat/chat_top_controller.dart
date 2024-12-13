import 'package:unicorn_flutter/Controller/Core/controller_core.dart';
import '../../Model/Cache/Doctor/PrimaryDoctors/primary_doctors_cache.dart';

class ChatTopController extends ControllerCore {
  ChatTopController();

  @override
  void initialize() {}

  /// 主治医に登録している医者かどうかを判定する
  /// [doctorId] 医者ID
  bool isPrimaryDoctor(String doctorId) {
    List<String> doctorList = PrimaryDoctorsCache().data ?? [];
    return doctorList.contains(doctorId);
  }
}
