import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spin_flow/banco/sqlite/dao/dao_estado.dart';
import 'package:spin_flow/dto/dto_estado.dart';

class FormEstadoPage extends StatefulWidget {
  final DTOEstado? estado;

  const FormEstadoPage({Key? key, this.estado}) : super(key: key);

  @override
  State<FormEstadoPage> createState() => _FormEstadoPageState();
}

class _FormEstadoPageState extends State<FormEstadoPage> {
  final _formKey = GlobalKey<FormState>();
  final DaoEstado _daoEstado = DaoEstado();

  // Controllers
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _siglaController = TextEditingController();

  // Região selecionada
  String? _regiaoSelecionada;
  bool _ativo = true;
  bool _isLoading = false;

  final List<String> _regioes = [
    'Norte',
    'Nordeste',
    'Centro-Oeste',
    'Sudeste',
    'Sul',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.estado != null) {
      _preencherFormulario();
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _siglaController.dispose();
    super.dispose();
  }

  void _preencherFormulario() {
    final estado = widget.estado!;
    _nomeController.text = estado.nome;
    _siglaController.text = estado.sigla;
    _regiaoSelecionada = estado.regiao;
    _ativo = estado.ativo;
  }

  Future<void> _salvarEstado() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_regiaoSelecionada == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, selecione uma região'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Verificar se já existe um estado com a mesma sigla (apenas para novos estados ou mudança de sigla)
      if (widget.estado == null ||
          widget.estado!.sigla != _siglaController.text.trim().toUpperCase()) {
        final estadoExistente = await _daoEstado.buscarPorSigla(
          _siglaController.text.trim(),
        );
        if (estadoExistente != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Já existe um estado com a sigla "${_siglaController.text.trim().toUpperCase()}"',
              ),
              backgroundColor: Colors.red,
            ),
          );
          setState(() {
            _isLoading = false;
          });
          return;
        }
      }

      final estado = DTOEstado(
        id: widget.estado?.id,
        nome: _nomeController.text.trim(),
        sigla: _siglaController.text.trim().toUpperCase(),
        regiao: _regiaoSelecionada!,
        ativo: _ativo,
      );

      await _daoEstado.salvar(estado);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.estado == null
                ? 'Estado cadastrado com sucesso!'
                : 'Estado atualizado com sucesso!',
          ),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao salvar estado: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Color _getCorRegiao(String? regiao) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.estado == null ? 'Novo Estado' : 'Editar Estado'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _isLoading ? null : _salvarEstado,
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Nome do estado
              TextFormField(
                controller: _nomeController,
                decoration: InputDecoration(
                  labelText: 'Nome do Estado *',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: const Icon(Icons.location_on),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Por favor, informe o nome do estado';
                  }
                  if (value.trim().length < 2) {
                    return 'Nome deve ter pelo menos 2 caracteres';
                  }
                  return null;
                },
                textCapitalization: TextCapitalization.words,
              ),
              const SizedBox(height: 16),

              // Sigla do estado
              TextFormField(
                controller: _siglaController,
                decoration: InputDecoration(
                  labelText: 'Sigla *',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: const Icon(Icons.text_fields),
                  helperText: 'Sigla de 2 letras (ex: SP, RJ, MG)',
                ),
                textCapitalization: TextCapitalization.characters,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z]')),
                  LengthLimitingTextInputFormatter(2),
                ],
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Por favor, informe a sigla do estado';
                  }
                  if (value.trim().length != 2) {
                    return 'Sigla deve ter exatamente 2 letras';
                  }
                  return null;
                },
                onChanged: (value) {
                  // Atualizar automaticamente para maiúsculas
                  if (value.isNotEmpty) {
                    final upperValue = value.toUpperCase();
                    if (upperValue != value) {
                      _siglaController.value = TextEditingValue(
                        text: upperValue,
                        selection: TextSelection.collapsed(
                          offset: upperValue.length,
                        ),
                      );
                    }
                  }
                },
              ),
              const SizedBox(height: 16),

              // Seleção de Região
              DropdownButtonFormField<String>(
                value: _regiaoSelecionada,
                decoration: InputDecoration(
                  labelText: 'Região *',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: const Icon(Icons.map),
                ),
                items:
                    _regioes.map((regiao) {
                      return DropdownMenuItem<String>(
                        value: regiao,
                        child: Row(
                          children: [
                            Container(
                              width: 16,
                              height: 16,
                              decoration: BoxDecoration(
                                color: _getCorRegiao(regiao),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(regiao),
                          ],
                        ),
                      );
                    }).toList(),
                onChanged: (String? novaRegiao) {
                  setState(() {
                    _regiaoSelecionada = novaRegiao;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Por favor, selecione uma região';
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
                          'Estado Ativo',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      Switch(
                        value: _ativo,
                        onChanged: (value) {
                          setState(() {
                            _ativo = value;
                          });
                        },
                        activeColor: Colors.green,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Preview da região selecionada
              if (_regiaoSelecionada != null)
                Card(
                  color: _getCorRegiao(_regiaoSelecionada).withOpacity(0.1),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: _getCorRegiao(_regiaoSelecionada),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Região: $_regiaoSelecionada',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
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
                          _isLoading ? null : () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Cancelar'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _salvarEstado,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child:
                          _isLoading
                              ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                              : Text(
                                widget.estado == null
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

              // Informações sobre regiões
              const SizedBox(height: 24),
              Card(
                color: Colors.grey.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Regiões do Brasil:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ..._regioes
                          .map(
                            (regiao) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 2),
                              child: Row(
                                children: [
                                  Container(
                                    width: 12,
                                    height: 12,
                                    decoration: BoxDecoration(
                                      color: _getCorRegiao(regiao),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    regiao,
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
