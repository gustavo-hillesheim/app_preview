import 'dart:ui';

import 'package:flutter/material.dart';

import 'src/app_preview_page.dart';

void runAppPreview(
  WidgetBuilder appBuilder, {
  bool allowMultipleInstances = true,
}) {
  runApp(
    MaterialApp(
      scrollBehavior: _AppScrollBehavior(),
      home: AppPreviewPage(
        appBuilder: appBuilder,
        allowMultipleInstances: allowMultipleInstances,
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
