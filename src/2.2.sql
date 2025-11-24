SELECT W.name
FROM Warehouse W
WHERE NOT EXISTS (
    SELECT S_Alvo.product_ref
    FROM Stock S_Alvo
             JOIN PhysicalZone PZ_Alvo ON S_Alvo.physical_zone_id = PZ_Alvo.physical_zone_id
    WHERE PZ_Alvo.warehouse_id = (
        SELECT TOP 1 warehouse_id
        FROM Employee
        GROUP BY warehouse_id
        ORDER BY COUNT(*) DESC
    )
    EXCEPT
    SELECT S_Atual.product_ref
    FROM Stock S_Atual
             JOIN PhysicalZone PZ_Atual ON S_Atual.physical_zone_id = PZ_Atual.physical_zone_id
    WHERE PZ_Atual.warehouse_id = W.warehouse_id
);