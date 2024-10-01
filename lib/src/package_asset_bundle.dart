import 'package:flutter/services.dart';

class PackageAssetBundle extends PlatformAssetBundle {
  PackageAssetBundle({
    required this.packageName,
  });

  final String packageName;

  late final String _packagePrefix = 'packages/$packageName/';

  @override
  Future<ByteData> load(String key) async {
    if (key == 'AssetManifest.bin') {
      final bytes = await super.load(key);
      const codec = StandardMessageCodec();
      var data = codec.decodeMessage(bytes);
      if (data is Map) {
        data = _removePackagePrefixFromKeysOf(data);
      }
      return codec.encodeMessage(data)!;
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
