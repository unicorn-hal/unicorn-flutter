class PrimaryDoctorsCache {
  static final PrimaryDoctorsCache _instance = PrimaryDoctorsCache._internal();
  factory PrimaryDoctorsCache() => _instance;
  PrimaryDoctorsCache._internal();

  List<String>? _data;
  List<String>? get data => _data;

  void setData(List<String> data) {
    _data = data;
  }

  void addData(String data) {
    _data!.add(data);
  }

  void removeData(String data) {
    _data!.remove(data);
  }

  /// 主治医に登録している医者かどうかを判定する
  /// [doctorId] 医者ID
  bool isPrimaryDoctor(String doctorId) {
    List<String> doctorList = _data ?? [];
    return doctorList.contains(doctorId);
  }
}
