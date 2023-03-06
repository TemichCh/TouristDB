CREATE OR ALTER PROCEDURE dbo.p_set_trip_members
    @trip_id BIGINT,
    @json NVARCHAR(MAX),
    @new_member BIT = 0
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

        ;WITH cte_tr_memb AS
        (
            SELECT ttm.trip_id,
                   ttm.tourist_id
            FROM dbo.tb_trip_members ttm
            WHERE ttm.trip_id = @trip_id
        )

        MERGE cte_tr_memb tgt
        USING (
                SELECT @trip_id AS trip_id,
                       js.tourist_id
                FROM OPENJSON(@json)
                WITH (
                        tourist_id BIGINT '$.tourist_id'
                     ) js
              ) src
            ON tgt.trip_id = src.trip_id
            AND tgt.tourist_id = src.tourist_id
        WHEN NOT MATCHED THEN
        INSERT
        (
            trip_id,
            tourist_id
        )
        VALUES
        (
            src.trip_id,
            src.tourist_id
        )
        WHEN NOT MATCHED BY SOURCE
        AND @new_member = 0
        THEN
            DELETE;

    END TRY
    BEGIN CATCH
        ;THROW
    END CATCH
END