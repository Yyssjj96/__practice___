-- 코드를 입력하세요
SELECT 
    product_id, 
    product_name, 
    product_cd, 
    category, 
    price 
FROM 
    food_product
ORDER BY 
    price DESC
FETCH FIRST ROW ONLY;