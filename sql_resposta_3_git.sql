SELECT tbProduto.GrupoProduto,  -- Seleciona o grupo de produto para exibir no resultado
       FORMAT(AVG(tbProduto.PrecoProduto * tbPedidos.QuantidadeProdutos), 2) AS TicketMedio  -- Calcula a média do valor total gasto no primeiro pedido, e formata o resultado com 2 casas decimais, nomeando o campo como "TicketMedio"
FROM tbPedidos  -- Define "tbPedidos" como a tabela principal, que contém os registros dos pedidos
JOIN tbClientes ON tbPedidos.idCliente = tbClientes.IdCliente  -- Faz a junção com a tabela "tbClientes" para associar os pedidos aos respectivos clientes
JOIN tbProduto ON tbPedidos.idProduto = tbProduto.idProduto  -- Faz a junção com a tabela "tbProduto" para associar os pedidos aos respectivos produtos
WHERE tbPedidos.idPedido IN (  -- Aplica um filtro para considerar apenas o primeiro pedido de cada cliente
    SELECT MIN(p.idPedido)  -- Seleciona o menor "idPedido" (ou seja, o primeiro pedido) para cada cliente
    FROM tbPedidos p  -- Define "tbPedidos" como a tabela de origem para a subconsulta
    GROUP BY p.idCliente  -- Agrupa por cliente, garantindo que o "MIN(idPedido)" pegue o primeiro pedido de cada cliente
)
GROUP BY tbProduto.GrupoProduto;  -- Agrupa os resultados pelo grupo de produto, para calcular o ticket médio por grupo