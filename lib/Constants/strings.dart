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
  static const String CHAT_POST_RESPONSE_ERROR = 'メッセージの送信に失敗しました。';

  // おくすり登録・修正時のvalidateに使うテキスト
  static const String MEDICINE_VALIDATE_TEXT = 'おくすりの名称とおくすりの量は必須の入力項目です';
  static const String MEDICINE_VALIDATE_COUNT_TEXT =
      'おくすりの量には100以下の数値を入力してください';
  static const String MEDICINE_VALIDATE_DOSAGE_TEXT =
      '1回の服用量がおくすりの量よりも多く設定されています';

  // 通信エラー発生時に使うテキスト
  static const String ERROR_RESPONSE_TEXT = '通信エラーが発生しました';

  // ローディング中に表示するテキスト
  static const String LOADING_TEXT = 'ロード中';

  // 設定反映時に使うテキスト
  static const String SETTING_REFLECTED_TEXT = '設定を反映しました';

  // 連絡先へのアクセスが未許可のときに使うテキスト
  static const String REQUEST_PERMISSION_ERROR_TEXT =
      '端末設定から連絡先へのアクセスを許可してください';

  // メールアドレスが未登録に表示するテキスト
  static const String FAMILY_EMAIL_NOT_REGISTERED_TEXT = 'メールアドレスが登録されていません';

  // メールアドレス登録時のvalidateに使うテキスト
  static const String FAMILY_EMAIL_VALIDATE_FIELD_TEXT =
      'メールアドレスおよび姓と名の登録が必要です';
  static const String FAMILY_EMAIL_VALIDATE_FORMAT_TEXT = 'メールアドレスの形式が正しくありません';

  // 通話予約関連で使用するテキスト
  static const String VOICE_CALL_SET_ERROR_TEXT = '通話予約日時を選択してください';
  static const String VOICE_CALL_DISABLE_ERROR_TEXT =
      'この時間は予約できません。他の時間を選択してください';
  static const String VOICE_CALL_RESERVE_ERROR_TEXT = '通話予約に失敗しました';

  // ユーザープロフィール登録完了時に表示するテキスト
  static const String PROFILE_REGISTRATION_COMPLETED_MESSAGE =
      'ユーザーが正常に登録されました';
  // プロフィール編集完了時に表示するテキスト
  static const String PROFILE_EDIT_COMPLETED_MESSAGE = '情報が正常に更新されました';
}
