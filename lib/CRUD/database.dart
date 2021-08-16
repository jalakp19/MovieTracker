import 'package:sqflite/sqflite.dart';

final String tableMovieList = 'movielist';
final String columnName = 'movieName';
final String columnDirector = 'movieDirector';
final String columnYear = 'movieYear';
final String columnImdb = 'movieImdb';
final String columnImg = 'movieImg';
final String columnWatched = 'movieWatched';
final String columnId = 'movieId';
final String columnEmail = 'movieEmail';

class ML {
  String name;
  String director;
  String year;
  String imdb;
  String img;
  String watched;
  String id;
  String email;

  Map<String, Object> toMap() {
    var map = <String, Object>{
      columnName: name,
      columnDirector: director,
      columnYear: year,
      columnImdb: imdb,
      columnImg: img,
      columnWatched: watched,
      columnId: id,
      columnEmail: email,
    };
    return map;
  }

  ML();

  ML.fromMap(Map<String, Object> map) {
    name = map[columnName];
    director = map[columnDirector];
    year = map[columnYear];
    imdb = map[columnImdb];
    img = map[columnImg];
    watched = map[columnWatched];
    id = map[columnId];
    email = map[columnEmail];
  }
}

class MLProvider {
  Database db;

  Future open(String path) async {
    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''
create table $tableMovieList ( 
  $columnName text not null,
  $columnDirector text not null,
  $columnYear text not null,
  $columnImdb text not null,
  $columnImg text not null,
  $columnWatched text not null,
  $columnId text not null,
  $columnEmail text not null)
''');
    });
  }

  Future<ML> insert(ML ml) async {
    await db.insert(tableMovieList, ml.toMap());
    return ml;
  }

  Future<List<ML>> getML() async {
    List<Map> maps = await db.query(tableMovieList);
    List<ML> ans = [];
    for (int i = 0; i < maps.length; i++) {
      ans.add(ML.fromMap(maps[i]));
    }
    return ans;
  }

  Future<int> delete(String id) async {
    return await db
        .delete(tableMovieList, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> update(ML ml) async {
    return await db.update(tableMovieList, ml.toMap(),
        where: '$columnId = ?', whereArgs: [ml.id]);
  }

  Future close() async => db.close();
}
