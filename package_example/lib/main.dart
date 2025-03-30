import 'package:example/main.dart';
import 'package:app_preview/app_preview.dart';

void main() {
  runAppPreview(
    packageName: 'example',
    allowMultipleInstances: true,
    variations: appVariations,
    appBuilder: (variation) {
      variation ??= appVariations.first;
      return ExampleApp(
        title: variation.name,
        seedColor: variation.data!,
      );
    },
  );
}
