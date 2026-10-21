--a)
SELECT * FROM clientes;

--b)
SELECT 	nome_produto FROM produtos;
--c)
SELECT DISTINCT cidade,UF ,cep FROM clientes;
--d)
SELECT * FROM PEDIDOS
	WHERE codigo_cliente = 4
	AND valor_total > 1000;
--e)
