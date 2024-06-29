use sys; 

-- 반려동물 놀이터가 있는 휴게소 중 wifi 사용이 가능한 곳 
select 
	a.* , b.가능여부 
	from rest_area_animal a 
	inner join rest_area_wifi b 
	on a.휴게소명 = b.휴게소명
	
-- 반려동물 놀이터가 있는 휴게소 중 운영시간이 24시간인 곳이 몇 군데인지 
select count(*) from rest_area_animal 
where 운영시간 = '24:00'

-- 본부멸로 wifi 사용이 가능한 휴게소가 몇군데인지 출력 
SELECT 본부, COUNT(*) AS cnt
FROM rest_area_wifi
WHERE 가능여부 = 'O'
GROUP BY 본부;

-- 3번 데이터를 휴게소가 많은 순서대로 정렬하여 출력 
SELECT 본부, COUNT(*) AS cnt
FROM rest_area_wifi
WHERE 가능여부 = 'O'
GROUP BY 본부
order by cnt desc; 

-- 4번 데이터에서 휴게소가 25개 보다 많은 곳만 출력 
SELECT 본부, COUNT(*) AS cnt
FROM rest_area_wifi
WHERE 가능여부 = 'O'
GROUP BY 본부
having cnt > 25 
order by cnt desc; 