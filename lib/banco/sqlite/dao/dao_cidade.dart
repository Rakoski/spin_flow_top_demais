import 'package:spin_flow/banco/sqlite/conexao.dart';
import 'package:spin_flow/dto/dto_cidade.dart';
import 'package:spin_flow/dto/dto_estado.dart';
import 'package:sqflite/sqflite.dart';

class DaoCidade {
  static const String _nomeTabela = 'cidade';

  Future<DTOCidade> salvar(DTOCidade cidade) async {
    final Database db = await ConexaoSQLite.database;

    // Verificar se o estado existe e está ativo
    await _validarEstado(cidade.idEstado);

    if (cidade.id == null) {
      final int id = await db.insert(_nomeTabela, _toMap(cidade));
      return DTOCidade(
        id: id,
        nome: cidade.nome,
        codigoIbge: cidade.codigoIbge,
        populacao: cidade.populacao,
        areaKm2: cidade.areaKm2,
        idEstado: cidade.idEstado,
        ativa: cidade.ativa,
      );
    } else {
      await db.update(
        _nomeTabela,
        _toMap(cidade),
        where: 'id = ?',
        whereArgs: [cidade.id],
      );
      return cidade;
    }
  }

  Future<List<DTOCidade>> buscarTodos() async {
    final Database db = await ConexaoSQLite.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT c.*, e.nome as estado_nome, e.sigla as estado_sigla, e.regiao as estado_regiao, e.ativo as estado_ativo
      FROM $_nomeTabela c
      INNER JOIN estado e ON c.id_estado = e.id
      ORDER BY c.nome ASC
    ''');
    return maps.map((map) => _fromMapWithEstado(map)).toList();
  }

  Future<List<DTOCidade>> buscarAtivas() async {
    final Database db = await ConexaoSQLite.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT c.*, e.nome as estado_nome, e.sigla as estado_sigla, e.regiao as estado_regiao, e.ativo as estado_ativo
      FROM $_nomeTabela c
      INNER JOIN estado e ON c.id_estado = e.id
      WHERE c.ativa = 1
      ORDER BY c.nome ASC
    ''');
    return maps.map((map) => _fromMapWithEstado(map)).toList();
  }

  Future<DTOCidade?> buscarPorId(int id) async {
    final Database db = await ConexaoSQLite.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
      '''
      SELECT c.*, e.nome as estado_nome, e.sigla as estado_sigla, e.regiao as estado_regiao, e.ativo as estado_ativo
      FROM $_nomeTabela c
      INNER JOIN estado e ON c.id_estado = e.id
      WHERE c.id = ?
    ''',
      [id],
    );

    if (maps.isNotEmpty) {
      return _fromMapWithEstado(maps.first);
    }
    return null;
  }

  Future<List<DTOCidade>> buscarPorNome(String nome) async {
    final Database db = await ConexaoSQLite.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
      '''
      SELECT c.*, e.nome as estado_nome, e.sigla as estado_sigla, e.regiao as estado_regiao, e.ativo as estado_ativo
      FROM $_nomeTabela c
      INNER JOIN estado e ON c.id_estado = e.id
      WHERE c.nome LIKE ?
      ORDER BY c.nome ASC
    ''',
      ['%$nome%'],
    );
    return maps.map((map) => _fromMapWithEstado(map)).toList();
  }

  Future<List<DTOCidade>> buscarPorEstado(int idEstado) async {
    final Database db = await ConexaoSQLite.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
      '''
      SELECT c.*, e.nome as estado_nome, e.sigla as estado_sigla, e.regiao as estado_regiao, e.ativo as estado_ativo
      FROM $_nomeTabela c
      INNER JOIN estado e ON c.id_estado = e.id
      WHERE c.id_estado = ? AND c.ativa = 1
      ORDER BY c.nome ASC
    ''',
      [idEstado],
    );
    return maps.map((map) => _fromMapWithEstado(map)).toList();
  }

  Future<List<DTOCidade>> buscarPorRegiao(String regiao) async {
    final Database db = await ConexaoSQLite.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
      '''
      SELECT c.*, e.nome as estado_nome, e.sigla as estado_sigla, e.regiao as estado_regiao, e.ativo as estado_ativo
      FROM $_nomeTabela c
      INNER JOIN estado e ON c.id_estado = e.id
      WHERE e.regiao = ? AND c.ativa = 1 AND e.ativo = 1
      ORDER BY e.nome ASC, c.nome ASC
    ''',
      [regiao],
    );
    return maps.map((map) => _fromMapWithEstado(map)).toList();
  }

  Future<DTOCidade?> buscarPorCodigoIbge(String codigoIbge) async {
    final Database db = await ConexaoSQLite.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
      '''
      SELECT c.*, e.nome as estado_nome, e.sigla as estado_sigla, e.regiao as estado_regiao, e.ativo as estado_ativo
      FROM $_nomeTabela c
      INNER JOIN estado e ON c.id_estado = e.id
      WHERE c.codigo_ibge = ?
    ''',
      [codigoIbge],
    );

    if (maps.isNotEmpty) {
      return _fromMapWithEstado(maps.first);
    }
    return null;
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

  Future<bool> alterarStatus(int id, bool ativa) async {
    final Database db = await ConexaoSQLite.database;
    final int count = await db.update(
      _nomeTabela,
      {'ativa': ativa ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
    return count > 0;
  }

  Future<int> contarTodas() async {
    final Database db = await ConexaoSQLite.database;
    final List<Map<String, dynamic>> result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM $_nomeTabela',
    );
    return result.first['count'] as int;
  }

  Future<int> contarAtivas() async {
    final Database db = await ConexaoSQLite.database;
    final List<Map<String, dynamic>> result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM $_nomeTabela WHERE ativa = 1',
    );
    return result.first['count'] as int;
  }

  Future<int> contarPorEstado(int idEstado) async {
    final Database db = await ConexaoSQLite.database;
    final List<Map<String, dynamic>> result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM $_nomeTabela WHERE id_estado = ? AND ativa = 1',
      [idEstado],
    );
    return result.first['count'] as int;
  }

  Future<List<DTOCidade>> buscarMaioresPopulacao(int limite) async {
    final Database db = await ConexaoSQLite.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
      '''
      SELECT c.*, e.nome as estado_nome, e.sigla as estado_sigla, e.regiao as estado_regiao, e.ativo as estado_ativo
      FROM $_nomeTabela c
      INNER JOIN estado e ON c.id_estado = e.id
      WHERE c.populacao IS NOT NULL AND c.ativa = 1 AND e.ativo = 1
      ORDER BY c.populacao DESC
      LIMIT ?
    ''',
      [limite],
    );
    return maps.map((map) => _fromMapWithEstado(map)).toList();
  }

  Future<void> _validarEstado(int idEstado) async {
    final Database db = await ConexaoSQLite.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'estado',
      where: 'id = ? AND ativo = ?',
      whereArgs: [idEstado, 1],
    );

    if (maps.isEmpty) {
      throw Exception('Estado com ID $idEstado não encontrado ou inativo');
    }
  }

  Map<String, dynamic> _toMap(DTOCidade cidade) {
    return {
      'id': cidade.id,
      'nome': cidade.nome,
      'codigo_ibge': cidade.codigoIbge,
      'populacao': cidade.populacao,
      'area_km2': cidade.areaKm2,
      'id_estado': cidade.idEstado,
      'ativa': cidade.ativa ? 1 : 0,
    };
  }

  DTOCidade _fromMap(Map<String, dynamic> map) {
    return DTOCidade(
      id: map['id'] as int?,
      nome: map['nome'] as String,
      codigoIbge: map['codigo_ibge'] as String?,
      populacao: map['populacao'] as int?,
      areaKm2: map['area_km2'] as double?,
      idEstado: map['id_estado'] as int,
      ativa: (map['ativa'] as int) == 1,
    );
  }

  DTOCidade _fromMapWithEstado(Map<String, dynamic> map) {
    final estado = DTOEstado(
      id: map['id_estado'] as int,
      nome: map['estado_nome'] as String,
      sigla: map['estado_sigla'] as String,
      regiao: map['estado_regiao'] as String,
      ativo: (map['estado_ativo'] as int) == 1,
    );

    return DTOCidade(
      id: map['id'] as int?,
      nome: map['nome'] as String,
      codigoIbge: map['codigo_ibge'] as String?,
      populacao: map['populacao'] as int?,
      areaKm2: map['area_km2'] as double?,
      idEstado: map['id_estado'] as int,
      ativa: (map['ativa'] as int) == 1,
      estado: estado,
    );
  }
}
