

-- a. Selecionar todas as colunas de todos os clientes. (40 linhas)
SELECT *
  FROM CLIENTES;


-- b. Selecionar somente a coluna nome de todos os produtos. (47 linhas)
SELECT NOME_PRODUTO
  FROM PRODUTOS;


-- c. Selecionar as colunas "cidade", "estado" e "CEP" de todos os clientes eliminando as redundâncias. (32 linhas)
SELECT DISTINCT CIDADE
     , UF AS ESTADO
     , CEP
  FROM CLIENTES;


-- d. Selecionar todos os pedidos feitos pelo cliente cujo código seja = 04 e cujo valor total bruto seja maior que 10000. (5 linhas)
SELECT *
  FROM PEDIDOS
 WHERE CODIGO_CLIENTE = 4
   AND VALOR_BRUTO > 10000;


-- e. Selecionar todos os pedidos cujo valor total bruto seja menor que 100 ou maior que 5000 e a data esteja compreendida entre 13/01/2007 e 14/01/2007. (9 linhas)
-- Dica: pesquise por TO_DATE e pela cláusula BETWEEN
SELECT *
  FROM PEDIDOS
 WHERE (VALOR_BRUTO < 100 OR VALOR_BRUTO > 5000)
   AND TRUNC(DATA_PEDIDO) BETWEEN TO_DATE('13/01/2007', 'DD/MM/YYYY') AND TO_DATE('14/01/2007', 'DD/MM/YYYY');


-- f. Selecionar todos os clientes cujo código NÃO esteja compreendido entre 05 e 25. (19 linhas)
SELECT *
  FROM CLIENTES
 WHERE CODIGO_CLIENTE NOT BETWEEN 5 AND 25;


-- g. Selecionar todos os produtos cujo nome possua a primeira letra = M, que possuam a string 'AN' em qualquer posição do nome, mas que terminem com a letra 'A'. (2 linhas)
-- Dica: pesquise por LIKE
SELECT *
  FROM PRODUTOS
 WHERE UPPER(NOME_PRODUTO) LIKE 'M%AN%A';


-- h. Selecionar todos os produtos que comecem com a letra MA e tenha exatamente 6 caracteres a mais. (3 linhas)
SELECT *
  FROM PRODUTOS
 WHERE UPPER(NOME_PRODUTO) LIKE 'MA______';


-- i. Selecionar todos os produtos cujo nome possua a string 'ACA' a partir da terceira posição. (1 linha)
SELECT *
  FROM PRODUTOS
 WHERE UPPER(NOME_PRODUTO) LIKE '__ACA%';


-- j. Selecionar todos os Produtos cujo Nome possua a string 'A_P' como parte do nome do produto, em qualquer posição do nome. (1 linha)
-- Dica: pesquise por ESCAPE
SELECT *
  FROM PRODUTOS
 WHERE UPPER(NOME_PRODUTO) LIKE '%A\_P%' ESCAPE '\';


-- k. Selecionar todos os clientes cuja UF seja 'MG' ou 'ES'. (8 linhas)
-- Dica: pesquise por IN e NOT IN
SELECT *
  FROM CLIENTES
 WHERE UF IN ('MG', 'ES');


-- l. Selecionar todos os clientes cujo estado NÃO seja RJ nem SP. (25 linhas)
SELECT *
  FROM CLIENTES
 WHERE UF NOT IN ('RJ', 'SP');



-- =============================================================================
-- NÍVEL 2 - JOINS
-- =============================================================================

-- m. Selecionar o nome, o preço e a descrição da unidade de estoque dos produtos cujo preço seja menor que 20 e a descrição da unidade de estoque seja 'KILOGRAMA' ou 'LITRO', incluindo os produtos cujo preço seja nulo, usando aliases para colunas e tabelas. (14 linhas)
SELECT P.NOME_PRODUTO AS NOME
     , P.PRECO_PRODUTO AS PRECO
     , U.DESCRICAO_UNIDADE_MEDIDA AS UNIDADE_ESTOQUE
  FROM PRODUTOS P,
 INNER JOIN UNIDADE_MEDIDA U
    ON P.CODIGO_UNIDADE_MEDIDA = U.CODIGO_UNIDADE_MEDIDA
 WHERE (P.PRECO_PRODUTO < 20 OR P.PRECO_PRODUTO IS NULL)
   AND UPPER(U.DESCRICAO_UNIDADE_MEDIDA) IN ('KILOGRAMA', 'LITRO');


