class CategoryModel {
  final String id;
  final String name;
  final String companyName;

  CategoryModel({
    required this.id,
    required this.name,
    required this.companyName,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      companyName: json['companyName'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'companyName': companyName,
    };
  }
}
