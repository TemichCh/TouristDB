CREATE OR ALTER PROCEDURE dbo.p_get_inventory
    @not_in_use BIT = 0
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
        ;WITH cte_cat AS
        (
            SELECT p.inv_cat_id,
                   p.inv_cat_up_id,
                   CAST(ROW_NUMBER() OVER(ORDER BY p.inv_cat_id) + 100000000 AS VARCHAR(100)) AS [sid],
                   p.inv_cat_nam
            FROM dbo.tb_inventory_category p
            WHERE p.inv_cat_up_id IS NULL
            UNION ALL
            SELECT c.inv_cat_id,
                   c.inv_cat_up_id,
                   CAST(p.[sid] AS VARCHAR(50)) + CAST((ROW_NUMBER() OVER(ORDER BY c.inv_cat_id)) + 100 AS VARCHAR(50)) [sid],
                   c.inv_cat_nam
            FROM dbo.tb_inventory_category c
            INNER JOIN cte_cat p
                ON p.inv_cat_id = c.inv_cat_up_id
        )
        SELECT ti.inventory_id,
               ti.inv_cat_id,
               c.inv_cat_nam,
               ti.inventory_nam,
               ti.inventory_nc
        FROM cte_cat c
        LEFT JOIN dbo.tb_inventory ti
            ON ti.inv_cat_id = c.inv_cat_id
        WHERE @not_in_use = 0
        OR (
                @not_in_use = 1
                AND NOT EXISTS(
                                SELECT 1
                                FROM dbo.tb_trip tt
                                INNER JOIN dbo.tb_trip_inventory tti
                                    ON tt.trip_id = tti.trip_id
                                WHERE tti.inventory_id = ti.inventory_id
                                AND SYSDATETIME() BETWEEN tt.start_dat AND ISNULL(tt.end_dat, SYSDATETIME())
                              )
           )
        ORDER BY c.sid,
                 ti.inventory_nam

    END TRY
    BEGIN CATCH
        ;THROW
    END CATCH
END