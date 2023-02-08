import 'dart:io';
import 'package:orison/src/models/survey_response.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'dart:convert';

class DBProvider {
  static Database _database;
  static final DBProvider db = DBProvider._();

  DBProvider._();

  Future<Database> get database async {
    // If database exists, return database
    if (_database != null) return _database;

    // If database don't exists, create one
    _database = await initDB();

    return _database;
  }

  // Create the database and the Content table
  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    print(kIsWeb);
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS || kIsWeb) {
      final savedDir = Directory(
          documentsDirectory.path + Platform.pathSeparator + 'AuditSmart');
      bool hasExisted = await savedDir.exists();
      if (!hasExisted) {
        savedDir.create();
      }

      print(savedDir);
      final path = join(savedDir.path, 'orison.db');

      sqfliteFfiInit();
      var databaseFactory = databaseFactoryFfi;

      var db = await databaseFactory.openDatabase(path,
          options: OpenDatabaseOptions(
              version: 1,
              onOpen: (db) {},
              onCreate: (Database db, int version) async {
                await db.execute('CREATE TABLE Survey('
                    'survey_id INTEGER PRIMARY KEY,'
                    'site_id TEXT,'
                    'site_name TEXT,'
                    'audit_type_id INTEGER,'
                    'audit_type_name TEXT,'
                    'start_date TEXT,'
                    'status INTEGER'
                    ')');
                await db.execute('CREATE TABLE Questions('
                    'id INTEGER,'
                    'survey_id INTEGER,'
                    'status INTEGER,'
                    'data TEXT'
                    ')');
              }));
      db.getVersion();
      return db;
    } else {
      documentsDirectory = await getApplicationDocumentsDirectory();

      final path = join(documentsDirectory.path, 'orison.db');

      return await openDatabase(path, version: 1, onOpen: (db) {},
          onCreate: (Database db, int version) async {
        await db.execute('CREATE TABLE Survey('
            'survey_id INTEGER PRIMARY KEY,'
            'site_id TEXT,'
            'site_name TEXT,'
            'audit_type_id INTEGER,'
            'audit_type_name TEXT,'
            'start_date TEXT,'
            'status INTEGER'
            ')');
        await db.execute('CREATE TABLE Questions('
            'id INTEGER,'
            'survey_id INTEGER,'
            'status INTEGER,'
            'data TEXT'
            ')');
      });
    }
  }

  // Insert content on database
  Future<bool> createSurvey(SurveyResponse survey) async {
    final db = await database;
    final Map<String, dynamic> data = survey.toJson();
    data.remove("questions");

    final res = await db.insert('Survey', data);

    await db.transaction((txn) async {
      final batch = txn.batch();
      for (var question in survey.questions) {
        Map<String, dynamic> data = {};
        data['id'] = question.id;
        data['survey_id'] = survey.surveyId;
        data['status'] = 0;
        data['data'] = jsonEncode(question.toJson()).toString();
        batch.insert('Questions', data);
      }

      await batch.commit();
    });

    return res > 0 ? true : false;
  }

  Future<bool> deleteSurvey(int surveyId) async {
    final db = await database;
    final res = await db
        .delete('Survey', where: 'survey_id = ?', whereArgs: [surveyId]);
    final resQ = await db
        .delete('Questions', where: 'survey_id = ?', whereArgs: [surveyId]);

    return res > 0 ? true : false;
  }

  Future<bool> updateSurvey(SurveyResponse surveyResponse) async {
    final db = await database;

    final Map<String, dynamic> data = surveyResponse.toJson();
    data.remove("questions");
    final res = await db.update('Survey', data,
        where: 'survey_id = ?', whereArgs: [surveyResponse.surveyId]);

    return res > 0 ? true : false;
  }

  // Delete all contents
  Future<int> deleteAllSurveys() async {
    final db = await database;
    final res = await db.rawDelete('DELETE FROM Survey');

    return res;
  }

  Future<List<SurveyResponse>> getAllSurveys() async {
    final db = await database;
    final res =
        await db.rawQuery("SELECT * FROM Survey ORDER BY `survey_id` DESC");
    // print(res.toString());

    List<SurveyResponse> list = res.isNotEmpty
        ? res.map((c) {
            Map<String, dynamic> map = Map<String, dynamic>.from(c);
            return SurveyResponse.fromJson(map);
          }).toList()
        : [];

    return list;
  }

  Future<SurveyResponse> getSurveyWithQuestions(int id) async {
    final db = await database;
    final res =
        await db.rawQuery('SELECT * FROM Survey WHERE survey_id=?', [id]);
    if (res.length > 0) {
      var c = res.first;
      Map<String, dynamic> map = Map<String, dynamic>.from(c);
      List<Questions> questions = [];
      final resQ =
          await db.rawQuery('SELECT * FROM Questions WHERE survey_id=?', [id]);
      if (resQ.length > 0) {
        for (var question in resQ) {
          Map<String, dynamic> mapQ = Map<String, dynamic>.from(question);
          questions.add(Questions.fromJson(jsonDecode(mapQ['data'])));
        }
      }

      var survey = SurveyResponse.fromJson(map);
      survey.questions = questions;
      return survey;
    } else {
      return null;
    }
  }

  Future<bool> updateQuestion(int surveyId, Questions question) async {
    final db = await database;

    Map<String, dynamic> data = {};
    data['id'] = question.id;
    data['survey_id'] = surveyId;
    data['status'] = 0;
    data['data'] = jsonEncode(question.toJson()).toString();
    final res = await db.update('Questions', data,
        where: 'survey_id = ? and id = ?', whereArgs: [surveyId, question.id]);

    return res > 0 ? true : false;
  }

  Future<SurveyResponse> getSurveyWithQuestionsForSubmit(int id) async {
    final db = await database;
    final res =
        await db.rawQuery('SELECT * FROM Survey WHERE survey_id=?', [id]);
    if (res.length > 0) {
      var c = res.first;
      Map<String, dynamic> map = Map<String, dynamic>.from(c);
      List<Questions> questions = [];
      final resQ = await db.rawQuery(
          'SELECT * FROM Questions WHERE survey_id=? and status=0', [id]);
      if (resQ.length > 0) {
        for (var question in resQ) {
          Map<String, dynamic> mapQ = Map<String, dynamic>.from(question);
          questions.add(Questions.fromJson(jsonDecode(mapQ['data'])));
        }
      }

      var survey = SurveyResponse.fromJson(map);
      survey.questions = questions;
      return survey;
    } else {
      return null;
    }
  }

  Future<bool> updateQuestionSubmitted(int surveyId, Questions question) async {
    final db = await database;

    Map<String, dynamic> data = {};
    data['id'] = question.id;
    data['survey_id'] = surveyId;
    data['status'] = 1;
    data['data'] = jsonEncode(question.toJson()).toString();
    final res = await db.update('Questions', data,
        where: 'survey_id = ? and id = ?', whereArgs: [surveyId, question.id]);

    return res > 0 ? true : false;
  }
}
