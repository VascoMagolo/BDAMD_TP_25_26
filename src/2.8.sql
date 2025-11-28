SELECT
    E.name
FROM
    Employee E
        JOIN SalesOrder SO ON E.employee_id = SO.salesperson_id
WHERE
    E.employee_id NOT IN (SELECT DISTINCT supervisor_id FROM Employee WHERE supervisor_id IS NOT NULL)
GROUP BY
    E.employee_id, E.name
HAVING
    COUNT(SO.order_id) > ALL (
        SELECT COUNT(SO2.order_id)
        FROM Employee Sup
                 JOIN SalesOrder SO2 ON Sup.employee_id = SO2.salesperson_id
        WHERE Sup.employee_id IN (SELECT DISTINCT supervisor_id FROM Employee)
          AND Sup.monthly_salary BETWEEN 1000 AND 3000
        GROUP BY Sup.employee_id
    );