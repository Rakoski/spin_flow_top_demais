import 'package:spin_flow/dto/dto.dart';

class DTOArtistaBanda implements DTO {
  @override
  final int? id;
  @override
  final String nome;
  final String? descricao;
  final String? link;
  final String? foto;
  final bool ativo;

  DTOArtistaBanda({
    this.id,
    required this.nome,
    this.descricao,
    this.link,
    this.foto,
    this.ativo = true,
  });
} 