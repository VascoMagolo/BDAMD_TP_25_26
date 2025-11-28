SELECT
    W.name AS Nome_Armazem,
    PZ.designation AS Zona_Fisica
FROM
    Warehouse W
        JOIN PhysicalZone PZ ON W.warehouse_id = PZ.warehouse_id
        JOIN Stock S ON PZ.physical_zone_id = S.physical_zone_id
WHERE
    S.product_ref = (
        SELECT TOP 1 product_ref
        FROM SalesOrderLine
        GROUP BY product_ref
        ORDER BY SUM(quantity) DESC
    )
  AND S.quantity > 0;