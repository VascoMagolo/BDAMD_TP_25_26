SELECT
    DN.dispatch_id,
    DN.creation_date,
    SO.registration_date AS data_encomenda
FROM
    DispatchNote DN
        JOIN SalesOrder SO ON DN.order_id = SO.order_id
WHERE
    YEAR(DN.creation_date) = 2018
  AND MONTH(DN.creation_date) BETWEEN 6 AND 8
  AND DATEPART(HOUR, DN.creation_time) < 10
  AND DATEDIFF(DAY, SO.registration_date, DN.creation_date) > 10;