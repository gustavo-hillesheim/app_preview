import 'package:example/main.dart';
import 'package:app_preview/app_preview.dart';

void main() {
  runAppPreview(
    packageName: 'example',
    allowMultipleInstances: true,
    appBuilder: (_) => const ExampleApp(),
  );
}
