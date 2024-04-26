-- 코드를 입력하세요
SELECT warehouse_id, warehouse_name, address, NVL(FREEZER_YN, 'N')
FROM food_warehouse
WHERE warehouse_name LIKE '%경기%'
ORDER BY warehouse_id;
