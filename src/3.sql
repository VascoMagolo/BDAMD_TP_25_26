SELECT
    gz.designation AS ZonaGeografica,
    c.name         AS NomeCliente,
    (
        SELECT SUM(sol.quantity * p.current_sell_price)
        FROM SalesOrder     so
        JOIN SalesOrderLine sol ON so.order_id   = sol.order_id
        JOIN Product        p   ON sol.product_ref = p.product_ref
        WHERE so.customer_id = c.customer_id
          AND so.status      = 'Processada'
    ) AS TotalVendido
FROM Customer c
JOIN GeographicZone gz ON c.id_geo_zone = gz.id_geo_zone
WHERE EXISTS (
    SELECT 1
    FROM SalesOrder so2
    WHERE so2.customer_id = c.customer_id
      AND so2.status      = 'Processada'
)
ORDER BY gz.designation, TotalVendido DESC;
GO
SELECT
    e.employee_id      AS IdVendedor,
    e.name             AS NomeVendedor,
    gz.designation     AS ZonaGeografica,
    v.AnoContabilizado,
    v.TotalVendas
FROM Employee e
JOIN GeographicZone gz ON e.id_geo_zone = gz.id_geo_zone
JOIN (
    SELECT
        so.salesperson_id,
        YEAR(so.registration_date) AS AnoContabilizado,
        SUM(sol.quantity * p.current_sell_price) AS TotalVendas
    FROM SalesOrder     so
    JOIN SalesOrderLine sol ON so.order_id   = sol.order_id
    JOIN Product        p   ON sol.product_ref = p.product_ref
    WHERE so.status = 'Processada'
    GROUP BY so.salesperson_id, YEAR(so.registration_date)
) v
    ON v.salesperson_id = e.employee_id
WHERE v.AnoContabilizado = 2019
  AND e.category = 'Vendedor'
ORDER BY TotalVendas DESC;
GO
SELECT
    w.warehouse_id    AS IdArmazem,
    w.name            AS NomeArmazem,
    SUM(t.hours_used) AS HorasTransporte
FROM Warehouse       w
JOIN PhysicalZone    pz  ON w.warehouse_id        = pz.warehouse_id
JOIN DispatchNoteLine dnl ON pz.physical_zone_id  = dnl.physical_zone_id
JOIN Transport        t   ON dnl.dispatch_id      = t.dispatch_id
GROUP BY w.warehouse_id, w.name
HAVING SUM(t.hours_used) >
(
    SELECT AVG(TotalHoras)
    FROM (
        SELECT SUM(t2.hours_used) AS TotalHoras
        FROM Transport t2
        GROUP BY t2.dispatch_id
    ) X
)
ORDER BY HorasTransporte DESC;
GO
