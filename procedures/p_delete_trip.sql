CREATE OR ALTER PROCEDURE dbo.p_delete_trip
    @trip_id BIGINT
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
        DECLARE @error_msg VARCHAR(4000)

        IF @trip_id IS NULL
        BEGIN
            SET @error_msg = N'Не указаны обязательные входные параметры'
            ;THROW 50000, @error_msg, 1
        END

        DELETE ti
        FROM dbo.tb_trip_inventory ti
        WHERE ti.trip_id = @trip_id

        DELETE tm
        FROM dbo.tb_trip_members tm
        WHERE tm.trip_id = @trip_id

        DELETE t
        FROM dbo.tb_trip t
        WHERE t.trip_id = @trip_id


    END TRY
    BEGIN CATCH
        ;THROW
    END CATCH
END