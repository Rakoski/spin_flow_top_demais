import 'package:spin_flow/dto/dto.dart';
import 'package:spin_flow/dto/dto_estado.dart';

class DTOCidade implements DTO {
  @override
  final int? id;
  @override
  final String nome;
  final String? codigoIbge;
  final int? populacao;
  final double? areaKm2;
  final int idEstado;
  final bool ativa;

  // Propriedade para armazenar informações do estado associado
  final DTOEstado? estado;

  DTOCidade({
    this.id,
    required this.nome,
    this.codigoIbge,
    this.populacao,
    this.areaKm2,
    required this.idEstado,
    this.ativa = true,
    this.estado,
  });

  @override
  String toString() {
    return 'DTOCidade{id: $id, nome: $nome, codigoIbge: $codigoIbge, populacao: $populacao, areaKm2: $areaKm2, idEstado: $idEstado, ativa: $ativa, estado: ${estado?.nome}}';
  }

  DTOCidade copyWith({
    int? id,
    String? nome,
    String? codigoIbge,
    int? populacao,
    double? areaKm2,
    int? idEstado,
    bool? ativa,
    DTOEstado? estado,
  }) {
    return DTOCidade(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      codigoIbge: codigoIbge ?? this.codigoIbge,
      populacao: populacao ?? this.populacao,
      areaKm2: areaKm2 ?? this.areaKm2,
      idEstado: idEstado ?? this.idEstado,
      ativa: ativa ?? this.ativa,
      estado: estado ?? this.estado,
    );
  }
}
