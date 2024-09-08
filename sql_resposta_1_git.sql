SELECT tbProduto.NomeProduto,  -- Seleciona o nome do produto para ser exibido no resultado
       SUM(tbPedidos.QuantidadeProdutos) AS TotalComprado  -- Calcula a soma total das quantidades compradas de cada produto e nomeia o resultado como "TotalComprado"
FROM tbPedidos  -- Define a tabela "tbPedidos" como a principal para a consulta, onde estão os registros de pedidos
JOIN tbClientes ON tbPedidos.idCliente = tbClientes.IdCliente  -- Realiza uma junção com a tabela "tbClientes" para associar cada pedido ao cliente correspondente
JOIN tbProduto ON tbPedidos.idProduto = tbProduto.idProduto  -- Realiza uma junção com a tabela "tbProduto" para associar cada pedido ao produto correspondente
WHERE tbClientes.DataNascimento <= DATE_ADD(CURDATE(), INTERVAL -30 YEAR)  -- Filtra os clientes que têm 30 anos ou mais (a data de nascimento deve ser menor ou igual à data de 30 anos atrás)
AND tbPedidos.DataPedido BETWEEN '2024-05-01' AND '2024-05-31'  -- Filtra os pedidos feitos entre 1º de maio de 2024 e 31 de maio de 2024
GROUP BY tbProduto.NomeProduto  -- Agrupa os resultados por nome de produto para calcular o total comprado por produto
ORDER BY TotalComprado DESC  -- Ordena os resultados pela soma total das quantidades compradas (TotalComprado), em ordem decrescente
LIMIT 10;  -- Limita o resultado aos 10 produtos mais comprados