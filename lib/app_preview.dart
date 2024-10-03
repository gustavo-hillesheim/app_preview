import 'package:flutter/material.dart';

import 'src/app_preview_page.dart';
import 'src/preview_scroll_behavior.dart';

export 'src/app_preview_page.dart';
export 'src/package_asset_bundle.dart';
export 'src/preview_scroll_behavior.dart';
export 'src/widgets/app_preview.dart';

void runAppPreview(
  WidgetBuilder appBuilder, {
  bool allowMultipleInstances = false,
  String? packageName,
}) {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      scrollBehavior: PreviewScrollBehavior(),
      home: AppPreviewPage(
        appBuilder: appBuilder,
        allowMultipleInstances: allowMultipleInstances,
        packageName: packageName,
      ),
    ),
  );
}
