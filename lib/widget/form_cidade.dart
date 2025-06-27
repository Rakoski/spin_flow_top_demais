import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spin_flow/banco/sqlite/dao/dao_cidade.dart';
import 'package:spin_flow/banco/sqlite/dao/dao_estado.dart';
import 'package:spin_flow/dto/dto_cidade.dart';
import 'package:spin_flow/dto/dto_estado.dart';

class FormCidadePage extends StatefulWidget {
  final DTOCidade? cidade;

  const FormCidadePage({Key? key, this.cidade}) : super(key: key);

  @override
  State<FormCidadePage> createState() => _FormCidadePageState();
}

class _FormCidadePageState extends State<FormCidadePage> {
  final _formKey = GlobalKey<FormState>();
  final DaoCidade _daoCidade = DaoCidade();
  final DaoEstado _daoEstado = DaoEstado();

  // Controllers
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _codigoIbgeController = TextEditingController();
  final TextEditingController _populacaoController = TextEditingController();
  final TextEditingController _areaKm2Controller = TextEditingController();

  // Estado selecionado
  DTOEstado? _estadoSelecionado;
  List<DTOEstado> _estados = [];
  bool _ativa = true;
  bool _isLoading = false;
  bool _isLoadingEstados = true;

  @override
  void initState() {
    super.initState();
    _carregarEstados();
    if (widget.cidade != null) {
      _preencherFormulario();
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _codigoIbgeController.dispose();
    _populacaoController.dispose();
    _areaKm2Controller.dispose();
    super.dispose();
  }

  Future<void> _carregarEstados() async {
    try {
      final estados = await _daoEstado.buscarAtivos();
      setState(() {
        _estados = estados;
        _isLoadingEstados = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingEstados = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao carregar estados: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _preencherFormulario() {
    final cidade = widget.cidade!;
    _nomeController.text = cidade.nome;
    _codigoIbgeController.text = cidade.codigoIbge ?? '';
    _populacaoController.text = cidade.populacao?.toString() ?? '';
    _areaKm2Controller.text = cidade.areaKm2?.toString() ?? '';
    _ativa = cidade.ativa;

    // Definir o estado selecionado após carregar os estados
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_estados.isNotEmpty) {
        final estado = _estados.firstWhere(
          (e) => e.id == cidade.idEstado,
          orElse: () => _estados.first,
        );
        setState(() {
          _estadoSelecionado = estado;
        });
      }
    });
  }

  Future<void> _salvarCidade() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_estadoSelecionado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, selecione um estado'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final cidade = DTOCidade(
        id: widget.cidade?.id,
        nome: _nomeController.text.trim(),
        codigoIbge:
            _codigoIbgeController.text.trim().isEmpty
                ? null
                : _codigoIbgeController.text.trim(),
        populacao:
            _populacaoController.text.trim().isEmpty
                ? null
                : int.parse(_populacaoController.text.trim()),
        areaKm2:
            _areaKm2Controller.text.trim().isEmpty
                ? null
                : double.parse(_areaKm2Controller.text.trim()),
        idEstado: _estadoSelecionado!.id!,
        ativa: _ativa,
      );

      await _daoCidade.salvar(cidade);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.cidade == null
                ? 'Cidade cadastrada com sucesso!'
                : 'Cidade atualizada com sucesso!',
          ),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao salvar cidade: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.cidade == null ? 'Nova Cidade' : 'Editar Cidade'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _isLoading ? null : _salvarCidade,
          ),
        ],
      ),
      body:
          _isLoadingEstados
              ? const Center(child: CircularProgressIndicator())
              : Form(
                key: _formKey,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Nome da cidade
                      TextFormField(
                        controller: _nomeController,
                        decoration: InputDecoration(
                          labelText: 'Nome da Cidade *',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          prefixIcon: const Icon(Icons.location_city),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Por favor, informe o nome da cidade';
                          }
                          if (value.trim().length < 2) {
                            return 'Nome deve ter pelo menos 2 caracteres';
                          }
                          return null;
                        },
                        textCapitalization: TextCapitalization.words,
                      ),
                      const SizedBox(height: 16),

                      // Seleção de Estado
                      DropdownButtonFormField<DTOEstado>(
                        value: _estadoSelecionado,
                        decoration: InputDecoration(
                          labelText: 'Estado *',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          prefixIcon: const Icon(Icons.map),
                        ),
                        items:
                            _estados.map((estado) {
                              return DropdownMenuItem<DTOEstado>(
                                value: estado,
                                child: Text('${estado.nome} (${estado.sigla})'),
                              );
                            }).toList(),
                        onChanged: (DTOEstado? novoEstado) {
                          setState(() {
                            _estadoSelecionado = novoEstado;
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Por favor, selecione um estado';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Código IBGE
                      TextFormField(
                        controller: _codigoIbgeController,
                        decoration: InputDecoration(
                          labelText: 'Código IBGE',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          prefixIcon: const Icon(Icons.numbers),
                          helperText: 'Código de 7 dígitos do IBGE (opcional)',
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(7),
                        ],
                        validator: (value) {
                          if (value != null &&
                              value.isNotEmpty &&
                              value.length != 7) {
                            return 'Código IBGE deve ter exatamente 7 dígitos';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // População
                      TextFormField(
                        controller: _populacaoController,
                        decoration: InputDecoration(
                          labelText: 'População',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          prefixIcon: const Icon(Icons.people),
                          helperText: 'Número de habitantes (opcional)',
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        validator: (value) {
                          if (value != null && value.isNotEmpty) {
                            final populacao = int.tryParse(value);
                            if (populacao == null || populacao <= 0) {
                              return 'População deve ser um número positivo';
                            }
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Área em km²
                      TextFormField(
                        controller: _areaKm2Controller,
                        decoration: InputDecoration(
                          labelText: 'Área (km²)',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          prefixIcon: const Icon(Icons.square_foot),
                          helperText:
                              'Área territorial em quilômetros quadrados (opcional)',
                        ),
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'^\d+\.?\d{0,2}'),
                          ),
                        ],
                        validator: (value) {
                          if (value != null && value.isNotEmpty) {
                            final area = double.tryParse(value);
                            if (area == null || area <= 0) {
                              return 'Área deve ser um número positivo';
                            }
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),

                      // Switch para ativo/inativo
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              const Icon(Icons.toggle_on, color: Colors.blue),
                              const SizedBox(width: 12),
                              const Expanded(
                                child: Text(
                                  'Cidade Ativa',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                              Switch(
                                value: _ativa,
                                onChanged: (value) {
                                  setState(() {
                                    _ativa = value;
                                  });
                                },
                                activeColor: Colors.green,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Informações do estado selecionado
                      if (_estadoSelecionado != null)
                        Card(
                          color: Colors.blue.shade50,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Informações do Estado Selecionado:',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text('Nome: ${_estadoSelecionado!.nome}'),
                                Text('Sigla: ${_estadoSelecionado!.sigla}'),
                                Text('Região: ${_estadoSelecionado!.regiao}'),
                              ],
                            ),
                          ),
                        ),
                      const SizedBox(height: 32),

                      // Botões de ação
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed:
                                  _isLoading
                                      ? null
                                      : () => Navigator.pop(context),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                              ),
                              child: const Text('Cancelar'),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _salvarCidade,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                              ),
                              child:
                                  _isLoading
                                      ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                Colors.white,
                                              ),
                                        ),
                                      )
                                      : Text(
                                        widget.cidade == null
                                            ? 'Cadastrar'
                                            : 'Atualizar',
                                      ),
                            ),
                          ),
                        ],
                      ),

                      // Texto de campos obrigatórios
                      const SizedBox(height: 16),
                      const Text(
                        '* Campos obrigatórios',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                          fontStyle: FontStyle.italic,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
    );
  }
}
