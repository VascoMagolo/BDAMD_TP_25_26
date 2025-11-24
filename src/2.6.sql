SELECT DISTINCT
    Emp.employee_id,
    Emp.name,
    GZ.designation AS zona_geografica
FROM
    Employee Emp
        JOIN GeographicZone GZ ON Emp.id_geo_zone = GZ.id_geo_zone
        JOIN SalesOrder SO ON Emp.employee_id = SO.salesperson_id
        JOIN SalesOrderLine SOL ON SO.order_id = SOL.order_id
        JOIN PriceHistory PH ON SOL.product_ref = PH.product_ref
WHERE
    YEAR(SO.registration_date) = 2015
  AND SO.registration_date BETWEEN PH.start_date AND ISNULL(PH.end_date, '9999-12-31')
  AND (SOL.quantity * PH.sell_price) > 1000
  AND Emp.employee_id NOT IN (
    SELECT DISTINCT SO2.salesperson_id
    FROM SalesOrder SO2
             JOIN SalesOrderLine SOL2 ON SO2.order_id = SOL2.order_id
             JOIN Product P2 ON SOL2.product_ref = P2.product_ref
    WHERE P2.name = 'Produto espetacular'
);
