import 'package:app_preview/app_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class IsolatedAppInstance<T> extends StatelessWidget {
  const IsolatedAppInstance({
    super.key,
    this.variation,
  });

  final PreviewVariation<T>? variation;

  static bool get supportsCurrentPlatform {
    return kIsWeb;
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return HtmlElementView(
        viewType: 'isolated-app-instance',
        creationParams: {
          'variation_id': variation?.id,
        },
      );
    }
    return const SizedBox.shrink();
  }
}
