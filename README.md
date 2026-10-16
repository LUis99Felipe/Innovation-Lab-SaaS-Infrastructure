# Agenda de Aulas para Professores

# Membros:
- Luis Felipe de Souza Oliveira - RA: 2501173
- Enzo Panassol Zapparolli - RA: 2500187 
- João Vitor Fogaça Rocha - RA: 2500048

## Sobre o projeto

A **Agenda de Aulas para Professores** é um sistema para que professores consultem, de forma simples e organizada, quais aulas irão ministrar. A proposta é centralizar as informações das aulas em um único lugar, facilitando a consulta da data, horário, turma, disciplina e local.

Este repositório contém a documentação inicial e o script SQL para criar a estrutura do banco de dados.

## Objetivos

- Permitir que professores visualizem suas próximas aulas.
- Organizar aulas por data e horário.
- Identificar a disciplina, a turma e a sala de cada aula.
- Evitar conflitos de horários para o mesmo professor.
- Manter os dados organizados para futuras integrações com uma aplicação web.

## Funcionalidades previstas

1. Cadastro de professores.
2. Cadastro de disciplinas.
3. Cadastro de turmas.
4. Cadastro de salas.
5. Registro de aulas com data, horário e informações relacionadas.
6. Consulta da agenda de um professor por período.
7. Visualização das próximas aulas em ordem cronológica.

## Tecnologias

- **Banco de dados:** MySQL 8.0 ou compatível.
- **Aplicação:** a linguagem e o framework serão definidos durante o desenvolvimento.

## Estrutura do banco de dados

O script `script.sql` cria as seguintes tabelas:

- `professores`: dados dos professores.
- `disciplinas`: disciplinas ministradas.
- `turmas`: turmas cadastradas.
- `salas`: locais em que as aulas acontecem.
- `aulas`: data, horário e relacionamentos de cada aula.

O banco utiliza chaves estrangeiras para manter a integridade dos relacionamentos e índices para facilitar consultas da agenda.

## Como executar o script SQL

1. Instale ou abra uma ferramenta compatível com MySQL, como MySQL Workbench.
2. Conecte-se ao servidor MySQL.
3. Abra o arquivo `script.sql`.
4. Execute o script para criar o banco `agenda_aulas` e suas tabelas.
5. Para conferir a estrutura, execute:

   ```sql
   USE agenda_aulas;
   SHOW TABLES;
   ```

> **Atenção:** o script começa com `CREATE DATABASE IF NOT EXISTS` e seleciona o banco `agenda_aulas`. Ele não apaga tabelas existentes.

## Exemplo de consulta: agenda de um professor

```sql
SELECT
    a.data_aula,
    a.hora_inicio,
    a.hora_fim,
    d.nome AS disciplina,
    t.nome AS turma,
    s.nome AS sala
FROM aulas AS a
JOIN professores AS p ON p.id = a.professor_id
JOIN disciplinas AS d ON d.id = a.disciplina_id
JOIN turmas AS t ON t.id = a.turma_id
LEFT JOIN salas AS s ON s.id = a.sala_id
WHERE p.id = 1
  AND a.data_aula >= CURRENT_DATE
ORDER BY a.data_aula, a.hora_inicio;
```

Substitua `1` pelo identificador do professor desejado.

## Regras iniciais

- O horário de término deve ser posterior ao horário de início.
- A data e os horários da aula são obrigatórios.
- Cada aula está associada a um professor, uma disciplina e uma turma.
- A sala é opcional, pois algumas aulas podem ocorrer remotamente ou sem sala definida.
- A aplicação deverá validar conflitos de horário antes de cadastrar ou alterar aulas.

## Próximas etapas

- Desenvolver a interface de login.
- Implementar telas de cadastro e edição.
- Criar a visualização diária, semanal e mensal da agenda.
- Adicionar filtros por período, turma e disciplina.
- Implementar regras para detectar conflitos de horários.
- Definir permissões e autenticação antes de disponibilizar o sistema em produção.

## Status

**Em desenvolvimento — estrutura inicial do banco de dados e documentação.**
