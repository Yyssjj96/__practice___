-- 코드를 입력하세요
SELECT b.ingredient_type, SUM(a.total_order) AS total_order
FROM first_half a
JOIN icecream_info b ON a.flavor = b.flavor
GROUP BY b.ingredient_type;