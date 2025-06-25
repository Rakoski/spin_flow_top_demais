import 'package:spin_flow/dto/dto_mix.dart';
import 'mock_musicas.dart';

List<DTOMix> mockMixes = [
  DTOMix(
    id: 1,
    nome: 'Mix Power Março 2025',
    dataInicio: DateTime(2025, 3, 1),
    dataFim: DateTime(2025, 3, 31),
    musicas: [
      mockMusicas[0], // Eye of the Tiger
      mockMusicas[2], // Thunderstruck
      mockMusicas[4], // Believer
      mockMusicas[6], // Stronger
      mockMusicas[8], // Can't Hold Us
    ],
    descricao: 'Mix voltado para treinos intensos e motivacionais',
    ativo: true,
  ),
  DTOMix(
    id: 2,
    nome: 'Mix Energia Abril 2025',
    dataInicio: DateTime(2025, 4, 1),
    dataFim: DateTime(2025, 4, 30),
    musicas: [
      mockMusicas[1], // We Will Rock You
      mockMusicas[3], // Lose Yourself
      mockMusicas[5], // Remember the Name
      mockMusicas[7], // Till I Collapse
      mockMusicas[9], // Born to Run
    ],
    descricao: 'Mix energético para manter o foco e disposição',
    ativo: true,
  ),
  DTOMix(
    id: 3,
    nome: 'Mix Explosão Maio 2025',
    dataInicio: DateTime(2025, 5, 1),
    dataFim: DateTime(2025, 5, 31),
    musicas: [
      mockMusicas[10], // Jump
      mockMusicas[11], // Radioactive
      mockMusicas[12], // Can't Stop
      mockMusicas[13], // The Greatest
      mockMusicas[14], // Born This Way
    ],
    descricao: 'Mix explosivo para treinos de alta intensidade',
    ativo: true,
  ),
  DTOMix(
    id: 4,
    nome: 'Mix Motivação Junho 2025',
    dataInicio: DateTime(2025, 6, 1),
    dataFim: DateTime(2025, 6, 30),
    musicas: [
      mockMusicas[15], // Fight Song
      mockMusicas[16], // High Hopes
      mockMusicas[17], // Invincible
      mockMusicas[18], // Centuries
      mockMusicas[19], // Hall of Fame
    ],
    descricao: 'Mix motivacional para superar limites',
    ativo: true,
  ),
  DTOMix(
    id: 5,
    nome: 'Mix Força Julho 2025',
    dataInicio: DateTime(2025, 7, 1),
    dataFim: DateTime(2025, 7, 31),
    musicas: [
      mockMusicas[2], // Thunderstruck
      mockMusicas[4], // Believer
      mockMusicas[6], // Stronger
      mockMusicas[8], // Can't Hold Us
      mockMusicas[10], // Jump
    ],
    descricao: 'Mix focado em treinos de força e resistência',
    ativo: true,
  ),
  DTOMix(
    id: 6,
    nome: 'Mix Cadência Agosto 2025',
    dataInicio: DateTime(2025, 8, 1),
    dataFim: DateTime(2025, 8, 31),
    musicas: [
      mockMusicas[0], // Eye of the Tiger
      mockMusicas[7], // Can't Hold Us
      mockMusicas[12], // Can't Stop
      mockMusicas[15], // Fight Song
      mockMusicas[18], // Centuries
    ],
    descricao: 'Mix para manter ritmo e cadência constante',
    ativo: true,
  ),
  DTOMix(
    id: 7,
    nome: 'Mix Endurance Setembro 2025',
    dataInicio: DateTime(2025, 9, 1),
    dataFim: DateTime(2025, 9, 30),
    musicas: [
      mockMusicas[8], // Till I Collapse
      mockMusicas[9], // Born to Run
      mockMusicas[11], // Radioactive
      mockMusicas[13], // The Greatest
      mockMusicas[16], // High Hopes
    ],
    descricao: 'Mix para treinos de longa duração e resistência',
    ativo: true,
  ),
  DTOMix(
    id: 8,
    nome: 'Mix HIIT Outubro 2025',
    dataInicio: DateTime(2025, 10, 1),
    dataFim: DateTime(2025, 10, 31),
    musicas: [
      mockMusicas[1], // We Will Rock You
      mockMusicas[3], // Lose Yourself
      mockMusicas[5], // Remember the Name
      mockMusicas[10], // Jump
      mockMusicas[17], // Invincible
    ],
    descricao: 'Mix para treinos de alta intensidade com intervalos',
    ativo: true,
  ),
  DTOMix(
    id: 9,
    nome: 'Mix Core Novembro 2025',
    dataInicio: DateTime(2025, 11, 1),
    dataFim: DateTime(2025, 11, 30),
    musicas: [
      mockMusicas[4], // Believer
      mockMusicas[6], // Stronger
      mockMusicas[12], // Can't Stop
      mockMusicas[14], // Born This Way
      mockMusicas[19], // Hall of Fame
    ],
    descricao: 'Mix para treinos focados em core e estabilização',
    ativo: true,
  ),
  DTOMix(
    id: 10,
    nome: 'Mix Relaxamento Dezembro 2025',
    dataInicio: DateTime(2025, 12, 1),
    dataFim: DateTime(2025, 12, 31),
    musicas: [
      mockMusicas[3], // Lose Yourself
      mockMusicas[8], // Till I Collapse
      mockMusicas[13], // The Greatest
      mockMusicas[15], // Fight Song
      mockMusicas[16], // High Hopes
    ],
    descricao: 'Mix para alongamento e relaxamento',
    ativo: true,
  ),
  DTOMix(
    id: 11,
    nome: 'Mix Iniciantes Janeiro 2025',
    dataInicio: DateTime(2025, 1, 1),
    dataFim: DateTime(2025, 1, 31),
    musicas: [
      mockMusicas[0], // Eye of the Tiger
      mockMusicas[7], // Can't Hold Us
      mockMusicas[12], // Can't Stop
      mockMusicas[15], // Fight Song
      mockMusicas[18], // Centuries
    ],
    descricao: 'Mix para iniciantes com ritmo mais suave',
    ativo: true,
  ),
  DTOMix(
    id: 12,
    nome: 'Mix Avançados Fevereiro 2025',
    dataInicio: DateTime(2025, 2, 1),
    dataFim: DateTime(2025, 2, 28),
    musicas: [
      mockMusicas[2], // Thunderstruck
      mockMusicas[5], // Remember the Name
      mockMusicas[8], // Till I Collapse
      mockMusicas[10], // Jump
      mockMusicas[17], // Invincible
    ],
    descricao: 'Mix para alunos avançados com alta intensidade',
    ativo: true,
  ),
  DTOMix(
    id: 13,
    nome: 'Mix Matinal Março 2025',
    dataInicio: DateTime(2025, 3, 1),
    dataFim: DateTime(2025, 3, 31),
    musicas: [
      mockMusicas[1], // We Will Rock You
      mockMusicas[4], // Believer
      mockMusicas[9], // Born to Run
      mockMusicas[14], // Born This Way
      mockMusicas[19], // Hall of Fame
    ],
    descricao: 'Mix energético para aulas matinais',
    ativo: true,
  ),
  DTOMix(
    id: 14,
    nome: 'Mix Noturno Abril 2025',
    dataInicio: DateTime(2025, 4, 1),
    dataFim: DateTime(2025, 4, 30),
    musicas: [
      mockMusicas[3], // Lose Yourself
      mockMusicas[6], // Stronger
      mockMusicas[11], // Radioactive
      mockMusicas[13], // The Greatest
      mockMusicas[16], // High Hopes
    ],
    descricao: 'Mix para liberar energia após o trabalho',
    ativo: true,
  ),
  DTOMix(
    id: 15,
    nome: 'Mix Weekend Maio 2025',
    dataInicio: DateTime(2025, 5, 1),
    dataFim: DateTime(2025, 5, 31),
    musicas: [
      mockMusicas[0], // Eye of the Tiger
      mockMusicas[2], // Thunderstruck
      mockMusicas[5], // Remember the Name
      mockMusicas[10], // Jump
      mockMusicas[17], // Invincible
    ],
    descricao: 'Mix especial para aulas de fim de semana',
    ativo: true,
  ),
  DTOMix(
    id: 16,
    nome: 'Mix Competição Junho 2025',
    dataInicio: DateTime(2025, 6, 1),
    dataFim: DateTime(2025, 6, 30),
    musicas: [
      mockMusicas[1], // We Will Rock You
      mockMusicas[4], // Believer
      mockMusicas[7], // Can't Hold Us
      mockMusicas[12], // Can't Stop
      mockMusicas[18], // Centuries
    ],
    descricao: 'Mix para preparação de competições',
    ativo: true,
  ),
  DTOMix(
    id: 17,
    nome: 'Mix Recuperação Julho 2025',
    dataInicio: DateTime(2025, 7, 1),
    dataFim: DateTime(2025, 7, 31),
    musicas: [
      mockMusicas[3], // Lose Yourself
      mockMusicas[8], // Till I Collapse
      mockMusicas[13], // The Greatest
      mockMusicas[15], // Fight Song
      mockMusicas[16], // High Hopes
    ],
    descricao: 'Mix para recuperação ativa e alongamento',
    ativo: true,
  ),
  DTOMix(
    id: 18,
    nome: 'Mix Técnica Agosto 2025',
    dataInicio: DateTime(2025, 8, 1),
    dataFim: DateTime(2025, 8, 31),
    musicas: [
      mockMusicas[0], // Eye of the Tiger
      mockMusicas[6], // Stronger
      mockMusicas[9], // Born to Run
      mockMusicas[11], // Radioactive
      mockMusicas[19], // Hall of Fame
    ],
    descricao: 'Mix para aperfeiçoar técnica e performance',
    ativo: true,
  ),
  DTOMix(
    id: 19,
    nome: 'Mix Social Setembro 2025',
    dataInicio: DateTime(2025, 9, 1),
    dataFim: DateTime(2025, 9, 30),
    musicas: [
      mockMusicas[1], // We Will Rock You
      mockMusicas[5], // Remember the Name
      mockMusicas[10], // Jump
      mockMusicas[14], // Born This Way
      mockMusicas[17], // Invincible
    ],
    descricao: 'Mix para aulas com foco em interação social',
    ativo: true,
  ),
  DTOMix(
    id: 20,
    nome: 'Mix Premium Outubro 2025',
    dataInicio: DateTime(2025, 10, 1),
    dataFim: DateTime(2025, 10, 31),
    musicas: [
      mockMusicas[2], // Thunderstruck
      mockMusicas[4], // Believer
      mockMusicas[7], // Can't Hold Us
      mockMusicas[12], // Can't Stop
      mockMusicas[18], // Centuries
    ],
    descricao: 'Mix premium para aulas especiais',
    ativo: true,
  ),
]; 