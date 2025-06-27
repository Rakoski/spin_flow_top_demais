import 'package:spin_flow/banco/sqlite/conexao.dart';
import 'package:spin_flow/dto/dto_video_aula.dart';
import 'package:sqflite/sqflite.dart';

class DaoVideoAula {
  // CORRIGIDO: Removido os asteriscos
  static const String _nomeTabela = 'video_aula';

  Future<DTOVideoAula> salvar(DTOVideoAula videoAula) async {
    final Database db = await ConexaoSQLite.database;

    if (videoAula.id == null) {
      final int id = await db.insert(_nomeTabela, _toMap(videoAula));
      return DTOVideoAula(
        id: id,
        nome: videoAula.nome,
        linkVideo: videoAula.linkVideo,
        ativo: videoAula.ativo,
      );
    } else {
      await db.update(
        _nomeTabela,
        _toMap(videoAula),
        where: 'id = ?',
        whereArgs: [videoAula.id],
      );
      print(videoAula);
      return videoAula;
    }
  }

  Future<List<DTOVideoAula>> buscarTodos() async {
    final Database db = await ConexaoSQLite.database;
    final List<Map<String, dynamic>> maps = await db.query(_nomeTabela);
    return maps.map((map) => _fromMap(map)).toList();
  }

  Future<List<DTOVideoAula>> buscarAtivos() async {
    final Database db = await ConexaoSQLite.database;
    final List<Map<String, dynamic>> maps = await db.query(
      _nomeTabela,
      where: 'ativo = ?',
      whereArgs: [1],
    );
    return maps.map((map) => _fromMap(map)).toList();
  }

  Future<DTOVideoAula?> buscarPorId(int id) async {
    final Database db = await ConexaoSQLite.database;
    final List<Map<String, dynamic>> maps = await db.query(
      _nomeTabela,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return _fromMap(maps.first);
    }
    return null;
  }

  Future<List<DTOVideoAula>> buscarPorNome(String nome) async {
    final Database db = await ConexaoSQLite.database;
    final List<Map<String, dynamic>> maps = await db.query(
      _nomeTabela,
      where: 'nome LIKE ?',
      whereArgs: ['%$nome%'],
    );
    return maps.map((map) => _fromMap(map)).toList();
  }

  Future<bool> deletar(int id) async {
    final Database db = await ConexaoSQLite.database;
    final int count = await db.delete(
      _nomeTabela,
      where: 'id = ?',
      whereArgs: [id],
    );
    return count > 0;
  }

  Future<bool> alterarStatus(int id, bool ativo) async {
    final Database db = await ConexaoSQLite.database;
    final int count = await db.update(
      _nomeTabela,
      {'ativo': ativo ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
    return count > 0;
  }

  Future<int> contarTodos() async {
    final Database db = await ConexaoSQLite.database;
    final List<Map<String, dynamic>> result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM $_nomeTabela',
    );
    return result.first['count'] as int;
  }

  Future<int> contarAtivos() async {
    final Database db = await ConexaoSQLite.database;
    final List<Map<String, dynamic>> result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM $_nomeTabela WHERE ativo = 1',
    );
    return result.first['count'] as int;
  }

  Map<String, dynamic> _toMap(DTOVideoAula videoAula) {
    return {
      'id': videoAula.id,
      'nome': videoAula.nome,
      'link_video': videoAula.linkVideo,
      'ativo': videoAula.ativo ? 1 : 0,
    };
  }

  DTOVideoAula _fromMap(Map<String, dynamic> map) {
    return DTOVideoAula(
      id: map['id'] as int?,
      nome: map['nome'] as String,
      linkVideo: map['link_video'] as String?,
      ativo: (map['ativo'] as int) == 1,
    );
  }
}
