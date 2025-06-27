import 'package:flutter/material.dart';
import 'package:spin_flow/banco/sqlite/dao/dao_cidade.dart';
import 'package:spin_flow/dto/dto_cidade.dart';
import 'package:spin_flow/widget/form_cidade.dart';

class ListaCidades extends StatefulWidget {
  const ListaCidades({Key? key}) : super(key: key);

  @override
  State<ListaCidades> createState() => _ListaCidadesState();
}

class _ListaCidadesState extends State<ListaCidades> {
  final DaoCidade _daoCidade = DaoCidade();
  List<DTOCidade> _cidades = [];
  List<DTOCidade> _cidadesFiltradas = [];
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _carregarCidades();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _carregarCidades() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final cidades = await _daoCidade.buscarTodos();
      setState(() {
        _cidades = cidades;
        _cidadesFiltradas = cidades;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao carregar cidades: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _filtrarCidades(String query) {
    setState(() {
      if (query.isEmpty) {
        _cidadesFiltradas = _cidades;
      } else {
        _cidadesFiltradas =
            _cidades.where((cidade) {
              return cidade.nome.toLowerCase().contains(query.toLowerCase()) ||
                  (cidade.estado?.nome.toLowerCase().contains(
                        query.toLowerCase(),
                      ) ??
                      false) ||
                  (cidade.estado?.sigla.toLowerCase().contains(
                        query.toLowerCase(),
                      ) ??
                      false);
            }).toList();
      }
    });
  }

  Future<void> _navegarParaFormulario([DTOCidade? cidade]) async {
    final resultado = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FormCidadePage(cidade: cidade)),
    );

    if (resultado == true) {
      _carregarCidades();
    }
  }

  Future<void> _alterarStatus(DTOCidade cidade) async {
    try {
      final sucesso = await _daoCidade.alterarStatus(cidade.id!, !cidade.ativa);
      if (sucesso) {
        _carregarCidades();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              cidade.ativa
                  ? 'Cidade ${cidade.nome} desativada com sucesso!'
                  : 'Cidade ${cidade.nome} ativada com sucesso!',
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

  Future<void> _deletarCidade(DTOCidade cidade) async {
    final confirmacao = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Confirmar Exclusão'),
            content: Text(
              'Deseja realmente deletar a cidade "${cidade.nome}"?',
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
        final sucesso = await _daoCidade.deletar(cidade.id!);
        if (sucesso) {
          _carregarCidades();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Cidade "${cidade.nome}" deletada com sucesso!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao deletar cidade: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Widget _buildCidadeCard(DTOCidade cidade) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: cidade.ativa ? Colors.green : Colors.grey,
          child: Text(
            cidade.estado?.sigla ?? '--',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
        title: Text(
          cidade.nome,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: cidade.ativa ? Colors.black87 : Colors.grey,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Estado: ${cidade.estado?.nome ?? 'N/A'}'),
            Text('Região: ${cidade.estado?.regiao ?? 'N/A'}'),
            if (cidade.populacao != null)
              Text(
                'População: ${cidade.populacao!.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}',
              ),
            if (cidade.areaKm2 != null)
              Text('Área: ${cidade.areaKm2!.toStringAsFixed(2)} km²'),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            switch (value) {
              case 'editar':
                _navegarParaFormulario(cidade);
                break;
              case 'status':
                _alterarStatus(cidade);
                break;
              case 'deletar':
                _deletarCidade(cidade);
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
                      cidade.ativa ? Icons.visibility_off : Icons.visibility,
                    ),
                    title: Text(cidade.ativa ? 'Desativar' : 'Ativar'),
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
        onTap: () => _navegarParaFormulario(cidade),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cidades'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _carregarCidades,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Buscar cidade ou estado...',
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
                            _filtrarCidades('');
                          },
                        )
                        : null,
              ),
              onChanged: _filtrarCidades,
            ),
          ),
          Expanded(
            child:
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _cidadesFiltradas.isEmpty
                    ? const Center(
                      child: Text(
                        'Nenhuma cidade encontrada',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    )
                    : ListView.builder(
                      itemCount: _cidadesFiltradas.length,
                      itemBuilder: (context, index) {
                        return _buildCidadeCard(_cidadesFiltradas[index]);
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
