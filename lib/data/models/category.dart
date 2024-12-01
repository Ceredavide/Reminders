class Category {
  int? id;
  String name;

  Category({this.id, required this.name});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  static Category fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'],
      name: map['name'],
    );
  }

  @override
  String toString() {
    return 'Category{id: $id, name: $name}';
  }
}