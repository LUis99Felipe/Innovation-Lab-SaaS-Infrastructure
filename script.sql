-- ==========================================================
-- Projeto: Agenda de Aulas para Professores
-- Banco de dados: MySQL 8.0+
-- Objetivo: organizar as aulas que cada professor ministrará.
-- ==========================================================

CREATE DATABASE IF NOT EXISTS agenda_aulas
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_0900_ai_ci;

USE agenda_aulas;

-- Professores que consultarão a agenda.
CREATE TABLE IF NOT EXISTS professores (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(150) NOT NULL,
    email VARCHAR(254) NOT NULL UNIQUE,
    ativo BOOLEAN NOT NULL DEFAULT TRUE,
    criado_em TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- Disciplinas ou matérias.
CREATE TABLE IF NOT EXISTS disciplinas (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(120) NOT NULL UNIQUE,
    descricao VARCHAR(500) NULL
) ENGINE=InnoDB;

-- Turmas que participam das aulas.
CREATE TABLE IF NOT EXISTS turmas (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    descricao VARCHAR(500) NULL,
    UNIQUE KEY uq_turma_nome (nome)
) ENGINE=InnoDB;

-- Salas físicas ou espaços identificados.
CREATE TABLE IF NOT EXISTS salas (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL UNIQUE,
    localizacao VARCHAR(200) NULL
) ENGINE=InnoDB;

-- Uma linha representa uma aula agendada.
CREATE TABLE IF NOT EXISTS aulas (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    professor_id BIGINT UNSIGNED NOT NULL,
    disciplina_id BIGINT UNSIGNED NOT NULL,
    turma_id BIGINT UNSIGNED NOT NULL,
    sala_id BIGINT UNSIGNED NULL,
    data_aula DATE NOT NULL,
    hora_inicio TIME NOT NULL,
    hora_fim TIME NOT NULL,
    observacoes TEXT NULL,
    status ENUM('agendada', 'realizada', 'cancelada') NOT NULL DEFAULT 'agendada',
    criado_em TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    atualizado_em TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT chk_aula_horario
        CHECK (hora_fim > hora_inicio),

    CONSTRAINT fk_aula_professor
        FOREIGN KEY (professor_id) REFERENCES professores(id)
        ON UPDATE CASCADE ON DELETE RESTRICT,

    CONSTRAINT fk_aula_disciplina
        FOREIGN KEY (disciplina_id) REFERENCES disciplinas(id)
        ON UPDATE CASCADE ON DELETE RESTRICT,

    CONSTRAINT fk_aula_turma
        FOREIGN KEY (turma_id) REFERENCES turmas(id)
        ON UPDATE CASCADE ON DELETE RESTRICT,

    CONSTRAINT fk_aula_sala
        FOREIGN KEY (sala_id) REFERENCES salas(id)
        ON UPDATE CASCADE ON DELETE SET NULL,

    INDEX idx_aulas_professor_data_hora (professor_id, data_aula, hora_inicio),
    INDEX idx_aulas_turma_data_hora (turma_id, data_aula, hora_inicio),
    INDEX idx_aulas_data_status (data_aula, status)
) ENGINE=InnoDB;

-- ==========================================================
-- Dados de exemplo (opcionais): descomente para testar.
-- ==========================================================
-- INSERT INTO professores (nome, email)
-- VALUES ('Maria da Silva', 'maria@escola.com');
--
-- INSERT INTO disciplinas (nome, descricao)
-- VALUES ('Matemática', 'Aulas de matemática');
--
-- INSERT INTO turmas (nome, descricao)
-- VALUES ('Turma A', 'Turma do período da manhã');
--
-- INSERT INTO salas (nome, localizacao)
-- VALUES ('Sala 12', 'Bloco A');
--
-- INSERT INTO aulas (
--     professor_id, disciplina_id, turma_id, sala_id,
--     data_aula, hora_inicio, hora_fim, observacoes
-- )
-- VALUES (
--     1, 1, 1, 1,
--     '2026-11-02', '08:00:00', '09:40:00',
--     'Aula de revisão'
-- );

-- ==========================================================
-- Consulta: próximas aulas de um professor.
-- Altere o valor de professor_id conforme necessário.
-- ==========================================================
-- SELECT
--     a.data_aula,
--     a.hora_inicio,
--     a.hora_fim,
--     d.nome AS disciplina,
--     t.nome AS turma,
--     s.nome AS sala,
--     a.status
-- FROM aulas AS a
-- INNER JOIN disciplinas AS d ON d.id = a.disciplina_id
-- INNER JOIN turmas AS t ON t.id = a.turma_id
-- LEFT JOIN salas AS s ON s.id = a.sala_id
-- WHERE a.professor_id = 1
--   AND a.data_aula >= CURRENT_DATE
--   AND a.status = 'agendada'
-- ORDER BY a.data_aula, a.hora_inicio;
