
-- QUERY 1: Total Vendido por Cliente e Zona Geográfica, apenas para Clientes com Encomendas Processadas
SELECT
    gz.designation AS ZonaGeografica, -- 1. Seleciona a designação da Zona Geográfica para agrupar.
    c.name         AS NomeCliente,    -- 2. Seleciona o nome do Cliente.
    (
        -- Esta subconsulta calcula o valor total vendido (quantidade * preço)
        -- e é executada para cada cliente na consulta principal.
        SELECT SUM(sol.quantity * p.current_sell_price)
        FROM SalesOrder     so
                 JOIN SalesOrderLine sol ON so.order_id   = sol.order_id
                 JOIN Product        p   ON sol.product_ref = p.product_ref
        WHERE so.customer_id = c.customer_id -- Associa a encomenda (so) ao cliente (c) da linha atual.
          AND so.status      = 'Processada'  -- Filtra apenas as encomendas concluídas/processadas.
    ) AS TotalVendido -- O resultado da subconsulta é apresentado como a coluna 'TotalVendido'.
FROM Customer c
         JOIN GeographicZone gz ON c.id_geo_zone = gz.id_geo_zone -- JUNÇÃO: Liga o Cliente à sua respetiva Zona Geográfica.
WHERE EXISTS (
    -- Utiliza EXISTS
    -- para garantir que o cliente SÓ é listado se tiver pelo menos uma 'SalesOrder' com o status 'Processada'.
    SELECT 1
    FROM SalesOrder so2
    WHERE so2.customer_id = c.customer_id
      AND so2.status      = 'Processada'
)
ORDER BY gz.designation, TotalVendido DESC; --Ordena primeiro pela Zona Geográfica, depois pelo total vendido (do maior para o menor).
GO


-- Calcula o total de vendas de cada vendedor, filtrando para o ano de 2019.
SELECT
    e.employee_id      AS IdVendedor,
    e.name             AS NomeVendedor,
    gz.designation     AS ZonaGeografica,
    v.AnoContabilizado,
    v.TotalVendas      -- Total de vendas (calculado na Tabela Derivada 'v').
FROM Employee e
         JOIN GeographicZone gz ON e.id_geo_zone = gz.id_geo_zone -- Liga o Empregado à sua Zona Geográfica.
         JOIN (
    -- Agrega todos os dados de vendas numa tabela derivada 'v',
    -- calculando o total vendido e por vendedor e ano.
    SELECT
        so.salesperson_id,
        YEAR(so.registration_date) AS AnoContabilizado,                       -- Extrai o ano de registo da encomenda.
        SUM(sol.quantity * p.current_sell_price) AS TotalVendas               -- Calcula o total vendido por ano/vendedor.
    FROM SalesOrder     so
             JOIN SalesOrderLine sol ON so.order_id   = sol.order_id
             JOIN Product        p   ON sol.product_ref = p.product_ref
    WHERE so.status = 'Processada' -- Considera apenas vendas concluídas.
    GROUP BY so.salesperson_id, YEAR(so.registration_date) -- Agrupa os resultados, somando as vendas para cada combinação de vendedor e ano.
) v
              ON v.salesperson_id = e.employee_id -- Liga a tabela agregada de Vendas (v) ao Empregado (e) para obter nome e zona.
WHERE v.AnoContabilizado = 2019 -- Restringe os resultados da tabela agregada 'v' apenas ao ano 2019.
  AND e.category = 'Vendedor'  -- Garante que apenas empregados na categoria 'Vendedor' são considerados.
ORDER BY TotalVendas DESC;     -- Lista os vendedores por ordem decrescente de total de vendas.
GO



-- Identifica armazéns cujo total de horas de transporte (associadas às
--           suas mercadorias) é superior à média de horas por transporte
--           em toda a empresa.
SELECT
    w.warehouse_id    AS IdArmazem,
    w.name            AS NomeArmazem,
    SUM(t.hours_used) AS HorasTransporte -- 1. calcula o total de horas de transporte de TODAS as Notas de Saída relacionadas com este Armazém.
FROM Warehouse       w
    -- Liga o Armazém ao Transporte (caminho: Armazém -> Zona Física -> Linha Nota Saída -> Transporte)
         JOIN PhysicalZone    pz  ON w.warehouse_id        = pz.warehouse_id
         JOIN DispatchNoteLine dnl ON pz.physical_zone_id  = dnl.physical_zone_id
         JOIN Transport        t   ON dnl.dispatch_id      = t.dispatch_id
GROUP BY w.warehouse_id, w.name -- AGRUPAMENTO: Agrupa os dados, calculando o SUM(t.hours_used) para cada Armazém.
HAVING SUM(t.hours_used) > -- FILTRO AVANÇADO (HAVING): Compara o total de horas do Armazém com a Média Geral calculada abaixo.
       (
           -- Calcula a Média (AVG) dos totais de horas.
           SELECT AVG(TotalHoras)
           FROM (
                    -- Calcula o total de horas de transporte para CADA 'dispatch_id' (transporte individual).
                    SELECT SUM(t2.hours_used) AS TotalHoras
                    FROM Transport t2
                    GROUP BY t2.dispatch_id -- Gera uma lista de valores (TotalHoras) onde cada valor é o tempo de um transporte.
                ) X -- calcula então a média destes valores (AVG(TotalHoras)).
       )
ORDER BY HorasTransporte DESC; -- Lista os armazéns que mais contribuem para o esforço logístico, do maior para o menor.
GO