INSERT INTO GeographicZone (id_geo_zone, designation) VALUES
                                                          (1, 'Zona Norte - Porto'),
                                                          (2, 'Zona Norte - Braga'),
                                                          (3, 'Zona Centro - Coimbra'),
                                                          (4, 'Zona Centro - Leiria'),
                                                          (5, 'Zona Sul - Lisboa'),
                                                          (6, 'Zona Sul - Algarve'),
                                                          (7, 'Zona Interior - Viseu'),
                                                          (8, 'Zona Interior - Guarda'),
                                                          (9, 'Zona Madeira'),
                                                          (10, 'Zona Açores');
DECLARE @i INT = 11;
WHILE @i <= 30
    BEGIN
        INSERT INTO GeographicZone (id_geo_zone, designation) VALUES (@i, 'Zona Genérica ' + CAST(@i AS VARCHAR));
        SET @i = @i + 1;
    END;
GO

INSERT INTO Carrier (carrier_id, name, nif, phone, cost_per_hour) VALUES
                                                                      (1, 'TransRapida', '500100100', '910000001', 25.50),
                                                                      (2, 'LogisticaTotal', '500100200', '910000002', 20.00),
                                                                      (3, 'NorteCargas', '500100300', '910000003', 18.00);
DECLARE @i INT = 4;
WHILE @i <= 30
    BEGIN
        INSERT INTO Carrier (carrier_id, name, nif, phone, cost_per_hour)
        VALUES (@i, 'Transportadora ' + CAST(@i AS VARCHAR), '500100' + CAST(@i AS VARCHAR), '9100000' + CAST(@i AS VARCHAR), 20 + @i);
        SET @i = @i + 1;
    END;
GO

INSERT INTO Warehouse (warehouse_id, name, address, latitude, longitude, id_geo_zone) VALUES
                                                                                          (1, 'Armazém Central Porto', 'Rua do Freixo, Porto', 41.1579, -8.6291, 1),
                                                                                          (2, 'XPTO', 'Rua Desconhecida, Braga', 41.5454, -8.4265, 2),
                                                                                          (3, 'Armazém Lisboa', 'Av da Liberdade, Lisboa', 38.7223, -9.1393, 5),
                                                                                          (4, 'Armazém Coimbra', 'Rua do Mondego', 40.2033, -8.4103, 3),
                                                                                          (5, 'Armazém Algarve', 'Estrada de Faro', 37.0179, -7.9308, 6);
DECLARE @i INT = 6;
WHILE @i <= 30
    BEGIN
        INSERT INTO Warehouse (warehouse_id, name, address, latitude, longitude, id_geo_zone)
        VALUES (@i, 'Armazém ' + CAST(@i AS VARCHAR), 'Rua ' + CAST(@i AS VARCHAR), 40.0 + @i*0.01, -8.0 + @i*0.01, 1);
        SET @i = @i + 1;
    END;
GO

INSERT INTO PhysicalZone (physical_zone_id, warehouse_id, designation, capacity_volume) VALUES
                                                                                            (1, 1, 'Zona A1 - Receção', 500),
                                                                                            (2, 1, 'Zona A2 - Stock Grande', 1000),
                                                                                            (3, 2, 'Zona X1 - XPTO Principal', 2000), -- XPTO
                                                                                            (4, 2, 'Zona X2 - XPTO Secundária', 500), -- XPTO
                                                                                            (5, 3, 'Zona L1', 600);
DECLARE @i INT = 6;
WHILE @i <= 40
    BEGIN
        INSERT INTO PhysicalZone (physical_zone_id, warehouse_id, designation, capacity_volume)
        VALUES (@i, ( (@i % 5) + 1 ), 'Zona Auto ' + CAST(@i AS VARCHAR), 100); -- Distribui pelos primeiros 5 armazéns
        SET @i = @i + 1;
    END;
GO

INSERT INTO Employee (employee_id, citizen_card, name, address, tax_id, monthly_salary, category, birth_date, warehouse_id, supervisor_id, id_geo_zone) VALUES
                                                                                                                                                            (1, '10000001', 'Chefe Silva', 'Porto', '200000001', 5000, 'Diretor', '1970-01-01', 1, NULL, 1),
                                                                                                                                                            (2, '10000002', 'Supervisor Santos', 'Porto', '200000002', 1500, 'Supervisor', '1980-01-01', 1, 1, 1), -- Salário entre 1000 e 3000 (Query 2.8)
                                                                                                                                                            (3, '10000003', 'Supervisor Costa', 'Braga', '200000003', 1200, 'Supervisor', '1982-01-01', 2, 1, 2);

