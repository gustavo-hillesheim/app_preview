import 'package:app_preview/app_preview.dart';
import 'package:flutter/material.dart';

class SingleAppPreviewPage<T> extends StatelessWidget {
  const SingleAppPreviewPage({
    super.key,
    required this.appBuilder,
    this.variation,
    this.packageName,
  });

  final PreviewBuilder<T> appBuilder;
  final PreviewVariation<T>? variation;
  final String? packageName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppPreview(
        appBuilder: appBuilder,
        variation: variation,
        packageName: packageName,
        hasFrameAndOptions: false,
      ),
    );
  }
}
