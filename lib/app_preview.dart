import 'package:flutter/material.dart';

import 'src/app_preview_page.dart';
import 'src/preview_scroll_behavior.dart';

export 'src/app_preview_page.dart';
export 'src/package_asset_bundle.dart';
export 'src/preview_scroll_behavior.dart';
export 'src/widgets/app_preview.dart';

void runAppPreview({
  required WidgetBuilder appBuilder,
  bool? allowMultipleInstances,
  String? packageName,
}) {
  runApp(
    _AppPreviewApp(
      appBuilder: appBuilder,
      allowMultipleInstances: allowMultipleInstances,
      packageName: packageName,
    ),
  );
}

class _AppPreviewApp extends StatelessWidget {
  const _AppPreviewApp({
    required this.appBuilder,
    this.allowMultipleInstances,
    this.packageName,
  });

  final WidgetBuilder appBuilder;
  final bool? allowMultipleInstances;
  final String? packageName;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      scrollBehavior: PreviewScrollBehavior(),
      home: AppPreviewPage(
        appBuilder: appBuilder,
        allowMultipleInstances: allowMultipleInstances,
        packageName: packageName,
      ),
    );
  }
}
