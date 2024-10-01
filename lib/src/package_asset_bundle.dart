import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class PackageAssetBundle extends PlatformAssetBundle {
  PackageAssetBundle({
    required this.packageName,
  });

  final String packageName;

  late final String _packagePrefix = 'packages/$packageName/';

  @override
  Future<ByteData> load(String key) async {
    if (key == 'AssetManifest.bin' || key == 'AssetManifest.bin.json') {
      var bytes = await super.load(key);
      if (kIsWeb) {
        final jsonData = utf8.decode(Uint8List.sublistView(bytes));
        bytes = ByteData.sublistView(
          base64.decode(json.decode(jsonData) as String),
        );
      }
      const codec = StandardMessageCodec();
      var data = codec.decodeMessage(bytes);
      if (data is Map) {
        data = _removePackagePrefixFromKeysOf(data);
      }
      var result = codec.encodeMessage(data)!;
      if (kIsWeb) {
        final jsonData = json.encode(
          base64.encode(Uint8List.sublistView(result)),
        );
        result = ByteData.sublistView(utf8.encode(jsonData));
      }
      return result;
    }
    return super.load(_ensureHasPackagePrefix(key));
  }

  String _ensureHasPackagePrefix(String key) {
    if (!key.startsWith('packages/')) {
      return '$_packagePrefix$key';
    }
    return key;
  }

  Map _removePackagePrefixFromKeysOf(Map data) {
    return data.map((key, value) {
      if (key is String && key.startsWith(_packagePrefix)) {
        return MapEntry(key.substring(_packagePrefix.length), value);
      }
      return MapEntry(key, value);
    });
  }
}
