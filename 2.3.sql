SELECT TOP 1
    CASE
        WHEN SUM(S.quantity) IS NULL OR SUM(S.quantity) = 0 THEN 'ZONA FISICA SEM STOCK'
        ELSE PZ.designation
        END AS Identificacao_Zona
FROM
    Warehouse W
        JOIN PhysicalZone PZ ON W.warehouse_id = PZ.warehouse_id
        LEFT JOIN Stock S ON PZ.physical_zone_id = S.physical_zone_id
WHERE
    W.name = 'XPTO'
GROUP BY
    PZ.physical_zone_id, PZ.designation
ORDER BY
    SUM(S.quantity) DESC;