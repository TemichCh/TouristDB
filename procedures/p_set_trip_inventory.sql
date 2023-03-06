CREATE OR ALTER PROCEDURE dbo.p_set_trip_inventory
    @trip_id BIGINT,
    @json NVARCHAR(MAX),
    @new_inv BIT = 0
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
        DECLARE @error_msg VARCHAR(4000)

        IF @json IS NULL OR @trip_id IS NULL
        BEGIN
            SET @error_msg = N'Не указаны обязательные входные параметры'
            ;THROW 50000, @error_msg, 1
        END

        ;WITH cte_tr_inv AS
        (
            SELECT ttm.trip_id,
                   ttm.inventory_id
            FROM dbo.tb_trip_inventory ttm
            WHERE ttm.trip_id = @trip_id
        )

        MERGE cte_tr_inv tgt
        USING (
                SELECT @trip_id AS trip_id,
                       js.inventory_id
                FROM OPENJSON(@json)
                WITH (
                        inventory_id BIGINT '$.inventory_id'
                     ) js
              ) src
            ON tgt.trip_id = src.trip_id
            AND tgt.inventory_id = src.inventory_id
        WHEN NOT MATCHED THEN
        INSERT
        (
            trip_id,
            inventory_id
        )
        VALUES
        (
            src.trip_id,
            src.inventory_id
        )
        WHEN NOT MATCHED BY SOURCE
        AND @new_inv = 1
        THEN
            DELETE;

    END TRY
    BEGIN CATCH
        ;THROW
    END CATCH
END