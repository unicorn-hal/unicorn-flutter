import 'package:unicorn_flutter/Service/Log/log_service.dart';
import 'package:url_launcher/url_launcher.dart' as package;

class UrlLauncherService {
  /// 外部URLにアクセスする
  /// [url] String URL文字列
  Future<void> launchUrl(String url) async {
    try {
      // URLをエンコードしてUriオブジェクトを作成
      final String encodedUrl = Uri.encodeFull(url);
      final Uri uri = Uri.parse(encodedUrl);

      // URLを開けるか確認
      if (!await package.canLaunchUrl(uri)) {
        Log.echo('URLを開けませんでした。', symbol: '❌');
        return;
      }

      // 外部ブラウザでURLを開く
      await package.launchUrl(
        uri,
        mode: package.LaunchMode.externalApplication,
      );
      Log.echo('URLを開きました。', symbol: '✅');
    } catch (e) {
      Log.echo('URLを開けませんでした。エラー: $e', symbol: '❌');
    }
  }
}
