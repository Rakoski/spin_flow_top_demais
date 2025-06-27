import 'package:spin_flow/banco/sqlite/conexao.dart';
import 'package:spin_flow/dto/dto_estado.dart';
import 'package:sqflite/sqflite.dart';

class DaoEstado {
  static const String _nomeTabela = 'estado';

  Future<DTOEstado> salvar(DTOEstado estado) async {
    final Database db = await ConexaoSQLite.database;

    if (estado.id == null) {
      final int id = await db.insert(_nomeTabela, _toMap(estado));
      return DTOEstado(
        id: id,
        nome: estado.nome,
        sigla: estado.sigla,
        regiao: estado.regiao,
        ativo: estado.ativo,
      );
    } else {
      await db.update(
        _nomeTabela,
        _toMap(estado),
        where: 'id = ?',
        whereArgs: [estado.id],
      );
      return estado;
    }
  }

  Future<List<DTOEstado>> buscarTodos() async {
    final Database db = await ConexaoSQLite.database;
    final List<Map<String, dynamic>> maps = await db.query(
      _nomeTabela,
      orderBy: 'nome ASC',
    );
    return maps.map((map) => _fromMap(map)).toList();
  }

  Future<List<DTOEstado>> buscarAtivos() async {
    final Database db = await ConexaoSQLite.database;
    final List<Map<String, dynamic>> maps = await db.query(
      _nomeTabela,
      where: 'ativo = ?',
      whereArgs: [1],
      orderBy: 'nome ASC',
    );
    return maps.map((map) => _fromMap(map)).toList();
  }

  Future<DTOEstado?> buscarPorId(int id) async {
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

  Future<List<DTOEstado>> buscarPorNome(String nome) async {
    final Database db = await ConexaoSQLite.database;
    final List<Map<String, dynamic>> maps = await db.query(
      _nomeTabela,
      where: 'nome LIKE ?',
      whereArgs: ['%$nome%'],
      orderBy: 'nome ASC',
    );
    return maps.map((map) => _fromMap(map)).toList();
  }

  Future<List<DTOEstado>> buscarPorRegiao(String regiao) async {
    final Database db = await ConexaoSQLite.database;
    final List<Map<String, dynamic>> maps = await db.query(
      _nomeTabela,
      where: 'regiao = ? AND ativo = ?',
      whereArgs: [regiao, 1],
      orderBy: 'nome ASC',
    );
    return maps.map((map) => _fromMap(map)).toList();
  }

  Future<DTOEstado?> buscarPorSigla(String sigla) async {
    final Database db = await ConexaoSQLite.database;
    final List<Map<String, dynamic>> maps = await db.query(
      _nomeTabela,
      where: 'sigla = ?',
      whereArgs: [sigla.toUpperCase()],
    );

    if (maps.isNotEmpty) {
      return _fromMap(maps.first);
    }
    return null;
  }

  Future<bool> deletar(int id) async {
    final Database db = await ConexaoSQLite.database;

    // Verificar se há cidades associadas
    final int cidadesAssociadas = await _contarCidadesAssociadas(id);
    if (cidadesAssociadas > 0) {
      throw Exception(
        'Não é possível deletar um estado que possui cidades associadas',
      );
    }

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

  Future<int> _contarCidadesAssociadas(int idEstado) async {
    final Database db = await ConexaoSQLite.database;
    final List<Map<String, dynamic>> result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM cidade WHERE id_estado = ?',
      [idEstado],
    );
    return result.first['count'] as int;
  }

  Future<List<String>> listarRegioes() async {
    final Database db = await ConexaoSQLite.database;
    final List<Map<String, dynamic>> result = await db.rawQuery(
      'SELECT DISTINCT regiao FROM $_nomeTabela WHERE ativo = 1 ORDER BY regiao',
    );
    return result.map((row) => row['regiao'] as String).toList();
  }

  Map<String, dynamic> _toMap(DTOEstado estado) {
    return {
      'id': estado.id,
      'nome': estado.nome,
      'sigla': estado.sigla.toUpperCase(),
      'regiao': estado.regiao,
      'ativo': estado.ativo ? 1 : 0,
    };
  }

  DTOEstado _fromMap(Map<String, dynamic> map) {
    return DTOEstado(
      id: map['id'] as int?,
      nome: map['nome'] as String,
      sigla: map['sigla'] as String,
      regiao: map['regiao'] as String,
      ativo: (map['ativo'] as int) == 1,
    );
  }
}
