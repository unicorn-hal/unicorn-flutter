import 'package:unicorn_flutter/Service/Log/log_service.dart';
import 'package:url_launcher/url_launcher.dart' as package;

class UrlLauncherService {
  /// 外部URLにアクセスする
  /// [url] String URL文字列
  Future<void> launchUrl(String url) async {
    try {
      final Uri uri = Uri.parse(url);
      // 外部ブラウザでURLを開く
      await package.launchUrl(
        uri,
      );
      Log.echo('URLを開きました。', symbol: '✅');
    } catch (e) {
      Log.echo('URLを開けませんでした。エラー: $e', symbol: '❌');
    }
  }
}
