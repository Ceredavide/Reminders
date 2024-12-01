import '../db_config.dart';
import '../models/category.dart';

class CategoryDAO {
  static Future<int> addCategory(String name) async {
    final db = await DBConfig.instance.database;
    return await db.insert('categories', {'name': name});
  }

  static Future<List<Category>> getCategories() async {
    final db = await DBConfig.instance.database;
    final result = await db.query('categories', orderBy: 'name ASC');
    return result.map((json) => Category.fromMap(json)).toList();
  }

  static Future<String?> getCategoryById(int id) async {
    final db = await DBConfig.instance.database;
    final result =
        await db.query('categories', where: 'id = ?', whereArgs: [id]);
    return result.isNotEmpty ? result.first['name'] as String : null;
  }
}
