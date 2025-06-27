import 'package:spin_flow/dto/dto.dart';

class DTOEstado implements DTO {
  @override
  final int? id;
  @override
  final String nome;
  final String sigla;
  final String regiao;
  final bool ativo;

  DTOEstado({
    this.id,
    required this.nome,
    required this.sigla,
    required this.regiao,
    this.ativo = true,
  });

  @override
  String toString() {
    return 'DTOEstado{id: $id, nome: $nome, sigla: $sigla, regiao: $regiao, ativo: $ativo}';
  }

  DTOEstado copyWith({
    int? id,
    String? nome,
    String? sigla,
    String? regiao,
    bool? ativo,
  }) {
    return DTOEstado(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      sigla: sigla ?? this.sigla,
      regiao: regiao ?? this.regiao,
      ativo: ativo ?? this.ativo,
    );
  }
}
