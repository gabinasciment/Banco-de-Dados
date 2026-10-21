-- =============================================================================
-- PARTE 2 - SEÇÃO 4 - CONSULTAS (DML)
-- Roteiro de Aulas Práticas de Banco de Dados
-- =============================================================================

-- Item 2.a: Seleciona todos os atributos e registros de todos os alunos cadastrados.
-- Cláusulas: SELECT (projeta todas as colunas '*'), FROM (tabela ALUNOS).
SELECT * 
  FROM ALUNOS;


-- Item 2.b: Seleciona a matrícula, o nome do aluno formatado com a primeira letra de cada palavra maiúscula (INITCAP),
-- e a data de nascimento, filtrando os alunos que nasceram até 01/01/2000.
-- Cláusulas: SELECT (funções INITCAP e TO_CHAR), FROM (tabela ALUNOS), WHERE (condição <= TO_DATE).
SELECT MATRICULA_ALUNO
     , INITCAP(NOME_ALUNO) AS NOME_ALUNO
     , TO_CHAR(DATA_NASCIMENTO, 'DD/MM/YYYY') AS DATA_NASCIMENTO
  FROM ALUNOS
 WHERE DATA_NASCIMENTO <= TO_DATE('01/01/2000', 'DD/MM/YYYY');


-- Item 2.c: Conta a quantidade total de alunos nascidos a partir de 01/01/2000.
-- Cláusulas: SELECT (função agregada COUNT(1)), FROM (tabela ALUNOS), WHERE (condição >= TO_DATE).
SELECT COUNT(1)
  FROM ALUNOS
 WHERE DATA_NASCIMENTO >= TO_DATE('01/01/2000', 'DD/MM/YYYY');


-- Item 2.d: Lista o nome de cada aluno e seu respectivo telefone através da junção entre alunos e seus telefones,
-- ordenando o resultado alfabeticamente pelo nome do aluno.
-- Cláusulas: SELECT, FROM, INNER JOIN (tabela TELEFONES_ALUNOS com ON na chave MATRICULA_ALUNO), ORDER BY (A.NOME_ALUNO asc).
SELECT A.NOME_ALUNO
     , T.TELEFONE
  FROM ALUNOS A
 INNER JOIN TELEFONES_ALUNOS T
    ON A.MATRICULA_ALUNO = T.MATRICULA_ALUNO
 ORDER BY A.NOME_ALUNO;


-- Item 2.e: Retorna todos os dados dos alunos que possuem a palavra/trecho 'ANTONIO' em qualquer parte do nome.
-- Cláusulas: SELECT (*), FROM (ALUNOS), WHERE (operador LIKE com curingas '%').
SELECT *
  FROM ALUNOS
 WHERE NOME_ALUNO LIKE '%ANTONIO%';


-- Item 2.f: Retorna todos os dados dos professores que não possuem nenhuma oferta atribuída a eles.
-- Cláusulas: SELECT (*), FROM (PROFESSORES P), WHERE NOT EXISTS (subconsulta correlacionada na tabela OFERTAS).
SELECT *
  FROM PROFESSORES P
 WHERE NOT EXISTS (SELECT 1
                     FROM OFERTAS O
                    WHERE O.MATRICULA_PROFESSOR = P.MATRICULA_PROFESSOR);


-- Item 2.g: Retorna todos os dados das disciplinas cujos códigos sejam 85853 ou 75189.
-- Cláusulas: SELECT (*), FROM (DISCIPLINAS), WHERE (operador IN com lista de códigos).
SELECT *
  FROM DISCIPLINAS
 WHERE CODIGO_DISCIPLINA IN (85853, 75189);


-- Item 2.h: Retorna todos os dados das disciplinas que não possuem nenhuma dependência/pré-requisito.
-- Cláusulas: SELECT (*), FROM (DISCIPLINAS), WHERE (condição IS NULL na coluna CODIGO_DISCIPLINA_DEPENDENCIA).
SELECT *
  FROM DISCIPLINAS
 WHERE CODIGO_DISCIPLINA_DEPENDENCIA IS NULL;


