# App Preview  

A package to visualize how an application would look on different devices.  

Based on [device_preview](https://pub.dev/packages/device_preview), this package aims to add new features, such as viewing multiple devices simultaneously, while also making usage easier.  

## Usage  

To add the preview to your application, simply replace the `runApp` call with `runAppPreview`:  

```dart
import 'package:app_preview/app_review.dart';

void main() {
    runAppPreview(appBuilder: (_) => MyApp());
}

class MyApp extends StatelessWidget {
    ...
}
```