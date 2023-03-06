USE askon_test
GO

CREATE OR ALTER TRIGGER dbo.tb_trip_iu ON dbo.tb_trip
FOR INSERT, UPDATE
AS

    IF EXISTS(
                SELECT 1
                FROM inserted i
                INNER JOIN dbo.tb_route_category rc
                    ON i.route_id = rc.route_id
                INNER JOIN dbo.tb_tourist t
                    ON t.tourist_id = i.lead_tourist_id
                WHERE ISNULL(t.category_id, 0) < rc.min_lead_category_id
            )
    BEGIN
        THROW 50001, N'Категория руководителя не соответствует маршруту', 16
    END
    --TODO: Проверка пересечения походов

GO

CREATE OR ALTER TRIGGER dbo.tb_trip_members_iu ON dbo.tb_trip_members
FOR INSERT, UPDATE
AS

    IF EXISTS(
                SELECT 1
                FROM inserted i
                INNER JOIN dbo.tb_trip tr
                    ON tr.trip_id = i.trip_id
                INNER JOIN dbo.tb_route_category rc
                    ON tr.route_id = rc.route_id
                INNER JOIN dbo.tb_tourist t
                    ON t.tourist_id = i.tourist_id
                WHERE ISNULL(t.category_id, 0) < rc.min_member_category_id
            )
    BEGIN
        THROW 50001, N'Категория участника не соответствует маршруту', 16
    END

    --TODO: Проверка пересечения участников походов