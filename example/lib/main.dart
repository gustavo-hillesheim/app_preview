import 'package:app_preview/app_preview.dart';
import 'package:flutter/material.dart';

void main() {
  runAppPreview(
    allowMultipleInstances: true,
    isolateAppInstances: true,
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

const appVariations = <PreviewVariation<Color>>[
  PreviewVariation(
    id: 'red_theme_variation',
    name: 'Tema Vermelho',
    data: Colors.red,
  ),
  PreviewVariation(
    id: 'blue_theme_variation',
    name: 'Tema Azul',
    data: Colors.blue,
  ),
];

class ExampleApp extends StatelessWidget {
  const ExampleApp({
    super.key,
    required this.title,
    required this.seedColor,
  });

  final String title;
  final Color seedColor;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: previewAppBuilder,
      scrollBehavior: PreviewScrollBehavior(),
      title: 'Flutter Demo',
      theme: ThemeData.from(
        colorScheme: ColorScheme.fromSeed(
          seedColor: seedColor,
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData.from(
        colorScheme: ColorScheme.fromSeed(
          seedColor: seedColor,
          brightness: Brightness.dark,
        ),
      ),
      home: MyHomePage(title: title),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 10;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            alignment: Alignment.center,
            child: Image.asset(
              'assets/flutter_logo.png',
              height: 128,
              width: 128,
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: _counter,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (_, i) => ListTile(
                title: Text('Item $i'),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