-- n. Mostrar código do pedido, código e nome do cliente, código e nome do produto e descrição da unidade de estoque do produto. (180 linhas)
SELECT PED.CODIGO_PEDIDO
     , CLI.CODIGO_CLIENTE
     , CLI.NOME_CLIENTE
     , PRO.CODIGO_PRODUTO
     , PRO.NOME_PRODUTO
     , UNI.DESCRICAO_UNIDADE_MEDIDA
  FROM PEDIDOS PED
 INNER JOIN CLIENTES CLI
    ON PED.CODIGO_CLIENTE = CLI.CODIGO_CLIENTE
 INNER JOIN ITENS_PEDIDOS ITE
    ON PED.CODIGO_PEDIDO = ITE.CODIGO_PEDIDO
 INNER JOIN PRODUTOS PRO
    ON ITE.CODIGO_PRODUTO = PRO.CODIGO_PRODUTO
 INNER JOIN UNIDADE_MEDIDA UNI
    ON PRO.CODIGO_UNIDADE_MEDIDA = UNI.CODIGO_UNIDADE_MEDIDA;


-- o. Selecionar o código, o nome, o preço atual, e uma nova coluna exibindo o preço com um aumento 30% de todos os produtos que já tenham sido comprados, colocando ALIASES para coluna e tabela. (39 linhas)
-- Dica: Se você obteve um resultado superior a 39 linhas, analise a forma que fez a restrição sobre os produtos que já tenham sido comprados, experimente uma maneira diferente.
SELECT DISTINCT P.CODIGO_PRODUTO AS CODIGO
     , P.NOME_PRODUTO AS NOME
     , P.PRECO_PRODUTO AS PRECO_ATUAL
     , ROUND(P.PRECO_PRODUTO * 1.30, 2) AS PRECO_COM_AUMENTO_30
  FROM PRODUTOS P
 INNER JOIN ITENS_PEDIDOS I
    ON P.CODIGO_PRODUTO = I.CODIGO_PRODUTO;



-- =============================================================================
-- NÍVEL 3 - FUNÇÕES AGREGADAS
-- =============================================================================

-- p. Selecionar código do cliente, nome do cliente e valor total comprado por cada cliente, classificando por ordem descendente de valor total comprado usando aliases. (18 linhas)
-- Dica: pesquise por SUM e GROUP BY, ORDER BY DESC
SELECT C.CODIGO_CLIENTE AS CODIGO
     , C.NOME_CLIENTE AS NOME
     , SUM(P.VALOR_LIQUIDO) AS VALOR_TOTAL_COMPRADO
  FROM CLIENTES C
 INNER JOIN PEDIDOS P
    ON C.CODIGO_CLIENTE = P.CODIGO_CLIENTE
 GROUP BY C.CODIGO_CLIENTE, C.NOME_CLIENTE
 ORDER BY VALOR_TOTAL_COMPRADO DESC;


-- q. Contar a quantidade de pedidos feitos para o cliente 05. (Resultado: 2)

SELECT COUNT(1) AS QUANTIDADE_PEDIDOS
  FROM PEDIDOS
 WHERE CODIGO_CLIENTE = 5;


-- r. Obter da tabela de pedidos o menor, o maior, a média e o somatório dos valores vendidos. (Resultado: 15, 22540, 4898,7069..., 318416)
-- Dica 1: pesquise por MIN, MAX e AVG
-- Dica 2: É comum o resultado de uma média de um valor com muitas casas decimais. Podemos melhorar a exibição desse resultado aplicação a função ROUND. Ex.: ROUND(valor, numero de casas decimais).
SELECT MIN(VALOR_LIQUIDO) AS MENOR_VALOR
     , MAX(VALOR_LIQUIDO) AS MAIOR_VALOR
     , ROUND(AVG(VALOR_LIQUIDO), 4) AS MEDIA_VALOR
     , SUM(VALOR_LIQUIDO) AS SOMATORIO_VALOR
  FROM PEDIDOS;


