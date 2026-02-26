import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../services/encryption_service.dart';

class SqliteDatabaseService {
  static Database? _database;
  final EncryptionService _encryptionService;

  SqliteDatabaseService(this._encryptionService);

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'chat_local.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE messages (
        id TEXT PRIMARY KEY,
        channelId TEXT,
        senderId TEXT,
        recipientId TEXT,
        content TEXT,
        type TEXT,
        timestamp TEXT
      )
    ''');
  }

  Future<void> insertMessage(Map<String, dynamic> message) async {
    final db = await database;
    // Ciframos el contenido antes de guardar
    final encryptedContent = _encryptionService.encryptData(message['content']);
    final msgToSave = Map<String, dynamic>.from(message);
    msgToSave['content'] = encryptedContent;

    await db.insert(
      'messages',
      msgToSave,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getMessages() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('messages', orderBy: 'timestamp DESC');
    
    return List.generate(maps.length, (i) {
      final msg = Map<String, dynamic>.from(maps[i]);
      msg['content'] = _encryptionService.decryptData(msg['content']);
      return msg;
    });
  }
}
