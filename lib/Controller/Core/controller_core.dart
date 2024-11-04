abstract class ControllerCore {
  String? from;
  ControllerCore({this.from}) {
    initialize();
  }

  /// 初期化処理
  /// 画面遷移時に呼び出される
  /// 画面遷移時に必要なデータの取得や、初期値の設定を行う
  /// 画面遷移時に何もしない場合は空実装でOK
  /// 画面遷移時に何かしらの処理を行う場合は、このメソッドをオーバーライドして処理を記述する
  void initialize();
}
