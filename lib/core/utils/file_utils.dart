import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';

class FileUtils {
  FileUtils._();

  static Future<File> writeBytesToTempFile(
    Uint8List bytes, {
    String fileName = 'temp_file',
  }) async {
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/$fileName');
    return file.writeAsBytes(bytes, flush: true);
  }
}
