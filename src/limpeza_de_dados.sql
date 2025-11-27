BEGIN TRANSACTION;

BEGIN TRY
    -- 1. Tabelas de Transporte e Expedição (Nível 5 e 4)
    DELETE FROM Transport;
    DELETE FROM DispatchNoteLine;
    DELETE FROM DispatchNote;

    -- 2. Tabelas de Encomendas (Nível 4 e 3)
    DELETE FROM SalesOrderLine;
    DELETE FROM SalesOrder;

    -- 3. Tabelas de Stock e Definições (Nível 3 e 2)
    DELETE FROM Stock;
    DELETE FROM WarehouseStockDefinition;
    DELETE FROM PriceHistory;

    -- 4. Tabelas Principais (Nível 2)
    DELETE FROM Product;
    DELETE FROM PhysicalZone;
    DELETE FROM Employee;
    DELETE FROM Customer;
    DELETE FROM Warehouse;
    DELETE FROM Carrier;
    DELETE FROM GeographicZone;

    COMMIT TRANSACTION;
    PRINT 'Todos os dados foram apagados com sucesso.';
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    PRINT 'Erro ao apagar dados. Transação revertida.';
    PRINT ERROR_MESSAGE();
END CATCH;
GO