// ignore_for_file: constant_identifier_names, non_constant_identifier_names

import 'package:unicorn_flutter/Model/Data/AppConfig/app_config_data.dart';

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
  static String LOADING_TEXT_INSPECTION =
      AppConfigData().demoMode ? '処理中です' : '検査中です';
  static String LOADING_TEXT_TREATMENT =
      AppConfigData().demoMode ? 'お待ち下さい' : '治療中です';
  static String LOADING_TEXT_BODY_TEMPERATURE =
      AppConfigData().demoMode ? '処理中です' : '体温を測定中です';
  static String LOADING_TEXT_BLOOD_PRESSURE =
      AppConfigData().demoMode ? 'お待ち下さい' : '血圧を測定中です';

  // 検診ボタンに使用するテキスト
  static const String HEALTH_CHECK_BUTTON_TEXT = '通常検診を開始する';
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

  static const String HEALTH_CHECKUP_RESULT_RISK_LEVEL_LOW =
      '特に大きな問題はありませんが、\n日頃の健康管理を心掛けてください。';
  static const String HEALTH_CHECKUP_RESULT_RISK_LEVEL_MEDIUM =
      '注意が必要な症状が見られます。症状が続く場合は\n医師との通話やAIチャットを利用してください。';
  static const String HEALTH_CHECKUP_RESULT_RISK_LEVEL_HIGH =
      '放置すると危険な症状や病気があります。\n今すぐunicornを要請してください';

  static const String CHAT_POST_RESPONSE_ERROR = 'メッセージの送信に失敗しました。';

  // おくすり登録・修正時のvalidateに使うテキスト
  static const String MEDICINE_VALIDATE_TEXT = 'おくすりの名称とおくすりの量は必須の入力項目です';
  static const String MEDICINE_VALIDATE_COUNT_TEXT =
      'おくすりの量には100以下の数値を入力してください';
  static const String MEDICINE_VALIDATE_DOSAGE_TEXT =
      '1回の服用量がおくすりの量よりも多く設定されています';
  static const String MEDICINE_CHECK_DUPLICATE_TEXT = 'リマインダーが重複して設定されています';

  // 通信エラー発生時に使うテキスト
  static const String ERROR_RESPONSE_TEXT = '通信エラーが発生しました';

  // ローディング中に表示するテキスト
  static const String LOADING_TEXT = 'ロード中';

  // 設定反映時に使うテキスト
  static const String SETTING_REFLECTED_TEXT = '設定を反映しました';

  // 連絡先へのアクセスが未許可のときに使うテキスト
  static const String REQUEST_PERMISSION_ERROR_TEXT =
      '端末設定から連絡先へのアクセスを許可してください';

  // メールアドレスが未登録のときに表示するテキスト
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
  static const String CALL_RESERVATION_NOT_REGISTERED_TEXT = '通話予約が存在しません';

  // ユーザープロフィール登録完了時に表示するテキスト
  static const String PROFILE_REGISTRATION_COMPLETED_MESSAGE =
      'ユーザーが正常に登録されました';

  // 通話時のパーミッションエラー時に表示するテキスト
  static const String CALL_PERMISSION_ERROR_TEXT = 'カメラとマイクの使用を許可してください';

  // プロフィール編集完了時に表示するテキスト
  static const String PROFILE_EDIT_COMPLETED_MESSAGE = '情報が正常に更新されました';
  // 住所情報画面でテキストフィールド内に使用できない文字列が含まれる際に表示するテキスト
  static const String PROFILE_ADDRESS_NOT_FORMAT_ERROR_MESSAGE =
      '使用できない文字列が含まれています';

  // おくすりを服用した際に表示するテキスト
  static const String MEDICINE_TAKE_COMPLETED_MESSAGE = 'おくすりを服用しました';
  static const String MEDICINE_TAKE_ALL_COMPLETED_MESSAGE = 'すべてのおくすりを服用しました';

  // 有効な郵便番号が入力されていない際に表示するテキスト
  static const String POSTAL_CODE_VALIDATE_TEXT = '郵便番号が正しく入力されていません';

  // 主治医登録時に表示するテキスト
  static const String SUCCESS_PRIMARY_DOCTOR_TEXT = '主治医に登録しました';

  // 主治医登録解除時に表示するテキスト
  static const String SUCCESS_DELETE_PRIMARY_DOCTOR_TEXT = '主治医登録を解除しました';

  // 生体認証が端末で利用できない際に表示するテキスト
  static const String LOCAL_AUTH_NOT_AVAILABLE_TEXT = 'この端末では生体認証は利用できません';

  // 対応できるUnicornがいない際に表示するテキスト
  static const String UNICORN_NOT_FOUND_TEXT =
      '対応できるUnicornが不在のため、緊急要請を取り消しました';

  // メッセージの通報成功時に表示するテキスト
  static const String REPORT_SUCCESS_TEXT = '通報が完了しました';

  // TopLoadingに表示する注意書き
  static const List<String> TOP_LOADING_CAUTION_TEXT_LIST = [
    'このアプリは未来の可能性を探るためのデモアプリです。',
    '医療行為を目的とした利用はできません。',
    'また、実際の医療機関・団体とは一切関係ありません。'
  ];

  // ダイアログでのデモンストレーション表示用のテキスト
  static const String DEMONSTRATION_DIALOG_TITLE = '注意';
  static const String DEMONSTRATION_DIALOG_BODY =
      '※ このアプリは医療シミュレーション用デモアプリです。\n'
      '検診結果はすべて架空のものであり、実際の医療機関は一切関係ありません。\n'
      'また、取得するデータは医療行為としての利用は一切行われません。';
}