DECLARE @i INT = 4;
WHILE @i <= 24
    BEGIN
        INSERT INTO Employee (employee_id, citizen_card, name, address, tax_id, monthly_salary, category, birth_date, warehouse_id, supervisor_id, id_geo_zone)
        VALUES (@i, CAST(10000000 + @i AS VARCHAR), 'Funcionario A1_' + CAST(@i AS VARCHAR), 'Porto', CAST(200000000 + @i AS VARCHAR), 800, 'Operario', '1990-01-01', 1, 2, 1);
        SET @i = @i + 1;
    END;

WHILE @i <= 35
    BEGIN
        INSERT INTO Employee (employee_id, citizen_card, name, address, tax_id, monthly_salary, category, birth_date, warehouse_id, supervisor_id, id_geo_zone)
        VALUES (@i, CAST(10000000 + @i AS VARCHAR), 'Funcionario Outro_' + CAST(@i AS VARCHAR), 'Braga', CAST(200000000 + @i AS VARCHAR), 850, 'Vendedor', '1992-01-01', 2, 3, 2);
        SET @i = @i + 1;
    END;
GO

DECLARE @i INT = 1;
WHILE @i <= 35
    BEGIN
        INSERT INTO Customer (customer_id, name, address, zip_code, mobile, tax_id, type_class, id_geo_zone)
        VALUES (@i, 'Cliente ' + CAST(@i AS VARCHAR), 'Morada ' + CAST(@i AS VARCHAR), '4000-00' + CAST(@i AS VARCHAR), '9100000' + CAST(@i AS VARCHAR), '2500000' + CAST(@i AS VARCHAR), CASE WHEN @i % 2 = 0 THEN 'VIP' ELSE 'Normal' END, 1);
        SET @i = @i + 1;
    END;
GO

INSERT INTO Product (product_ref, name, description, purchase_price, current_sell_price, unit_type) VALUES
                                                                                                        (1, 'Produto espetacular', 'O melhor produto', 500, 1000, 'Unidade'),
                                                                                                        (2, 'Parafuso Simples', 'Parafuso aco', 0.01, 0.05, 'Unidade'),
                                                                                                        (3, 'Martelo', 'Ferramenta', 5, 12, 'Unidade'),
                                                                                                        (4, 'Tinta Azul', 'Lata 5L', 10, 25, 'Lata');

DECLARE @i INT = 5;
WHILE @i <= 35
    BEGIN
        INSERT INTO Product (product_ref, name, description, purchase_price, current_sell_price, unit_type)
        VALUES (@i, 'Produto Genérico ' + CAST(@i AS VARCHAR), 'Desc', 10, 20, 'Unidade');
        SET @i = @i + 1;
    END;
GO

INSERT INTO PriceHistory (history_id, product_ref, sell_price, start_date, end_date) VALUES
                                                                                         (1, 1, 1200.00, '2015-01-01', '2015-12-31'), -- Produto Espetacular em 2015
                                                                                         (2, 1, 1000.00, '2016-01-01', NULL),
                                                                                         (3, 2, 0.05, '2010-01-01', NULL),
                                                                                         (4, 3, 10.00, '2015-01-01', '2015-12-31'), -- Martelo em 2015
                                                                                         (5, 3, 12.00, '2016-01-01', NULL);

DECLARE @i INT = 6;
DECLARE @prod INT = 4;
WHILE @i <= 40
    BEGIN
        INSERT INTO PriceHistory (history_id, product_ref, sell_price, start_date, end_date)
        VALUES (@i, @prod, 20.00, '2014-01-01', NULL);
        SET @i = @i + 1;
        SET @prod = CASE WHEN @prod >= 35 THEN 4 ELSE @prod + 1 END;
    END;
GO

INSERT INTO WarehouseStockDefinition (warehouse_id, product_ref, min_stock) VALUES
                                                                                (1, 1, 10), -- Armazem 1, Prod Espetacular
                                                                                (1, 2, 1000), -- Armazem 1, Parafuso
                                                                                (2, 1, 5),  -- XPTO, Prod Espetacular
                                                                                (2, 2, 500); -- XPTO, Parafuso

