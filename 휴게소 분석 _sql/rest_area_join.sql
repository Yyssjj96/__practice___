use sys; 

-- 고속도로 휴게소 규모, 주차장 현황을 알아보자 

select  * from rest_area_score;

select * from rest_area_parking;

select a.휴게소명, a.시설구분, b.합계, b.대형, b.소형, b.장애인
	from rest_area_score a left outer join rest_area_parking b 
	on a.휴게소명 = b.휴게소명
union 
select b.휴게소명, a.시설구분, b.합계, b.대형, b.소형, b.장애인
	from rest_area_parking b left outer join rest_area_score a 
	on a.휴게소명 = b.휴게소명;
	
-- 휴게소 규모 화장실 현황 

select * from rest_area_restroom;

select a.휴게소명, a.시설구분, b.남자_변기수, b.여자_변기수 
	from rest_area_score a left outer join rest_area_restroom b
	on a.휴게소명 = b.시설명 
union 
select b.시설명, a.시설구분, b.남자_변기수, b.여자_변기수 
	from rest_area_restroom b left outer join rest_area_score a 
	on a.휴게소명 = b.시설명;
	
-- 고속도로 휴게소의 규모, 주차장, 화장실 현황을 함께 출력 

select a.휴게소명, a.시설구분, b.합계, c.남자_변기수, c.여자_변기수 
	from rest_area_score a, rest_area_parking b, rest_area_restroom c 
	where a.휴게소명 = b.휴게소명
	and b.휴게소명 = c.시설명;

-- 고속도로 휴게소 규모별로 주차장수 합계의 평균, 최소값, 최대값 출력 
select a.휴게소명, a.시설구분, 
	avg(b.합계) over(partition by a.시설구분) as avg_parking,
	min(b.합계) over(partition by a.시설구분) as min_parking,
	max(b.합계) over(partition by a.시설구분) as max_parking
	from rest_area_score a inner join rest_area_parking b 
	on a.휴게소명 = b.휴게소명;
	
-- 고속도로 휴게소 만족도별로 대형 주차장수가 가장 많은 휴게소만 출력 
select t.휴게소명, t.평가등급, t.대형 
from ( -- 인라인 뷰 
select a.휴게소명, a.평가등급, b.대형, 
	  rank() over(partition by a.평가등급 order by b.대형 desc) as rnk
	from rest_area_score a , rest_area_parking b 
	where a.휴게소명 = b.휴게소명 ) t 
where rnk = 1 ;

