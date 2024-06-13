select * from first_ord_table 

select * from order_master_cohort 

-- 두 테이블 조인 
select * from first_ord_table fot 
left join order_master_cohort omc 
on fot.mem_no = omc.mem_no 

-- 코호트 분석에 필요한 데이터 집계 
with 
T1 as ( 
select DISTINCT fot.mem_no, 
	is_promotion,
	case when ord_dt = first_ord_dt then 0
		 when ord_dt > first_ord_dt and date(ord_dt) <= date(first_ord_dt, '+7 days') then 1 --첫 주문일 ~ +7일 후 
		 when date(ord_dt) > date(first_ord_dt, '+7 days') and date(ord_dt) <= date(first_ord_dt, '+14 days') then 2 
		 when date(ord_dt) > date(first_ord_dt, '+14 days') and date(ord_dt) <= date(first_ord_dt, '+21 days') then 3
		 when date(ord_dt) > date(first_ord_dt, '+21 days') and date(ord_dt) <= date(first_ord_dt, '+28 days') then 4
		 else null end as week_number
from first_ord_table fot  
left join order_master_cohort omc on fot.mem_no = omc.mem_no 
)
,T2 as(
	select is_promotion,
		   mem_no, 
		   week_number,
		   ROW_NUMBER () over(partition by mem_no order by week_number) as seq 
	from T1
	where week_number is not null 
	order by 1,2,3,4
)
	select is_promotion, -- 특가상품 구매자/미구매자 코호 
		   case when week_number = 0 then '1,w-0'
		        when week_number = 1 and seq=2 then '2,w-1'
		        when week_number = 2 and seq=3 then '3,w-2'
		        when week_number = 3 and seq=4 then '4,w-3'
		        when week_number = 4 and seq=5 then '5,w-4' end as week_range
			, count(mem_no) as mem_cnt 
	from T2
	group by 1,2
	order by 1,2 

