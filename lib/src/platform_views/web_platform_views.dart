import 'dart:ui_web';
import 'package:web/web.dart';

void registerPlatformViews() {
  platformViewRegistry.registerViewFactory(
    'isolated-app-instance',
    (int viewId, {Object? params}) {
      params as Map;
      final variationId = params['variation_id'];
      String src = '/#/single-preview';
      if (variationId != null) {
        src += '/$variationId';
      }
      final iframe = (document.createElement('iframe') as HTMLIFrameElement)
        ..src = src
        ..style.height = '100%'
        ..style.width = '100%';
      return iframe;
    },
  );
}
