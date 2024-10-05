import 'package:flutter/material.dart';

import '../models/models.dart';

class PreviewVariationSelectionPage<T> extends StatelessWidget {
  const PreviewVariationSelectionPage({
    super.key,
    required this.variations,
    required this.onSelectVariation,
  });

  final List<PreviewVariation<T>> variations;
  final ValueChanged<PreviewVariation<T>> onSelectVariation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Column(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  alignment: Alignment.center,
                  child: Text(
                    'Selecione a variação da preview',
                    style: Theme.of(context).textTheme.headlineMedium,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: variations.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (_, i) {
                    final variation = variations[i];
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: ListTile(
                        onTap: () => onSelectVariation(variation),
                        title: Text(variation.name),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