-- s. Mostrar o código de cada produto e a média de quantidade por produto vendido. (39 linhas)
-- Dica: Ordene o resultado por código do produto para melhor visualizar o resultado
SELECT CODIGO_PRODUTO
     , TRUNC(ROUND(AVG(QUANTIDADE), 2)) AS MEDIA_QUANTIDADE
  FROM ITENS_PEDIDOS
 GROUP BY CODIGO_PRODUTO
 ORDER BY CODIGO_PRODUTO;


-- t. Mostrar o código de cada Unidade Federativa e a quantidade de clientes de cada unidade que já tenham feito pedido. (Resultado: RJ=5, ES=3, SP=3, BA=3, RS=2, PR=1, SC=1)
-- Dica: Se você obteve um resultado diferente do que está descrito acima (possivelmente com valores maiores), observe a forma que fez a restrição para os clientes que já fizeram pedidos.
SELECT C.UF
     , (COUNT(DISTINCT C.CODIGO_CLIENTE)) AS QUANTIDADE_CLIENTES
  FROM CLIENTES C
 INNER JOIN PEDIDOS P
    ON C.CODIGO_CLIENTE = P.CODIGO_CLIENTE
 GROUP BY C.UF
 ORDER BY QUANTIDADE_CLIENTES DESC;


-- u. Mostrar o código do cliente, e a média de valor comprado por cada cliente, somente para os clientes cuja média for maior que 8000. (3 linhas)
SELECT CODIGO_CLIENTE
     , ROUND(AVG(VALOR_LIQUIDO), 2) AS MEDIA_VALOR_COMPRADO
  FROM PEDIDOS
 GROUP BY CODIGO_CLIENTE
HAVING AVG(VALOR_LIQUIDO) > 8000;


-- v. Mostrar, o código, nome dos produtos e valor total vendido por produto, selecionando somente os produtos cujo valor total vendido for > 800, classificando por valor total vendido descendente. (27 linhas)
SELECT P.CODIGO_PRODUTO
     , P.NOME_PRODUTO
     , SUM(I.VALOR_TOTAL_ITEM) AS TOTAL_VENDIDO
  FROM PRODUTOS P
 INNER JOIN ITENS_PEDIDOS I
    ON P.CODIGO_PRODUTO = I.CODIGO_PRODUTO
 GROUP BY P.CODIGO_PRODUTO, P.NOME_PRODUTO
HAVING SUM(I.VALOR_TOTAL_ITEM) > 800
 ORDER BY TOTAL_VENDIDO DESC;


-- w. Mostrar os dados dos produtos para os quais ainda não foi feito pedido. (8 linhas)
-- Dica: experimente as condicionais IS NULL e IS NOT NULL
SELECT P.*
  FROM PRODUTOS P
  LEFT JOIN ITENS_PEDIDOS I
    ON P.CODIGO_PRODUTO = I.CODIGO_PRODUTO
 WHERE I.CODIGO_PRODUTO IS NULL;


-- x. Mostrar código, nome e preço dos produtos cujo preço do produto seja maior que a média de preço de todos os produtos. (19 linhas)
SELECT CODIGO_PRODUTO
     , NOME_PRODUTO
     , PRECO_PRODUTO
  FROM PRODUTOS
 WHERE PRECO_PRODUTO > (SELECT AVG(PRECO_PRODUTO) FROM PRODUTOS);


-- y. Mostrar código, nome e preço dos produtos cujo preço seja maior que a média de preço de todos os produtos e a unidade de estoque do produto seja 'kg' ou 'um' ou 'l' e tenha a letra "h" em qualquer parte do nome do produto. (1 linha – chiclete)
SELECT P.CODIGO_PRODUTO
     , P.NOME_PRODUTO
     , P.PRECO_PRODUTO
  FROM PRODUTOS P
 WHERE P.PRECO_PRODUTO > (SELECT AVG(PRECO_PRODUTO) FROM PRODUTOS)
   AND LOWER(P.CODIGO_UNIDADE_MEDIDA) IN ('kg', 'um', 'l')
   AND LOWER(P.NOME_PRODUTO) LIKE '%h%';



-- =============================================================================
-- NÍVEL 4 - SUBQUERIES
-- =============================================================================

