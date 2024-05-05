-- 코드를 입력하세요
SELECT 
a.animal_id, 
a.animal_type, 
a.name
from animal_ins a
inner join animal_outs as b on a.animal_id = b.animal_id 
where a.SEX_UPON_INTAKE like 'Intact%' 
and b.SEX_UPON_OUTCOME not like 'Intact%'
order by a.animal_id 
