import 'package:binary_music_tools/models/brew.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class BrewDbProvider {
  Database _brewDb;

  BrewDbProvider();

  Future<Database> _connectDB() async {
    final database = await openDatabase(
      join(await getDatabasesPath(), 'brews.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE brews(id INTEGER PRIMARY KEY, name TEXT, wort REAL, rest_wort REAL, apparant_ferm REAL, real_ferm REAL, abv REAL)",
        );
      },
      version: 1,
    );

    return database;
  }

  Future<void> createBrew(Brew brew) async {
    if (_brewDb == null) {
      _brewDb = await _connectDB();
    }

    await _brewDb.insert(
      "brews",
      brew.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> deleteBrew(int id) async {
    if (_brewDb == null) {
      _brewDb = await _connectDB();
    }

    return await _brewDb.delete(
      'brews',
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<List<Brew>> getAllBrews() async {
    if (_brewDb == null) {
      _brewDb = await _connectDB();
    }

    var brewsQuery = await _brewDb.query('brews');
    var brews = brewsQuery.map<Brew>((brewMap) => Brew.fromMap(brewMap)).toList();

    return brews;
  }
}
