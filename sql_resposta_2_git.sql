-- Definimos uma CTE (Common Table Expression) chamada "PedidosPorMes"
WITH PedidosPorMes AS (
    -- Seleciona o CPF do cliente, o grupo de produto, o mês e ano do pedido, e conta o total de pedidos por mês para cada cliente e grupo de produto
    SELECT 
        tbClientes.Cpf,  -- Seleciona o CPF do cliente
        tbProduto.GrupoProduto,  -- Seleciona o grupo do produto
        DATE_FORMAT(tbPedidos.DataPedido, '%Y-%m') AS MesAno,  -- Formata a data do pedido para o formato "ano-mês" (YYYY-MM)
        COUNT(tbPedidos.idPedido) AS TotalPedidos  -- Conta o total de pedidos para cada combinação de cliente, grupo de produto e mês
    FROM tbPedidos  -- A tabela principal é tbPedidos, onde estão registrados os pedidos
    JOIN tbClientes ON tbPedidos.idCliente = tbClientes.IdCliente  -- Faz a junção com a tabela tbClientes para associar cada pedido ao cliente
    JOIN tbProduto ON tbPedidos.idProduto = tbProduto.idProduto  -- Faz a junção com a tabela tbProduto para associar cada pedido ao produto
    WHERE tbPedidos.DataPedido BETWEEN '2024-01-01' AND '2024-12-31'  -- Filtra os pedidos feitos durante o ano de 2024
    GROUP BY tbClientes.Cpf, tbProduto.GrupoProduto, DATE_FORMAT(tbPedidos.DataPedido, '%Y-%m')  -- Agrupa os resultados por cliente (CPF), grupo de produto e mês
    HAVING COUNT(tbPedidos.idPedido) >= 5  -- Filtra para incluir apenas os clientes que fizeram 5 ou mais pedidos de um mesmo grupo de produto em um determinado mês
),

-- Definimos outra CTE chamada "MesesValidos"
MesesValidos AS (
    -- Seleciona o CPF do cliente, o grupo de produto e conta o número total de meses distintos em que o cliente fez 5 ou mais pedidos para cada grupo de produto
    SELECT 
        Cpf,  -- Seleciona o CPF do cliente
        GrupoProduto,  -- Seleciona o grupo de produto
        COUNT(DISTINCT MesAno) AS TotalMeses  -- Conta o número de meses distintos em que o cliente fez 5 ou mais pedidos de um grupo de produto
    FROM PedidosPorMes  -- Usa a CTE "PedidosPorMes" como fonte de dados
    GROUP BY Cpf, GrupoProduto  -- Agrupa por cliente (CPF) e grupo de produto
)

-- A consulta final que seleciona os clientes e os grupos de produto
SELECT 
    Cpf,  -- Seleciona o CPF do cliente
    GrupoProduto  -- Seleciona o grupo de produto
FROM MesesValidos  -- Usa a CTE "MesesValidos" como fonte de dados
WHERE TotalMeses = 12  -- Filtra para clientes que fizeram 5 ou mais pedidos em todos os 12 meses do ano para um determinado grupo de produto
ORDER BY Cpf, GrupoProduto;  -- Ordena os resultados por CPF e grupo de produto