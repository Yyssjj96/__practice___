use sys; 

-- 평가 등급이 최우수인 휴게소의 장애인 주차장수 출력 	
select s.휴게소명, s.시설구분, p.장애인 
	from (
		select 휴게소명, 시설구분
		from rest_area_score 
		where 평가등급 = '최우수' 
		) s left outer join rest_area_parking p 
		on s.휴게소명 = p.휴게소명 
	order by p.장애인 desc 
	
-- 평가등급이 우수인 휴게소의 장애인 주차장수 비율 출력 
select s.휴게소명, s.시설구분, round(p.장애인/p.합계*100,2) as ratio
	from (
	 	select 휴게소명, 시설구분 
		from rest_area_score 
		where 평가등급 = '우수') s 
	left outer join rest_area_parking p 
	on s.휴게소명 = p.휴게소명 
order by p.장애인/p.합계*100 desc;


-- 휴게소의 시설구분별 주차장수 합계의 평균 출력 
select a.시설구분, round(avg(b.합계)) 
from rest_area_score a 
left outer join rest_area_parking b 
on a.휴게소명 = b.휴게소명 
group by a.시설구분 

-- 노선별로 대형차를 가장 많이 주차할 수 있는 휴게소 top3 
select t.노선 , t.rnk, t.휴게소명 
from (
	select 노선, 
		   rank() over(partition by 노선 order by 대형 desc) as rnk,
		   휴게소명
	from rest_area_parking
) t 
where t.rnk <= 3 ;

-- 본부별로 소형차를 가장 많이 주차할 수 있는 휴게소 top3 
select t.본부, t.휴게소명, t.소형 
from (
select 본부, 휴게소명, 소형,
rank() over(partition by 본부 order by 소형 desc) as rnk
from rest_area_parking
) t 
where t.rnk < 4 
