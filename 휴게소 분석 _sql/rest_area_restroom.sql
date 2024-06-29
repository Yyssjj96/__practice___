
use sys;

-- 노선별 남자 변기수, 여자 변기수 최대값 출력 
select * from rest_area_restroom; 

select 노선, max(남자_변기수), max(여자_변기수)
	from rest_area_restroom 
	group by 노선 ;

-- 휴게소 중 total 변기수가 가장 많은 휴게소가 어디인지 출력 
select 시설명, 남자_변기수 + 여자_변기수 as total 
from rest_area_restroom 
order by total desc
limit 1; 


-- 노선별 남자_변기수, 여자_변기수 평균값 출력 
select 노선 ,
	round(avg(남자_변기수),0) as avg_men, 
	round(avg(여자_변기수),0) as avg_women
from rest_area_restroom 
group by 노선 
order by 2 desc, 3 

-- 노선별로 total 변기수가 가장 많은곳만 출력 
-- 인라인 뷰 사용 
select t.노선,t.시설명, t.total 
from ( 
select 노선, 시설명, 남자_변기수 + 여자_변기수 as total, 
	rank() over(partition by 노선 order by 남자_변기수 + 여자_변기수 desc) as rnk 
	from rest_area_restroom ) t
where t.rnk = 1;

-- 노선별로 남자 변기수가 더 많은 곳, 여자 변기수가 더 많은 곳, 남녀 변기수가 동일 한 곳의 count 
select 노선, 
	count(case when 남자_변기수 > 여자_변기수 then 1 end ) as male ,
	count(case when 여자_변기수 > 남자_변기수 then 1 end ) as female ,
	count(case when 남자_변기수 = 여자_변기수 then 1 end ) as equal,
	count(*) as total 
	from rest_area_restroom 
	group by 노선 ;