-- z. Mostrar os dados dos clientes que compraram no dia 13/01/2007 e que não compraram no dia 02/01/2007. (3 linhas – clientes 7, 8 e 10)
-- Dica: Se você encontrou 5 linhas, o cliente 1 apareceu no resultado, observe como está fazendo a restrição sobre a data 02/01/2007. Lembre-se das cláusulas IN e NOT IN.
SELECT *
  FROM CLIENTES
 WHERE CODIGO_CLIENTE IN (
       SELECT CODIGO_CLIENTE
         FROM PEDIDOS
        WHERE TRUNC(DATA_PEDIDO) = TO_DATE('13/01/2007', 'DD/MM/YYYY')
 )
   AND CODIGO_CLIENTE NOT IN (
       SELECT CODIGO_CLIENTE
         FROM PEDIDOS
        WHERE TRUNC(DATA_PEDIDO) = TO_DATE('02/01/2007', 'DD/MM/YYYY')
 );


-- aa. Mostrar os dados dos produtos que nunca foram comprados por clientes que moram no estado do 'Rio de Janeiro'. (30 linhas)
SELECT *
  FROM PRODUTOS
 WHERE CODIGO_PRODUTO NOT IN (
       SELECT I.CODIGO_PRODUTO
         FROM ITENS_PEDIDOS I
        INNER JOIN PEDIDOS PED
           ON I.CODIGO_PEDIDO = PED.CODIGO_PEDIDO
        INNER JOIN CLIENTES CLI
           ON PED.CODIGO_CLIENTE = CLI.CODIGO_CLIENTE
        INNER JOIN UF U
           ON CLI.UF = U.UF
        WHERE UPPER(U.DESCRICAO_UF) = 'RIO DE JANEIRO'
           OR CLI.UF = 'RJ'
 );


-- bb. Listar o nome e telefone dos clientes que já compraram 'arroz', mas que nunca compraram 'feijao'. (4 linhas, clientes 1, 4, 7 e 8)
SELECT CLI.NOME_CLIENTE
     , CLI.TELEFONE
  FROM CLIENTES CLI
 WHERE CLI.CODIGO_CLIENTE IN (
       SELECT PED.CODIGO_CLIENTE
         FROM PEDIDOS PED
        INNER JOIN ITENS_PEDIDOS ITE
           ON PED.CODIGO_PEDIDO = ITE.CODIGO_PEDIDO
        INNER JOIN PRODUTOS PRO
           ON ITE.CODIGO_PRODUTO = PRO.CODIGO_PRODUTO
        WHERE UPPER(PRO.NOME_PRODUTO) LIKE '%ARROZ%'
 )
   AND CLI.CODIGO_CLIENTE NOT IN (
       SELECT PED.CODIGO_CLIENTE
         FROM PEDIDOS PED
        INNER JOIN ITENS_PEDIDOS ITE
           ON PED.CODIGO_PEDIDO = ITE.CODIGO_PEDIDO
        INNER JOIN PRODUTOS PRO
           ON ITE.CODIGO_PRODUTO = PRO.CODIGO_PRODUTO
        WHERE UPPER(PRO.NOME_PRODUTO) LIKE '%FEIJAO%'
           OR UPPER(PRO.NOME_PRODUTO) LIKE '%FEIJÃO%'
 );


-- cc. Listar o nome do cliente, o telefone do cliente e a descrição do estado onde o cliente está localizado, de todos os clientes que nunca compraram nada ou que o total comprado do cliente for menor que o total geral comprado no dia 01/01/2007, ordenando por nome de cliente ascendente. (31 linhas)
SELECT CLI.NOME_CLIENTE
     , CLI.TELEFONE
     , U.DESCRICAO_UF
  FROM CLIENTES CLI
 INNER JOIN UF U
    ON CLI.UF = U.UF
 WHERE CLI.CODIGO_CLIENTE NOT IN (
       SELECT CODIGO_CLIENTE
         FROM PEDIDOS
        WHERE CODIGO_CLIENTE IS NOT NULL
 )
    OR (
       SELECT SUM(P.VALOR_LIQUIDO)
         FROM PEDIDOS P
        WHERE P.CODIGO_CLIENTE = CLI.CODIGO_CLIENTE
    ) < (
       SELECT SUM(P2.VALOR_LIQUIDO)
         FROM PEDIDOS P2
        WHERE TRUNC(P2.DATA_PEDIDO) = TO_DATE('01/01/2007', 'DD/MM/YYYY')
    )
 ORDER BY CLI.NOME_CLIENTE ASC;
