SELECT
    PZ.designation AS Nome_Zona,
    W.warehouse_id AS Codigo_Armazem
FROM
    PhysicalZone PZ
        JOIN Warehouse W ON PZ.warehouse_id = W.warehouse_id
        JOIN Stock S ON PZ.physical_zone_id = S.physical_zone_id
GROUP BY
    PZ.physical_zone_id, PZ.designation, W.warehouse_id, PZ.capacity_volume
HAVING
    SUM(S.quantity * 1) = PZ.capacity_volume
ORDER BY
    W.warehouse_id ASC,
    PZ.designation DESC;