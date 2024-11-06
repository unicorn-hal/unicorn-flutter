import 'package:unicorn_flutter/Model/Entity/AppConfig/app_config.dart';
import 'package:unicorn_flutter/Model/Entity/api_response.dart';
import 'package:unicorn_flutter/Service/Api/Core/api_core.dart';
import 'package:unicorn_flutter/Service/Api/Core/endpoint.dart';

class AppConfigApi extends ApiCore with Endpoint {
  AppConfigApi() : super(Endpoint.appConfig);

  /// GET
  /// アプリケーション設定取得
  Future<AppConfig?> getAppConfig() async {
    try {
      final ApiResponse response = await get();
      return AppConfig.fromJson(response.data);
    } catch (e) {
      return null;
    }
  }
}
