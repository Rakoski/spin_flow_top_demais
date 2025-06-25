import 'package:spin_flow/dto/dto_grupo_alunos.dart';
import 'mock_alunos.dart';

List<DTOGrupoAlunos> mockGruposAlunos = [
  DTOGrupoAlunos(
    id: 1,
    nome: 'Grupo Iniciantes',
    descricao: 'Grupo para alunos que estão começando no spinning',
    alunos: [
      mockAlunos[2], // Ana Beatriz Costa
      mockAlunos[8], // Patricia Santos
      mockAlunos[12], // Rafael Monteiro
      mockAlunos[15], // Larissa Melo
    ],
    ativo: true,
  ),
  DTOGrupoAlunos(
    id: 2,
    nome: 'Grupo Avançados',
    descricao: 'Grupo para alunos experientes que buscam desafios',
    alunos: [
      mockAlunos[3], // Pedro Henrique Lima
      mockAlunos[9], // Diego Matos
      mockAlunos[17], // Gustavo Nogueira
      mockAlunos[19], // Igor Pacheco
    ],
    ativo: true,
  ),
  DTOGrupoAlunos(
    id: 3,
    nome: 'Grupo Matinal',
    descricao: 'Grupo que frequenta aulas no período da manhã',
    alunos: [
      mockAlunos[0], // Maria Oliveira Santos
      mockAlunos[7], // Marcos Antonio Pereira
      mockAlunos[13], // Camila Teixeira
      mockAlunos[16], // Vinícius Carvalho
    ],
    ativo: true,
  ),
  DTOGrupoAlunos(
    id: 4,
    nome: 'Grupo Noturno',
    descricao: 'Grupo que frequenta aulas no período da noite',
    alunos: [
      mockAlunos[1], // João Carlos Silva
      mockAlunos[5], // Carlos Eduardo Rocha
      mockAlunos[10], // Bruna Andrade
      mockAlunos[18], // Elaine Cardoso
    ],
    ativo: true,
  ),
  DTOGrupoAlunos(
    id: 5,
    nome: 'Grupo Saúde',
    descricao: 'Grupo com foco em saúde e bem-estar',
    alunos: [
      mockAlunos[6], // Fernanda Almeida
      mockAlunos[11], // Bruna Andrade
      mockAlunos[14], // André Barbosa
      mockAlunos[15], // Larissa Melo
    ],
    ativo: true,
  ),
  DTOGrupoAlunos(
    id: 6,
    nome: 'Grupo Performance',
    descricao: 'Grupo focado em alta performance e resultados',
    alunos: [
      mockAlunos[3], // Pedro Henrique Lima
      mockAlunos[9], // Diego Matos
      mockAlunos[13], // Camila Teixeira
      mockAlunos[17], // Gustavo Nogueira
    ],
    ativo: true,
  ),
  DTOGrupoAlunos(
    id: 7,
    nome: 'Grupo Weekend',
    descricao: 'Grupo que frequenta aulas nos fins de semana',
    alunos: [
      mockAlunos[4], // Juliana Ferreira
      mockAlunos[12], // Rafael Monteiro
      mockAlunos[16], // Vinícius Carvalho
      mockAlunos[19], // Igor Pacheco
    ],
    ativo: true,
  ),
  DTOGrupoAlunos(
    id: 8,
    nome: 'Grupo Profissionais',
    descricao: 'Grupo formado por profissionais da área da saúde',
    alunos: [
      mockAlunos[6], // Fernanda Almeida (professora de yoga)
      mockAlunos[9], // Diego Matos (personal trainer)
      mockAlunos[11], // Bruna Andrade (fisioterapeuta)
      mockAlunos[14], // André Barbosa (cardiologista)
      mockAlunos[15], // Larissa Melo (nutricionista)
    ],
    ativo: true,
  ),
  DTOGrupoAlunos(
    id: 9,
    nome: 'Grupo Executivos',
    descricao: 'Grupo formado por executivos que buscam aliviar estresse',
    alunos: [
      mockAlunos[1], // João Carlos Silva
      mockAlunos[7], // Marcos Antonio Pereira
      mockAlunos[12], // Rafael Monteiro (advogado)
      mockAlunos[19], // Igor Pacheco (programador)
    ],
    ativo: true,
  ),
  DTOGrupoAlunos(
    id: 10,
    nome: 'Grupo Influenciadores',
    descricao: 'Grupo de influenciadores fitness',
    alunos: [
      mockAlunos[4], // Juliana Ferreira
      mockAlunos[13], // Camila Teixeira
      mockAlunos[16], // Vinícius Carvalho
      mockAlunos[18], // Elaine Cardoso
    ],
    ativo: true,
  ),
  DTOGrupoAlunos(
    id: 11,
    nome: 'Grupo Recuperação',
    descricao: 'Grupo em processo de recuperação de lesões',
    alunos: [
      mockAlunos[5], // Carlos Eduardo Rocha
      mockAlunos[11], // Bruna Andrade
      mockAlunos[14], // André Barbosa
    ],
    ativo: true,
  ),
  DTOGrupoAlunos(
    id: 12,
    nome: 'Grupo Motivacional',
    descricao: 'Grupo que busca motivação e superação',
    alunos: [
      mockAlunos[0], // Maria Oliveira Santos
      mockAlunos[2], // Ana Beatriz Costa
      mockAlunos[8], // Patricia Santos
      mockAlunos[17], // Gustavo Nogueira
    ],
    ativo: true,
  ),
  DTOGrupoAlunos(
    id: 13,
    nome: 'Grupo Core',
    descricao: 'Grupo focado em treinos de core e estabilização',
    alunos: [
      mockAlunos[6], // Fernanda Almeida
      mockAlunos[9], // Diego Matos
      mockAlunos[15], // Larissa Melo
      mockAlunos[16], // Vinícius Carvalho
    ],
    ativo: true,
  ),
  DTOGrupoAlunos(
    id: 14,
    nome: 'Grupo Endurance',
    descricao: 'Grupo focado em treinos de resistência',
    alunos: [
      mockAlunos[3], // Pedro Henrique Lima
      mockAlunos[7], // Marcos Antonio Pereira
      mockAlunos[12], // Rafael Monteiro
      mockAlunos[19], // Igor Pacheco
    ],
    ativo: true,
  ),
  DTOGrupoAlunos(
    id: 15,
    nome: 'Grupo HIIT',
    descricao: 'Grupo que prefere treinos de alta intensidade',
    alunos: [
      mockAlunos[1], // João Carlos Silva
      mockAlunos[4], // Juliana Ferreira
      mockAlunos[9], // Diego Matos
      mockAlunos[13], // Camila Teixeira
    ],
    ativo: true,
  ),
  DTOGrupoAlunos(
    id: 16,
    nome: 'Grupo Relaxamento',
    descricao: 'Grupo que busca equilíbrio e relaxamento',
    alunos: [
      mockAlunos[6], // Fernanda Almeida
      mockAlunos[10], // Bruna Andrade
      mockAlunos[17], // Sabrina Duarte
      mockAlunos[18], // Elaine Cardoso
    ],
    ativo: true,
  ),
  DTOGrupoAlunos(
    id: 17,
    nome: 'Grupo Competição',
    descricao: 'Grupo que participa de competições',
    alunos: [
      mockAlunos[3], // Pedro Henrique Lima
      mockAlunos[9], // Diego Matos
      mockAlunos[16], // Vinícius Carvalho
      mockAlunos[17], // Gustavo Nogueira
    ],
    ativo: true,
  ),
  DTOGrupoAlunos(
    id: 18,
    nome: 'Grupo Social',
    descricao: 'Grupo que busca interação social',
    alunos: [
      mockAlunos[0], // Maria Oliveira Santos
      mockAlunos[4], // Juliana Ferreira
      mockAlunos[8], // Patricia Santos
      mockAlunos[13], // Camila Teixeira
    ],
    ativo: true,
  ),
  DTOGrupoAlunos(
    id: 19,
    nome: 'Grupo Técnica',
    descricao: 'Grupo focado em aperfeiçoar técnica',
    alunos: [
      mockAlunos[9], // Diego Matos
      mockAlunos[17], // Gustavo Nogueira
      mockAlunos[18], // Elaine Cardoso
      mockAlunos[19], // Igor Pacheco
    ],
    ativo: true,
  ),
  DTOGrupoAlunos(
    id: 20,
    nome: 'Grupo Diversidade',
    descricao: 'Grupo com perfis diversos e idades variadas',
    alunos: [
      mockAlunos[0], // Maria Oliveira Santos
      mockAlunos[2], // Ana Beatriz Costa
      mockAlunos[5], // Carlos Eduardo Rocha
      mockAlunos[8], // Patricia Santos
      mockAlunos[12], // Rafael Monteiro
      mockAlunos[15], // Larissa Melo
    ],
    ativo: true,
  ),
]; 