INSERT INTO WarehouseStockDefinition (warehouse_id, product_ref, min_stock)
SELECT W.warehouse_id, P.product_ref, 10
FROM Warehouse W, Product P
WHERE W.warehouse_id > 2 AND P.product_ref > 2;
GO

INSERT INTO Stock (physical_zone_id, product_ref, quantity) VALUES
                                                                (1, 1, 20), -- Arm 1, Zona 1, Prod 1
                                                                (1, 2, 5000), -- Arm 1, Zona 1, Prod 2 (Muito stock)
                                                                (3, 1, 0), -- XPTO, Zona 3, Prod 1 (Sem stock para teste)
                                                                (3, 2, 100), -- XPTO, Zona 3, Prod 2
                                                                (4, 3, 50);  -- XPTO, Zona 4, Prod 3

INSERT INTO Stock (physical_zone_id, product_ref, quantity) VALUES (30, 4, 100);

DECLARE @z INT = 5;
WHILE @z <= 29
    BEGIN
        INSERT INTO Stock (physical_zone_id, product_ref, quantity) VALUES (@z, 5, 20); -- Stock seguro
        SET @z = @z + 1;
    END;
GO


INSERT INTO SalesOrder (order_id, registration_date, customer_id, salesperson_id, status) VALUES
(1, '2015-05-20', 1, 30, 'Processada'),
(2, '2015-06-20', 2, 31, 'Processada'),
(3, '2018-03-10', 3, 2, 'Pendente'),
(4, '2018-04-10', 4, 2, 'Pendente'),
(5, '2018-07-01', 1, 30, 'Processada'),
(6, '2018-08-01', 1, 30, 'Processada'),
(7, '2019-01-15', 1, 30, 'Processada'),
(8, '2019-02-15', 1, 30, 'Processada');

DECLARE @i INT = 9;
WHILE @i <= 35
    BEGIN
        INSERT INTO SalesOrder (order_id, registration_date, customer_id, salesperson_id, status)
        VALUES (@i, '2020-01-01', 1, 30, 'Processada');
        SET @i = @i + 1;
    END;
GO

INSERT INTO SalesOrderLine (order_id, product_ref, quantity) VALUES
(1, 1, 1),
(2, 3, 200),
(3, 2, 100),
(4, 2, 100),
(7, 2, 50),
(8, 2, 50);
DECLARE @i INT = 9;
WHILE @i <= 35
    BEGIN
        INSERT INTO SalesOrderLine (order_id, product_ref, quantity) VALUES (@i, 2, 10);
        SET @i = @i + 1;
    END;
GO

INSERT INTO DispatchNote (dispatch_id, creation_date, creation_time, resp_employee_id, order_id) VALUES
                                                                                                     (1, '2018-07-15', '09:00:00', 4, 5),
                                                                                                     (2, '2018-08-15', '09:30:00', 4, 6);
DECLARE @i INT = 3;
WHILE @i <= 35
    BEGIN
        INSERT INTO DispatchNote (dispatch_id, creation_date, creation_time, resp_employee_id, order_id)
        VALUES (@i, '2020-01-02', '14:00:00', 4, @i);
        SET @i = @i + 1;
    END;
GO

INSERT INTO DispatchNoteLine (dispatch_id, product_ref, physical_zone_id, quantity) VALUES
                                                                                        (1, 2, 1, 10),
                                                                                        (2, 2, 1, 10);

DECLARE @i INT = 3;
WHILE @i <= 35
    BEGIN
        INSERT INTO DispatchNoteLine (dispatch_id, product_ref, physical_zone_id, quantity)
        VALUES (@i, 2, 1, 10);
        SET @i = @i + 1;
    END;
GO
INSERT INTO Transport (transport_id, carrier_id, dispatch_id, transport_datetime, hours_used) VALUES
                                                                                                  (1, 1, 1, '2018-07-15 10:00:00', 2.5),
                                                                                                  (2, 1, 2, '2018-08-15 10:00:00', 3.0);

DECLARE @i INT = 3;
WHILE @i <= 35
    BEGIN
        INSERT INTO Transport (transport_id, carrier_id, dispatch_id, transport_datetime, hours_used)
        VALUES (@i, 1, @i, '2020-01-02 15:00:00', 1.0);
        SET @i = @i + 1;
    END;
GO

PRINT 'Povoamento de dados concluido com sucesso.'