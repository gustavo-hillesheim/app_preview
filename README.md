# App preview

Package para visualizar como um aplicativo ficaria em diferentes dispositivos.

Baseado no [device_preview](https://pub.dev/packages/device_preview), busca adicionar novas funcionalidades, como a visualização em múltiplos dispositivos ao mesmo tempo, e também facilitar o uso.

## Uso

Para adicionar a preview ao seu aplicativo, basta trocar a chamada do `runApp` para `runAppPreview`:

```dart
import 'package:app_preview/app_review.dart';

void main() {
    runAppPreview((context) => MyApp());
}

class MyApp extends StatelessWidget {
    ...
}

```