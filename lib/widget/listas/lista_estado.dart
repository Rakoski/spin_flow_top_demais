import 'package:flutter/material.dart';
import 'package:spin_flow/banco/sqlite/dao/dao_cidade.dart';
import 'package:spin_flow/banco/sqlite/dao/dao_estado.dart';
import 'package:spin_flow/dto/dto_estado.dart';
import 'package:spin_flow/widget/form_estado.dart';

class ListaEstados extends StatefulWidget {
  const ListaEstados({Key? key}) : super(key: key);

  @override
  State<ListaEstados> createState() => _ListaEstadosState();
}

class _ListaEstadosState extends State<ListaEstados> {
  final DaoEstado _daoEstado = DaoEstado();
  final DaoCidade _daoCidade = DaoCidade();
  List<DTOEstado> _estados = [];
  List<DTOEstado> _estadosFiltrados = [];
  Map<int, int> _contadorCidades = {};
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();
  String? _regiaoFiltro;
  List<String> _regioes = [];

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _carregarDados() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final estados = await _daoEstado.buscarTodos();
      final regioes = await _daoEstado.listarRegioes();

      // Carregar contador de cidades para cada estado
      final Map<int, int> contador = {};
      for (final estado in estados) {
        if (estado.id != null) {
          contador[estado.id!] = await _daoCidade.contarPorEstado(estado.id!);
        }
      }

      setState(() {
        _estados = estados;
        _estadosFiltrados = estados;
        _regioes = regioes;
        _contadorCidades = contador;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao carregar dados: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _filtrarEstados() {
    setState(() {
      _estadosFiltrados =
          _estados.where((estado) {
            final nomeMatch =
                _searchController.text.isEmpty ||
                estado.nome.toLowerCase().contains(
                  _searchController.text.toLowerCase(),
                ) ||
                estado.sigla.toLowerCase().contains(
                  _searchController.text.toLowerCase(),
                );

            final regiaoMatch =
                _regiaoFiltro == null || estado.regiao == _regiaoFiltro;

            return nomeMatch && regiaoMatch;
          }).toList();
    });
  }

  Future<void> _navegarParaFormulario([DTOEstado? estado]) async {
    final resultado = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FormEstadoPage(estado: estado)),
    );

    if (resultado == true) {
      _carregarDados();
    }
  }

  Future<void> _alterarStatus(DTOEstado estado) async {
    try {
      final sucesso = await _daoEstado.alterarStatus(estado.id!, !estado.ativo);
      if (sucesso) {
        _carregarDados();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              estado.ativo
                  ? 'Estado ${estado.nome} desativado com sucesso!'
                  : 'Estado ${estado.nome} ativado com sucesso!',
            ),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao alterar status: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _deletarEstado(DTOEstado estado) async {
    final cidadesAssociadas = _contadorCidades[estado.id] ?? 0;

    if (cidadesAssociadas > 0) {
      showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              title: const Text('Exclusão Não Permitida'),
              content: Text(
                'Não é possível deletar o estado "${estado.nome}" pois existem $cidadesAssociadas cidade(s) associada(s) a ele.',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Entendi'),
                ),
              ],
            ),
      );
      return;
    }

    final confirmacao = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Confirmar Exclusão'),
            content: Text(
              'Deseja realmente deletar o estado "${estado.nome}"?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('Deletar'),
              ),
            ],
          ),
    );

    if (confirmacao == true) {
      try {
        final sucesso = await _daoEstado.deletar(estado.id!);
        if (sucesso) {
          _carregarDados();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Estado "${estado.nome}" deletado com sucesso!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao deletar estado: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Color _getCorRegiao(String regiao) {
    switch (regiao) {
      case 'Norte':
        return Colors.green;
      case 'Nordeste':
        return Colors.orange;
      case 'Centro-Oeste':
        return Colors.yellow.shade700;
      case 'Sudeste':
        return Colors.blue;
      case 'Sul':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Widget _buildEstadoCard(DTOEstado estado) {
    final cidadesCount = _contadorCidades[estado.id] ?? 0;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor:
              estado.ativo ? _getCorRegiao(estado.regiao) : Colors.grey,
          child: Text(
            estado.sigla,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
        title: Text(
          estado.nome,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: estado.ativo ? Colors.black87 : Colors.grey,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Região: ${estado.regiao}'),
            Text('Cidades: $cidadesCount'),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            switch (value) {
              case 'editar':
                _navegarParaFormulario(estado);
                break;
              case 'status':
                _alterarStatus(estado);
                break;
              case 'deletar':
                _deletarEstado(estado);
                break;
            }
          },
          itemBuilder:
              (context) => [
                const PopupMenuItem(
                  value: 'editar',
                  child: ListTile(
                    leading: Icon(Icons.edit),
                    title: Text('Editar'),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                PopupMenuItem(
                  value: 'status',
                  child: ListTile(
                    leading: Icon(
                      estado.ativo ? Icons.visibility_off : Icons.visibility,
                    ),
                    title: Text(estado.ativo ? 'Desativar' : 'Ativar'),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                const PopupMenuItem(
                  value: 'deletar',
                  child: ListTile(
                    leading: Icon(Icons.delete, color: Colors.red),
                    title: Text('Deletar', style: TextStyle(color: Colors.red)),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ],
        ),
        onTap: () => _navegarParaFormulario(estado),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Estados'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _carregarDados,
          ),
        ],
      ),
      body: Column(
        children: [
          // Filtros
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    labelText: 'Buscar estado...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    suffixIcon:
                        _searchController.text.isNotEmpty
                            ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _searchController.clear();
                                _filtrarEstados();
                              },
                            )
                            : null,
                  ),
                  onChanged: (_) => _filtrarEstados(),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: _regiaoFiltro,
                  decoration: InputDecoration(
                    labelText: 'Filtrar por região',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    prefixIcon: const Icon(Icons.map),
                  ),
                  items: [
                    const DropdownMenuItem<String>(
                      value: null,
                      child: Text('Todas as regiões'),
                    ),
                    ..._regioes.map((regiao) {
                      return DropdownMenuItem<String>(
                        value: regiao,
                        child: Text(regiao),
                      );
                    }).toList(),
                  ],
                  onChanged: (String? novaRegiao) {
                    setState(() {
                      _regiaoFiltro = novaRegiao;
                    });
                    _filtrarEstados();
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child:
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _estadosFiltrados.isEmpty
                    ? const Center(
                      child: Text(
                        'Nenhum estado encontrado',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    )
                    : ListView.builder(
                      itemCount: _estadosFiltrados.length,
                      itemBuilder: (context, index) {
                        return _buildEstadoCard(_estadosFiltrados[index]);
                      },
                    ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navegarParaFormulario(),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }
}
