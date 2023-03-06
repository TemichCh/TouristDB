/*
Запросы выполнять последовательно по блокам. В блоках по смыслу.
*/

/*
1. Смотрим категории и туристов, расставляем им категории
*/

SELECT * FROM tb_category
SELECT * from tb_tourist

EXEC p_set_tourist_category
    @tourist_id = 1,
    @category_id = 4

EXEC p_set_tourist_category
    @tourist_id = 2,
    @category_id = 1

EXEC p_set_tourist_category
    @tourist_id = 3,
    @category_id = 3

/*
2. Смотрим данные создаем поход
*/
SELECT * from tb_inventory
SELECT * from tb_tourist
SELECT * FROM tb_route
/* Добавляем поход, минимумы для маршрута не указаны, данные должны добавиться*/
DECLARE @json NVARCHAR(MAX) = '[{
  "route_id": "1",
  "start_dat": "01.03.2023",
  "end_dat": "07.03.2023",
  "lead_tourist_id": "1",
  "members": [
    {"tourist_id": 2},
    {"tourist_id": 3}
  ],
  "inventory": [
    {"inventory_id": 1},
    {"inventory_id": 4},
    {"inventory_id": 5}
  ]
}]'
EXEC dbo.p_set_trip @json = @json

/*смотрим что данные добавились*/
SELECT * FROM dbo.tb_trip
SELECT * FROM dbo.tb_trip_members
SELECT * FROM dbo.tb_trip_inventory

/*
3. ставим минимум для маршрута и добавляем данные
*/
SELECT * from tb_route_category
INSERT INTO tb_route_category(route_id, min_member_category_id, min_lead_category_id)
VALUES (2,5,5)
/*Должен быть отбой по триггеру на участнике (если иды совпадут) поход добавляется без участников и инвентаря*/
DECLARE @json NVARCHAR(MAX) = '[{
  "route_id": "2",
  "start_dat": "01.03.2023",
  "end_dat": "07.03.2023",
  "lead_tourist_id": "1",
  "members": [
    {"tourist_id": 2},
    {"tourist_id": 3}
  ],
  "inventory": [
    {"inventory_id": 1},
    {"inventory_id": 4},
    {"inventory_id": 5}
  ]
}]'
EXEC dbo.p_set_trip @json = @json

/*
4. Выполняем без параметра, потом с параметром = 1
*/
EXEC p_get_inventory
    @not_in_use = 1


/*Удаление похода*/
--EXEC dbo.p_delete_trip @trip_id = 2