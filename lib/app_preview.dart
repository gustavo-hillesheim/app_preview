import 'package:flutter/material.dart';

import 'src/pages/pages.dart';
import 'src/preview_scroll_behavior.dart';
import 'src/models/models.dart';
import 'src/widgets/widgets.dart';

export 'src/models/models.dart';
export 'src/package_asset_bundle.dart';
export 'src/pages/pages.dart';
export 'src/preview_scroll_behavior.dart';
export 'src/widgets/app_preview.dart';

void runAppPreview<T>({
  required PreviewBuilder<T> appBuilder,
  List<PreviewVariation<T>>? variations,
  bool? allowMultipleInstances,
  String? packageName,
}) {
  runApp(
    _AppPreviewApp<T>(
      appBuilder: appBuilder,
      variations: variations,
      allowMultipleInstances: allowMultipleInstances,
      packageName: packageName,
    ),
  );
}

class _AppPreviewApp<T> extends StatelessWidget {
  const _AppPreviewApp({
    required this.appBuilder,
    this.variations,
    this.allowMultipleInstances,
    this.packageName,
  });

  final PreviewBuilder<T> appBuilder;
  final List<PreviewVariation<T>>? variations;
  final bool? allowMultipleInstances;
  final String? packageName;

  @override
  Widget build(BuildContext context) {
    final variations = this.variations;
    final hasVariations = variations != null && variations.isNotEmpty;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      scrollBehavior: PreviewScrollBehavior(),
      initialRoute: hasVariations ? 'variation-selection' : 'previews',
      onGenerateRoute: (settings) {
        final route = settings.name;
        if (route == null) return null;

        if (hasVariations) {
          if (route == 'variation-selection') {
            return MaterialPageRoute(
              builder: (context) => PreviewVariationSelectionPage(
                variations: variations,
                onSelectVariation: (variation) => Navigator.pushNamed(
                  context,
                  'previews/${variation.id}',
                ),
              ),
            );
          } else if (route.startsWith('previews')) {
            final selectedVariationId = route.split('/').last;
            final selectedVariation = variations.firstWhere(
              (v) => v.id == selectedVariationId,
              orElse: () => variations.first,
            );
            return MaterialPageRoute(
              builder: (_) => AppPreviewPage<T>(
                appBuilder: appBuilder,
                initialVariation: selectedVariation,
                availableVariations: variations,
                allowMultipleInstances: allowMultipleInstances,
                packageName: packageName,
              ),
            );
          }
        } else {
          return MaterialPageRoute(
            builder: (_) => AppPreviewPage<T>(
              appBuilder: appBuilder,
              allowMultipleInstances: allowMultipleInstances,
              packageName: packageName,
            ),
          );
        }
        return null;
      },
    );
  }
}
