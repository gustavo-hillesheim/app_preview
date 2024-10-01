import 'dart:ui';

import 'package:flutter/material.dart';

import 'src/app_preview_page.dart';

export 'src/app_preview_page.dart';
export 'src/package_asset_bundle.dart';

void runAppPreview(
  WidgetBuilder appBuilder, {
  bool allowMultipleInstances = true,
  String? packageName,
}) {
  runApp(
    MaterialApp(
      scrollBehavior: _AppScrollBehavior(),
      home: AppPreviewPage(
        appBuilder: appBuilder,
        allowMultipleInstances: allowMultipleInstances,
        packageName: packageName,
      ),
    ),
  );
}

class _AppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.mouse,
        PointerDeviceKind.touch,
      };
}
