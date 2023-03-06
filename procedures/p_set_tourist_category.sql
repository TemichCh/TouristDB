CREATE OR ALTER PROCEDURE dbo.p_set_tourist_category
    @tourist_id BIGINT,
    @category_id BIGINT
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY

        DECLARE @error_msg VARCHAR(4000)

        IF @tourist_id IS NULL OR @category_id IS NULL
        BEGIN
            SET @error_msg = N'Не указаны обязательные входные параметры'
            ;THROW 50000, @error_msg, 1
        END

        UPDATE t
        SET t.category_id = @category_id
        FROM dbo.tb_tourist t
        WHERE t.tourist_id = @tourist_id

    END TRY
    BEGIN CATCH
        ;THROW
    END CATCH
END