-- Item 2.i: Exibe o horário inicial e final formatados (HH24:MI) e o nome do professor para as ofertas
-- lecionadas pelo professor de matrícula 55125.
-- Cláusulas: SELECT (função TO_CHAR para formatação de horário), FROM (OFERTAS), INNER JOIN (PROFESSORES), WHERE.
SELECT TO_CHAR(O.HORARIO_INICIAL, 'HH24:MI') AS HORARIO_INICIAL
     , TO_CHAR(O.HORARIO_FINAL, 'HH24:MI') AS HORARIO_FINAL
     , P.NOME_PROFESSOR
  FROM OFERTAS O
 INNER JOIN PROFESSORES P
    ON O.MATRICULA_PROFESSOR = P.MATRICULA_PROFESSOR
 WHERE P.MATRICULA_PROFESSOR = 55125;


-- Item 2.j: Retorna os dados completos das matrículas dos alunos (nome do aluno, semestre, horários formatados,
-- dia da semana em minúsculo, nome da disciplina, nome do professor e carga horária), apenas para disciplinas
-- que possuem pré-requisito (dependência não nula), ordenado pelo nome do aluno.
-- Cláusulas: SELECT, FROM (ALUNOS_OFERTAS), múltiplos INNER JOINs (OFERTAS, ALUNOS, PROFESSORES, DISCIPLINAS),
-- WHERE (IS NOT NULL), ORDER BY (A.NOME_ALUNO).
SELECT A.NOME_ALUNO
     , AO.SEMESTRE
     , TO_CHAR(O.HORARIO_INICIAL, 'HH24:MI') AS HORARIO_INICIAL
     , TO_CHAR(O.HORARIO_FINAL, 'HH24:MI') AS HORARIO_FINAL
     , LOWER(O.DIA_SEMANA) AS DIA_SEMANA
     , D.NOME_DISCIPLINA
     , P.NOME_PROFESSOR
     , D.CARGA_HORARIA
  FROM ALUNOS_OFERTAS AO
 INNER JOIN OFERTAS O
    ON AO.CODIGO_OFERTA = O.CODIGO_OFERTA
 INNER JOIN ALUNOS A
    ON AO.MATRICULA_ALUNO = A.MATRICULA_ALUNO
 INNER JOIN PROFESSORES P
    ON O.MATRICULA_PROFESSOR = P.MATRICULA_PROFESSOR
 INNER JOIN DISCIPLINAS D
    ON O.CODIGO_DISCIPLINA = D.CODIGO_DISCIPLINA
 WHERE D.CODIGO_DISCIPLINA_DEPENDENCIA IS NOT NULL
 ORDER BY A.NOME_ALUNO;


-- Item 2.k: Realiza um auto-relacionamento (self join) na tabela DISCIPLINAS para exibir o nome da disciplina
-- pré-requisito ao lado do nome da disciplina dependente, ordenando pelas duas primeiras colunas da projeção.
-- Cláusulas: SELECT, FROM (DISCIPLINAS D), INNER JOIN (DISCIPLINAS DD relacionando a chave primária com a estrangeira), ORDER BY 1, 2.
SELECT D.NOME_DISCIPLINA AS PRE_REQUISITO
     , DD.NOME_DISCIPLINA AS DISCIPLINA
  FROM DISCIPLINAS D
 INNER JOIN DISCIPLINAS DD
    ON D.CODIGO_DISCIPLINA = DD.CODIGO_DISCIPLINA_DEPENDENCIA
 ORDER BY 1, 2;


-- Item 2.l: Agrupa as ofertas por professor e contabiliza a quantidade total de disciplinas ofertadas por cada um,
-- ordenando o resultado pelo nome do professor.
-- Cláusulas: SELECT (COUNT(1), nome), FROM (OFERTAS), INNER JOINs (DISCIPLINAS, PROFESSORES), GROUP BY (P.NOME_PROFESSOR), ORDER BY.
SELECT COUNT(1) AS TOTAL_DISCIPLINAS
     , P.NOME_PROFESSOR
  FROM OFERTAS O
 INNER JOIN DISCIPLINAS D
    ON O.CODIGO_DISCIPLINA = D.CODIGO_DISCIPLINA
 INNER JOIN PROFESSORES P
    ON O.MATRICULA_PROFESSOR = P.MATRICULA_PROFESSOR
 GROUP BY P.NOME_PROFESSOR
 ORDER BY P.NOME_PROFESSOR;