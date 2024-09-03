select * from nw.orders;

/* 동년도 월별 누적 매출 및 동일 분기 웖별 누적 매출 
 1. 월별 누적 매출 구하고 
 2. 월별 매출액 집합에 동일 년도의 월별 누적 매출과 동일 분기의 월별 누적 매출 구함. 
*/

with 
temp_01 as (

select date_trunc('month',order_date)::date as month_day
, sum(amount) as sum_amount
from nw.orders a 
	join nw.order_items b on a.order_id = b.order_id 
group by date_trunc('month',order_date)::date
)
select *
	,date_trunc('year',month_day)::date as year_month
	,date_trunc('quarter',month_day)::date as quarter_month 
	,sum(sum_amount) over (partition by date_trunc('year',month_day)::date order by month_day) as cume_year_amount
	,sum(sum_amount) over (partition by date_trunc('quarter',month_day):: date order by month_day) as cume_quarter_amount
from temp_01

/* 이동 평균 매출 구하기 , 가중 이동 평균 매출 구하기 */
with 
temp_01 as (
select date_trunc('day',order_date)::date as d_day
	,sum(amount) as sum_amount 
from nw.orders a 
	join nw.order_items b on a.order_id = b.order_id 
where order_date >= to_date('1996-07-08','yyyy-mm-dd')
group by date_trunc('day',order_date)::date
),
temp_02 as (
select d_day, sum_amount
	,avg(sum_amount) over (order by d_day rows between 4 preceding and current row) as m_avg_5days
	,row_number() over (order by d_day) as rnum
from temp_01
)
select d_day, sum_amount, rnum 
	,case when rnum < 5 then null 
		else m_avg_5days end as m_avg_5days 
	from temp_02;

/*5일 이동 가중 이동 평균 매출 */
  /* 5일중 가장 먼 날짜는 매출액의 0.5 중간 날짜 2,3,4, 는 매출액 그대로 */
   /*당일은 1.5 매출액으로 가중치 부여 */ 
   
with 
temp_01 as (
select date_trunc('day', order_date)::date as d_day
	, sum(amount) as sum_amount
	, row_number() over (order by date_trunc('day', order_date)::date) as rnum
from nw.orders a
	join nw.order_items b on a.order_id = b.order_id
where order_date >= to_date('1996-07-08', 'yyyy-mm-dd')
group by date_trunc('day', order_date)::date
),
temp_02 as (
select a.d_day, a.sum_amount, a.rnum, b.d_day as d_day_back, b.sum_amount as sum_amount_back, b.rnum as rnum_back 
from temp_01 a
	join temp_01 b on a.rnum between b.rnum and b.rnum + 4 
)
select d_day
	, avg(sum_amount_back) as m_avg_5days
	, sum(sum_amount_back)/5 as m_avg_5days_01
	, sum(case when rnum - rnum_back = 4 then 0.5 * sum_amount_back
	           when rnum - rnum_back in (3, 2, 1) then sum_amount_back
	           when rnum - rnum_back = 0 then 1.5 * sum_amount_back 
	      end) as m_weighted_sum
	, sum(case when rnum - rnum_back = 4 then 0.5 * sum_amount_back
		   when rnum - rnum_back in (3, 2, 1) then sum_amount_back
		   when rnum - rnum_back = 0 then 1.5 * sum_amount_back 
	      end) / 5 as m_w_avg_sum
	, count(*) as cnt
from temp_02
group by d_day
having count(*) = 5
order by d_day
;

