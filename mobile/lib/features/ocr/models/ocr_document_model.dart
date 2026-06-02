class OcrDocument {
  final String id;
  final Map<String, dynamic> data;
  final DateTime createdAt;

  OcrDocument({
    required this.id,
    required this.data,
    required this.createdAt,
  });

  factory OcrDocument.fromJson(Map<String, dynamic> json) {
    return OcrDocument(
      id: json['_id'] as String,
      data: json['data'] as Map<String, dynamic>? ?? {},
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}
