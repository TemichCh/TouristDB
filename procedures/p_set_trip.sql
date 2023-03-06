CREATE OR ALTER PROCEDURE dbo.p_set_trip
    @json NVARCHAR(MAX)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
        DECLARE @error_msg VARCHAR(4000),
                @trip_id BIGINT,
                @route_id BIGINT,
                @start_dat DATETIME2,
                @end_dat DATETIME2,
                @lead_tourist_id BIGINT,
                @members NVARCHAR(MAX),
                @inventory NVARCHAR(MAX)

        IF @json IS NULL
        BEGIN
            SET @error_msg = N'Не указаны обязательные входные параметры'
            ;THROW 50000, @error_msg, 1
        END

        DECLARE cur_trip CURSOR LOCAL FAST_FORWARD READ_ONLY FOR
        SELECT js.trip_id,
               js.route_id,
               js.start_dat,
               js.end_dat,
               js.lead_tourist_id,
               js.members,
               js.inventory
        FROM OPENJSON(@json)
        WITH (
                trip_id BIGINT '$.trip_id',
                route_id BIGINT '$.route_id',
                start_dat DATETIME2 '$.start_dat',
                end_dat DATETIME2 '$.end_dat',
                lead_tourist_id BIGINT '$.lead_tourist_id',
                members NVARCHAR(MAX) '$.members' AS JSON,
                inventory NVARCHAR(MAX) '$.inventory' AS JSON
             ) js
        OPEN cur_trip

        FETCH NEXT FROM cur_trip
            INTO @trip_id,
                 @route_id,
                 @start_dat,
                 @end_dat,
                 @lead_tourist_id,
                 @members,
                 @inventory

        WHILE @@FETCH_STATUS = 0
        BEGIN
            IF @trip_id IS NULL
            BEGIN
                INSERT INTO tb_trip
                (
                    route_id,
                    start_dat,
                    end_dat,
                    lead_tourist_id
                )
                VALUES (
                            @route_id,
                            @start_dat,
                            @end_dat,
                            @lead_tourist_id
                       )
                SELECT @trip_id = SCOPE_IDENTITY()
            END
            ELSE
                UPDATE t
                SET t.route_id = @route_id,
                    t.start_dat = @start_dat,
                    t.end_dat = @end_dat,
                    t.lead_tourist_id = @lead_tourist_id
                FROM tb_trip t
                WHERE t.trip_id = @trip_id

                EXEC dbo.p_set_trip_members
                    @trip_id = @trip_id,
                    @json = @members

                EXEC dbo.p_set_trip_inventory
                    @trip_id = @trip_id,
                    @json = @inventory

            FETCH NEXT FROM cur_trip
                INTO @trip_id,
                     @route_id,
                     @start_dat,
                     @end_dat,
                     @lead_tourist_id,
                     @members,
                     @inventory
        END
        CLOSE cur_trip
        DEALLOCATE cur_trip
    END TRY
    BEGIN CATCH
        ;THROW
    END CATCH
END