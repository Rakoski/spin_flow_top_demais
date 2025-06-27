import 'dart:convert';
import 'package:spin_flow/banco/sqlite/conexao.dart';
import 'package:spin_flow/dto/dto_musica.dart';
import 'package:spin_flow/dto/dto_categoria_musica.dart';
import 'package:spin_flow/banco/sqlite/dao/dao_artista_banda.dart';
import 'package:spin_flow/banco/sqlite/dao/dao_categoria_musica.dart';

class DAOMusica {
  static const String _tabela = 'musica';

  Future<int> salvar(DTOMusica musica) async {
    final db = await ConexaoSQLite.database;
    final linksJson = jsonEncode(musica.linksVideoAula.map((l) => {'url': l.url, 'descricao': l.descricao}).toList());
    if (musica.id != null) {
      return await db.update(
        _tabela,
        {
          'nome': musica.nome,
          'descricao': musica.descricao,
          'artista_id': musica.artista.id,
          'categorias': musica.categorias.map((c) => c.id).join(','),
          'links_video_aula': linksJson,
          'ativo': musica.ativo ? 1 : 0,
        },
        where: 'id = ?',
        whereArgs: [musica.id],
      );
    } else {
      return await db.insert(
        _tabela,
        {
          'nome': musica.nome,
          'descricao': musica.descricao,
          'artista_id': musica.artista.id,
          'categorias': musica.categorias.map((c) => c.id).join(','),
          'links_video_aula': linksJson,
          'ativo': musica.ativo ? 1 : 0,
        },
      );
    }
  }

  Future<List<DTOMusica>> buscarTodos() async {
    final db = await ConexaoSQLite.database;
    final List<Map<String, dynamic>> maps = await db.query(_tabela);
    final daoArtista = DAOArtistaBanda();
    final daoCategoria = DAOCategoriaMusica();
    List<DTOMusica> musicas = [];
    for (final map in maps) {
      final artista = await daoArtista.buscarPorId(map['artista_id']);
      final categoriasIds = (map['categorias'] as String?)?.split(',').where((e) => e.isNotEmpty).map((e) => int.parse(e)).toList() ?? [];
      final categorias = <DTOCategoriaMusica>[];
      for (final id in categoriasIds) {
        final cat = await daoCategoria.buscarPorId(id);
        if (cat != null) categorias.add(cat);
      }
      final links = <DTOLinkVideoAula>[];
      if (map['links_video_aula'] != null && (map['links_video_aula'] as String).isNotEmpty) {
        final List<dynamic> linksList = jsonDecode(map['links_video_aula']);
        for (final l in linksList) {
          links.add(DTOLinkVideoAula(url: l['url'], descricao: l['descricao']));
        }
      }
      musicas.add(DTOMusica(
        id: map['id'],
        nome: map['nome'],
        descricao: map['descricao'],
        artista: artista!,
        categorias: categorias,
        linksVideoAula: links,
        ativo: map['ativo'] == 1,
      ));
    }
    return musicas;
  }

  Future<DTOMusica?> buscarPorId(int id) async {
    final db = await ConexaoSQLite.database;
    final List<Map<String, dynamic>> maps = await db.query(
      _tabela,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      final map = maps[0];
      final artista = await DAOArtistaBanda().buscarPorId(map['artista_id']);
      final categoriasIds = (map['categorias'] as String?)?.split(',').where((e) => e.isNotEmpty).map((e) => int.parse(e)).toList() ?? [];
      final categorias = <DTOCategoriaMusica>[];
      for (final id in categoriasIds) {
        final cat = await DAOCategoriaMusica().buscarPorId(id);
        if (cat != null) categorias.add(cat);
      }
      final links = <DTOLinkVideoAula>[];
      if (map['links_video_aula'] != null && (map['links_video_aula'] as String).isNotEmpty) {
        final List<dynamic> linksList = jsonDecode(map['links_video_aula']);
        for (final l in linksList) {
          links.add(DTOLinkVideoAula(url: l['url'], descricao: l['descricao']));
        }
      }
      return DTOMusica(
        id: map['id'],
        nome: map['nome'],
        descricao: map['descricao'],
        artista: artista!,
        categorias: categorias,
        linksVideoAula: links,
        ativo: map['ativo'] == 1,
      );
    }
    return null;
  }

  Future<int> excluir(int id) async {
    final db = await ConexaoSQLite.database;
    return await db.delete(
      _tabela,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
