import 'package:spin_flow/dto/dto.dart';

class DTOAluno implements DTO {
  @override
  final int? id;
  @override
  final String nome;
  final String email;
  final DateTime dataNascimento;
  final String genero;
  final String telefone;
  final String? urlFoto;
  final String? instagram;
  final String? facebook;
  final String? tiktok;
  final String? observacoes;
  final bool ativo;

  DTOAluno({
    this.id,
    required this.nome,
    required this.email,
    required this.dataNascimento,
    required this.genero,
    required this.telefone,
    this.urlFoto,
    this.instagram,
    this.facebook,
    this.tiktok,
    this.observacoes,
    this.ativo = true,
  });
} 