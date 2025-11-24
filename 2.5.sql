SELECT
    W.name
FROM
    Warehouse W
        JOIN Employee E ON W.warehouse_id = E.warehouse_id
        JOIN SalesOrder SO ON E.employee_id = SO.salesperson_id
WHERE
    SO.registration_date BETWEEN '2018-03-01' AND '2018-10-15'
  AND SO.status = 'Pendente'
GROUP BY
    W.warehouse_id, W.name
HAVING
    COUNT(SO.order_id) > ALL (
        SELECT COUNT(SO2.order_id)
        FROM SalesOrder SO2
                 JOIN Employee E2 ON SO2.salesperson_id = E2.employee_id
                 JOIN Warehouse W2 ON E2.warehouse_id = W2.warehouse_id
                 JOIN GeographicZone GZ ON W2.id_geo_zone = GZ.id_geo_zone
        WHERE GZ.designation LIKE '%Porto%'
          AND SO2.registration_date BETWEEN '2018-03-01' AND '2018-10-15'
          AND SO2.status = 'Pendente'
        GROUP BY W2.warehouse_id
    );
