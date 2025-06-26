import 'package:flutter/material.dart';
import 'package:spin_flow/banco/sqlite/dao/dao_video_aula.dart';
import 'package:spin_flow/dto/dto_video_aula.dart';
import 'package:spin_flow/configuracoes/rotas.dart';

class ListaVideoAula extends StatefulWidget {
  const ListaVideoAula({super.key});

  @override
  State<ListaVideoAula> createState() => _ListaVideoAulaState();
}

class _ListaVideoAulaState extends State<ListaVideoAula> {
  final DaoVideoAula _daoVideoAula = DaoVideoAula();
  List<DTOVideoAula> _videoAulas = [];
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _carregarVideoAulas();
  }

  Future<void> _carregarVideoAulas() async {
    setState(() {
      _carregando = true;
    });

    try {
      final videoAulas = await _daoVideoAula.buscarTodos();
      print(videoAulas);
      setState(() {
        _videoAulas = videoAulas;
        _carregando = false;
      });
    } catch (e) {
      setState(() {
        _carregando = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao carregar vídeo-aulas: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vídeo-aulas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _carregarVideoAulas,
            tooltip: 'Recarregar',
          ),
        ],
      ),
      body:
          _carregando
              ? const Center(child: CircularProgressIndicator())
              : _videoAulas.isEmpty
              ? _widgetSemDados(context)
              : RefreshIndicator(
                onRefresh: _carregarVideoAulas,
                child: ListView.builder(
                  itemCount: _videoAulas.length,
                  itemBuilder:
                      (context, index) =>
                          _itemLista(context, _videoAulas[index]),
                ),
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final resultado = await Navigator.pushNamed(
            context,
            Rotas.cadastroVideoAula,
          );
          if (resultado == true) {
            _carregarVideoAulas();
          }
        },
        tooltip: 'Adicionar Vídeo-aula',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _widgetSemDados(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.ondemand_video, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          const Text(
            'Nenhuma vídeo-aula cadastrada',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () async {
              final resultado = await Navigator.pushNamed(
                context,
                Rotas.cadastroVideoAula,
              );
              if (resultado == true) {
                _carregarVideoAulas();
              }
            },
            icon: const Icon(Icons.add),
            label: const Text('Adicionar Vídeo-aula'),
          ),
        ],
      ),
    );
  }

  Widget _itemLista(BuildContext context, DTOVideoAula videoAula) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: Icon(
          videoAula.ativo ? Icons.play_circle_fill : Icons.pause_circle_filled,
          color: videoAula.ativo ? Colors.green : Colors.grey,
        ),
        title: Text(videoAula.nome),
        subtitle: Text(videoAula.linkVideo ?? 'Sem link'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Botão para ativar/desativar
            IconButton(
              icon: Icon(
                videoAula.ativo ? Icons.visibility : Icons.visibility_off,
                color: videoAula.ativo ? Colors.green : Colors.grey,
              ),
              tooltip: videoAula.ativo ? 'Desativar' : 'Ativar',
              onPressed: () => _alterarStatus(videoAula),
            ),
            // Botão para abrir link
            IconButton(
              icon: const Icon(Icons.open_in_new),
              tooltip: 'Abrir link',
              onPressed:
                  videoAula.linkVideo != null && videoAula.linkVideo!.isNotEmpty
                      ? () => _abrirLink(context, videoAula.linkVideo!)
                      : null,
            ),
            // Botão para deletar
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              tooltip: 'Deletar',
              onPressed: () => _confirmarDelecao(videoAula),
            ),
          ],
        ),
        onTap: () async {
          final resultado = await Navigator.pushNamed(
            context,
            Rotas.cadastroVideoAula,
            arguments: videoAula,
          );
          if (resultado == true) {
            _carregarVideoAulas();
          }
        },
      ),
    );
  }

  Future<void> _alterarStatus(DTOVideoAula videoAula) async {
    try {
      final sucesso = await _daoVideoAula.alterarStatus(
        videoAula.id!,
        !videoAula.ativo,
      );

      if (sucesso) {
        _carregarVideoAulas();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                videoAula.ativo
                    ? 'Vídeo-aula desativada'
                    : 'Vídeo-aula ativada',
              ),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erro ao alterar status: $e')));
      }
    }
  }

  Future<void> _confirmarDelecao(DTOVideoAula videoAula) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Confirmar exclusão'),
            content: Text('Deseja realmente excluir "${videoAula.nome}"?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Excluir'),
              ),
            ],
          ),
    );

    if (confirmar == true) {
      try {
        final sucesso = await _daoVideoAula.deletar(videoAula.id!);
        if (sucesso) {
          _carregarVideoAulas();
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Vídeo-aula excluída com sucesso')),
            );
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Erro ao excluir: $e')));
        }
      }
    }
  }

  void _abrirLink(BuildContext context, String url) async {
    // Para abrir links, normalmente se usa url_launcher
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Abrir link: $url')));
  }
}
