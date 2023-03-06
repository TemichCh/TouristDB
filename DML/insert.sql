INSERT INTO tb_category (category_nam)
VALUES (N'1-й разряд'),
       (N'2-й разряд'),
       (N'3-й разряд'),
       (N'кандидат в мастера спорта'),
       (N'мастер спорта')

INSERT INTO tb_tourist
(
    face_f,
    face_i,
    face_o,
    birth_dat,
    gender
)
VALUES (
            N'Иванов',
            N'Иван',
            N'Иванович',
            '19810101',
            N'М'
       ),
        (
            N'Сидоров',
            N'Иван',
            N'Парфёнович',
            '19870101',
            N'М'
        ),
        (
            N'Пчелкина',
            N'Мария',
            NULL,
            '19900101',
            N'Ж'
       )

DECLARE @inv_id BIGINT,
        @pal_id BIGINT,
        @kat_id BIGINT
INSERT INTO tb_inventory_category (inv_cat_nam)
VALUES (N'Общий инвентарь')
SELECT @inv_id = scope_identity()

INSERT INTO tb_inventory_category (inv_cat_nam, inv_cat_up_id)
VALUES (N'Палатки', @inv_id)
SELECT @pal_id = scope_identity()

INSERT INTO tb_inventory_category (inv_cat_nam, inv_cat_up_id)
VALUES (N'Котелки', @inv_id)
SELECT @kat_id = scope_identity()

INSERT INTO tb_inventory
(
    inv_cat_id,
    inventory_nam,
    inventory_nc
)
VALUES (
            @kat_id,
            N'котелок малый',
            'к-1'
       ),
       (
            @kat_id,
            N'котелок средний',
            'к-2'
       ),
       (
            @kat_id,
            N'котелок большой',
            'к-3'
       ),
       (
            @pal_id,
            N'палатка одиночная',
            'п-1'
       ),
       (
            @pal_id,
            N'палатка двухместная',
            'п-2'
       )

INSERT INTO dbo.tb_route (route_nam)
VALUES (N'Тургояк'),
       (N'Таганай')

