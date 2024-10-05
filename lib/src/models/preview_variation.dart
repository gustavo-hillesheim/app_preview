class PreviewVariation<T> {
  const PreviewVariation({
    required this.id,
    required this.name,
    this.data,
  });

  final String id;
  final String name;
  final T? data;
}
