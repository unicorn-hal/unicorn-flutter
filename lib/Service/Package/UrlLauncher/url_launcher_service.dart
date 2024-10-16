import 'package:unicorn_flutter/Service/Log/log_service.dart';
import 'package:url_launcher/url_launcher.dart' as package;

class UrlLauncherService {
  /// 外部URLにWebViewでアクセスする
  /// [url] String URL文字列
  Future<void> launchUrl(String url) async {
    Uri uri = Uri.parse(url);
    if (!(await package.canLaunchUrl(uri))) {
      Log.echo('URLを開けませんでした。', symbol: '❌');
      return;
    }
    await package.launchUrl(uri);
  }
}
