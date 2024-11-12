// ignore_for_file: constant_identifier_names

class Strings {
  /// Stringsファイルにおける変数名は全て大文字で記述する
  /// 例：static const String SAMPLE = 'sample';

  // AIアナウンスバナーに使用するテキスト
  static const String AI_BANNER_TITLE_HEALTHCHECK = 'AIチャットで簡単健康チェック！';
  static const String AI_BANNER_TITLE_ASK = 'AIに聞いてみよう！';
  static const String AI_BANNER_DESCRIPTION_HEALTHCHECK =
      '体の悩みをAIが分析して対処法や改善点などをアドバイスしてくれます。';
  static const String AI_BANNER_DESCRIPTION_ASK =
      '持病の種類やおくすりの詳細情報がわからないときはAIに聞いて自動追加してもらおう。';

  // CustomLoadingAnimationに表示するテキスト
  static const String LOADING_TEXT_INSPECTION = '検査中です';
  static const String LOADING_TEXT_TREATMENT = '治療中です';
  static const String LOADING_TEXT_BODY_TEMPERATURE = '体温を測定中です';
  static const String LOADING_TEXT_BLOOD_PRESSURE = '血圧を測定中です';

  // 検診ボタンに使用するテキスト
  static const String HEALTH_CHECK_BUTTON_TEXT = '今日の検診を開始する';
  static const String HEALTH_CHECK_BUTTON_AI = 'AI音声検診を開始する';

  // 生体認証に使用するテキスト
  static const String LOCAL_AUTH_REASON_TEXT = 'お客様のプライバシーを保護するために生体認証を利用します。';

  // ダイアログに使用するテキスト
  static const String DIALOG_TITLE_CAVEAT = '警告';
  static const String DIALOG_BODY_TEXT_DELETE = '本当に削除しますか？';

  // 検診結果に使用するテキスト
  static const String HEALTH_CHECKUP_RESULT_DESCRIPTION_SAFETY =
      '体温・血圧ともに平均値です。体調が優れない場合は医師との通話やAIチャットを利用してください。';
  static const String
      HEALTH_CHECKUP_RESULT_DESCRIPTION_BODY_TEMPERATURE_HAZARD =
      '体温が平均値から外れています。体調が優れない場合は医師との通話やAIチャットを利用してください。';
  static const String HEALTH_CHECKUP_RESULT_DESCRIPTION_BLOOD_PRESSURE_HAZARD =
      '血圧が平均値から外れています。体調が優れない場合は医師との通話やAIチャットを利用してください。';
  static const String HEALTH_CHECKUP_RESULT_DESCRIPTION_DANGER =
      '体温・血圧ともに平均値から外れています。緊急時は医師との通話やAIチャットを利用してください。';

  // おくすり登録・修正時のvalidateに使うテキスト
  static const String MEDICINE_VALIDATE_TEXT = 'おくすりの名称とおくすりの量は必須の入力項目です';
  // おくすり登録・修正・削除時のエラー発生時に使うテキスト
  static const String MEDICINE_ERROR_RESPONSE_TEXT = '通信エラーが発生しました';
  // ローディング中に表示するテキスト
  static const String LOADING_TEXT = 'ローディング中';
}
