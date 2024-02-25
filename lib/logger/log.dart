import 'package:mem/framework/repository/entity.dart';

/// # Logとは
///
/// 時間と位置、行動の記録
///
// ## 語源
//
// 言葉の意味としては「丸太」、「切り出した原木」、「1枚革をはいだだけの材木」
//
// 船乗りが常に知っておきたいものの一つに自船の位置がある。
// これは緯度経度を測ることで分かり、緯度は正午の太陽の高さから測ることができたが、経度が難しかった。
// 経度を船の速度から測るため、船首から丸太を流して時間経過と丸太との距離から船の速度を測り航海日誌（Logbook）に記録した。
//
// このことから記録自体をLogと呼ぶようになったとされる。
//
// ### 関連
//
// #### Blog
//
// ウェブサイトの記録 Web Logが省略されてBlogになったとされる。
//
// #### Knot
//
// 言葉の意味としては「結び目」。
//
// 速度を測るために投げ込む丸太は本来燃料なので紐をつけて回収できるようにした。
// この紐に一定間隔で結び目をつけ、一定時間に出た結び目を数えることで速度を測れるようにした。
//
// このことから、海上での速度をKnotと呼ぶようになったとされる。
//
// 統一のため、1Knotで進む距離を1海里と定め、1海里は緯度の1分の1852メートルとも定められている。
//
// #### Log in
//
// 言葉の意味としては「丸太を投げ込め！」という号令で、「航海開始」を表す
//
// 航海日誌においては、最初の記録ということになる
class Log extends Entity {
  final Level level;
  final List<String> prefixes;
  final dynamic target;
  final dynamic error;
  final StackTrace? stackTrace;

  Log(
    this.level,
    this.prefixes,
    this.target,
    this.error,
    this.stackTrace,
  );

  String buildMessage() {
    return [
      prefixes.join(),
      _format(target),
    ].join();
  }

  static const defaultIndent = "  ";

  String _format(dynamic target) {
    final stringBuffer = StringBuffer();

    if (target is Iterable) {
      stringBuffer.writeln(target is Set ? "{" : "[");

      for (var value in target) {
        stringBuffer.writeln("$defaultIndent${_format(value)},");
      }
      stringBuffer.write(target is Set ? "}" : "]");
    } else if (target is Map) {
      stringBuffer.writeln("{");

      for (var entry in target.entries) {
        stringBuffer.writeln("$defaultIndent${entry.key}: ${entry.value},");
      }
      stringBuffer.write("}");
    } else {
      stringBuffer.write(target);
    }

    return stringBuffer.toString();
  }
}

enum Level {
  /// 処理のすべてを出力する際に利用する
  // # 意味
  // 多弁、冗長
  // ほとんどの場合、否定的な意味で用いられる
  //
  // # 語源
  // verbum（言葉、ラテン語）に由来し、verbosus（言葉であふれた、ラテン語）
  verbose,

  /// 特に記録したい処理に利用する
  info,

  /// 処理は継続できるか何かしらの問題が発生している際に利用する
  warning,

  /// 処理を継続できない際に利用する
  error,

  /// デバッグの際に利用する
  debug,
}
