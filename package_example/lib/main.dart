import 'package:example/main.dart';
import 'package:app_preview/app_preview.dart';

void main() {
  runAppPreview(
    packageName: 'example',
    (_) => const ExampleApp(),
  );
}
