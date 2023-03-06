USE askon_test
go

IF OBJECT_ID('dbo.tb_category') IS NULL
    CREATE TABLE dbo.tb_category
    (
        category_id BIGINT IDENTITY (1, 1) NOT NULL PRIMARY KEY,
        category_nam VARCHAR(50) NOT NULL
    )

IF OBJECT_ID('dbo.tb_tourist') IS NULL
    CREATE TABLE dbo.tb_tourist
    (
        tourist_id BIGINT IDENTITY (1, 1) NOT NULL PRIMARY KEY,
        face_f VARCHAR(50) NOT NULL,
        face_i VARCHAR(50) NOT NULL,
        face_o VARCHAR(50) NULL,
        birth_dat DATETIME2 NOT NULL,
        gender VARCHAR(1) NULL,
        category_id BIGINT NULL REFERENCES tb_category
    )

IF OBJECT_ID('dbo.tb_route') IS NULL
    CREATE TABLE dbo.tb_route
    (
        route_id BIGINT IDENTITY (1, 1) NOT NULL PRIMARY KEY,
        route_nam VARCHAR(100) NOT NULL
    )

IF OBJECT_ID('dbo.tb_route_category') IS NULL
    CREATE TABLE dbo.tb_route_category
    (
        route_id BIGINT NOT NULL PRIMARY KEY,
        min_member_category_id BIGINT NOT NULL REFERENCES tb_category,
        min_lead_category_id BIGINT NOT NULL REFERENCES tb_category
    )

IF OBJECT_ID('dbo.tb_inventory_category') IS NULL
    CREATE TABLE dbo.tb_inventory_category
    (
        inv_cat_id BIGINT IDENTITY (1, 1) NOT NULL PRIMARY KEY,
        inv_cat_up_id BIGINT NULL,
        inv_cat_nam VARCHAR(100) NOT NULL,
        end_dat DATETIME2 NULL
    )

IF OBJECT_ID('dbo.tb_inventory') IS NULL
    CREATE TABLE dbo.tb_inventory
    (
        inventory_id BIGINT IDENTITY (1, 1) NOT NULL PRIMARY KEY,
        inv_cat_id BIGINT NOT NULL REFERENCES tb_inventory_category,
        inventory_nam VARCHAR(100) NOT NULL,
        inventory_nc VARCHAR(10) NOT NULL DEFAULT ''
    )

IF OBJECT_ID('dbo.tb_trip') IS NULL
    CREATE TABLE dbo.tb_trip
    (
        trip_id BIGINT IDENTITY (1, 1) NOT NULL PRIMARY KEY,
        route_id BIGINT NOT NULL REFERENCES tb_route,
        start_dat DATETIME2 NOT NULL,
        end_dat DATETIME2 NULL,
        lead_tourist_id BIGINT NOT NULL REFERENCES tb_tourist
    )

IF OBJECT_ID('dbo.tb_trip_members') IS NULL
    CREATE TABLE dbo.tb_trip_members
    (
        trip_id BIGINT REFERENCES tb_trip,
        tourist_id BIGINT REFERENCES tb_tourist
        PRIMARY KEY (trip_id, tourist_id)
    )

IF OBJECT_ID('dbo.tb_trip_inventory') IS NULL
    CREATE TABLE dbo.tb_trip_inventory
    (
        trip_id BIGINT REFERENCES tb_trip,
        inventory_id BIGINT REFERENCES tb_inventory
        PRIMARY KEY (trip_id, inventory_id)
    )