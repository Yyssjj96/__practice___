-- 코드를 입력하세요
SELECT 
    animal_type, 
    CASE 
        WHEN name is null then 'No name'
        ELSE name 
        end as name,
    sex_upon_intake 
FROM 
    animal_ins
order by animal_id asc;