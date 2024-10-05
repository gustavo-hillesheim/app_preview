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
    if (isAssetManifestKey(key)) {
      var bytes = await super.load(key);
      const codec = AssetManifestMessageCodec();
      var assetManifest = codec.decodeMessage(bytes)!;
      assetManifest = removePackagePrefixFromKeysOf(assetManifest);
      return codec.encodeMessage(assetManifest)!;
    }
    return super.load(_ensureHasPackagePrefix(key));
  }

  @protected
  bool isAssetManifestKey(String key) {
    return kIsWeb
        ? key == 'AssetManifest.bin.json'
        : key == 'AssetManifest.bin';
  }

  String _ensureHasPackagePrefix(String key) {
    if (!key.startsWith('packages/')) {
      return '$_packagePrefix$key';
    }
    return key;
  }

  @protected
  Map removePackagePrefixFromKeysOf(Map data) {
    return data.map((key, value) {
      if (key is String && key.startsWith(_packagePrefix)) {
        return MapEntry(key.substring(_packagePrefix.length), value);
      }
      return MapEntry(key, value);
    });
  }
}

class AssetManifestMessageCodec implements MessageCodec<Map> {
  const AssetManifestMessageCodec()
      : _internalCodec = kIsWeb
            ? const _WebAssetManifestMessageCodec()
            : const StandardMessageCodec();

  final MessageCodec<Object?> _internalCodec;

  @override
  Map? decodeMessage(ByteData? message) {
    return _internalCodec.decodeMessage(message) as Map?;
  }

  @override
  ByteData? encodeMessage(Map? message) {
    return _internalCodec.encodeMessage(message);
  }
}

class _WebAssetManifestMessageCodec implements MessageCodec<Object?> {
  const _WebAssetManifestMessageCodec();

  @override
  Object? decodeMessage(ByteData? message) {
    if (message == null) {
      return null;
    }
    final jsonData = utf8.decode(Uint8List.sublistView(message));
    message = ByteData.sublistView(
      base64.decode(json.decode(jsonData) as String),
    );
    return const StandardMessageCodec().decodeMessage(message);
  }

  @override
  ByteData? encodeMessage(Object? message) {
    if (message == null) {
      return null;
    }
    var result = const StandardMessageCodec().encodeMessage(message)!;
    final jsonData = json.encode(
      base64.encode(Uint8List.sublistView(result)),
    );
    result = ByteData.sublistView(utf8.encode(jsonData));
    return result;
  }
}
