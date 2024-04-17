-- 코드를 입력하세요
SELECT COUNT(*) 
FROM user_info 
WHERE EXTRACT(YEAR FROM joined) = 2021 
AND age BETWEEN 20 AND 29;