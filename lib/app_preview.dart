import 'package:flutter/material.dart';

import 'src/pages/pages.dart';
import 'src/platform_views/platform_views.dart';
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
  bool? isolateAppInstances,
  String? packageName,
}) {
  registerPlatformViews();

  runApp(
    _AppPreviewApp<T>(
      appBuilder: appBuilder,
      variations: variations,
      allowMultipleInstances: allowMultipleInstances,
      isolateAppInstances: isolateAppInstances,
      packageName: packageName,
    ),
  );
}

class _AppPreviewApp<T> extends StatelessWidget {
  const _AppPreviewApp({
    required this.appBuilder,
    this.variations,
    this.allowMultipleInstances,
    this.isolateAppInstances,
    this.packageName,
  });

  final PreviewBuilder<T> appBuilder;
  final List<PreviewVariation<T>>? variations;
  final bool? allowMultipleInstances;
  final bool? isolateAppInstances;
  final String? packageName;

  @override
  Widget build(BuildContext context) {
    final variations = this.variations;
    final hasVariations = variations != null && variations.isNotEmpty;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      scrollBehavior: PreviewScrollBehavior(),
      initialRoute: hasVariations ? 'variation-selection' : '/previews',
      onGenerateRoute: (settings) {
        final route = settings.name;
        if (route == null) return null;
        final uri = Uri.parse(route);
        final firstPath = uri.pathSegments.firstOrNull;

        if (hasVariations) {
          if (firstPath == 'variation-selection') {
            return MaterialPageRoute(
              builder: (context) => PreviewVariationSelectionPage(
                variations: variations,
                onSelectVariation: (variation) => Navigator.pushNamed(
                  context,
                  'previews/${variation.id}',
                ),
              ),
            );
          } else if (firstPath == 'previews') {
            final selectedVariationId = uri.pathSegments.elementAtOrNull(1);
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
                isolateAppInstances: isolateAppInstances,
                packageName: packageName,
              ),
            );
          } else if (firstPath == 'single-preview') {
            final selectedVariationId = uri.pathSegments.elementAtOrNull(1);
            final selectedVariation = variations.firstWhere(
              (v) => v.id == selectedVariationId,
              orElse: () => variations.first,
            );
            return MaterialPageRoute(
              builder: (_) => SingleAppPreviewPage<T>(
                appBuilder: appBuilder,
                variation: selectedVariation,
                packageName: packageName,
              ),
            );
          }
        } else {
          return MaterialPageRoute(
            builder: (_) => AppPreviewPage<T>(
              appBuilder: appBuilder,
              allowMultipleInstances: allowMultipleInstances,
              isolateAppInstances: isolateAppInstances,
              packageName: packageName,
            ),
          );
        }
        return null;
      },
    );
  }
}
