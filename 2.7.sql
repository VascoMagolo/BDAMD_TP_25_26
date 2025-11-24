SELECT
    P.name AS Produto,
    MONTH(SO.registration_date) AS Mes,
    SUM(SOL.quantity) AS Volume_Mensal_Encomendado
FROM
    Product P
        JOIN SalesOrderLine SOL ON P.product_ref = SOL.product_ref
        JOIN SalesOrder SO ON SOL.order_id = SO.order_id
WHERE
    YEAR(SO.registration_date) = 2019
  AND P.product_ref IN (
    SELECT S.product_ref
    FROM Stock S
             JOIN PhysicalZone PZ ON S.physical_zone_id = PZ.physical_zone_id
             JOIN WarehouseStockDefinition WSD
                  ON PZ.warehouse_id = WSD.warehouse_id
                      AND S.product_ref = WSD.product_ref
    GROUP BY S.product_ref, PZ.warehouse_id, WSD.min_stock
    HAVING SUM(S.quantity) >= (WSD.min_stock * 1.5)
)
GROUP BY
    P.product_ref, P.name, MONTH(SO.registration_date);