/* 작년 대비 동월 매출 비교*/ 
/* 월별로 작년 대비해 얼마나 매출이 올랐는지 비교, 매출액 차이, 비율, 성장 비율 추출 */

with temp_01 as (

select date_trunc('month',order_date)::date as month_day
	,sum(amount) as sum_amount
from nw.orders a 
	join nw.order_items b on a.order_id = b.order_id 
group by date_trunc('month',order_date)::date 
),
temp_02 as (
select month_day, sum_amount as curr_amount 
	,lag(month_day,12) over (order by month_day) as prev_month_1year
	,lag(sum_amount,12) over (order by month_day) as prev_amount_1year
from temp_01
)
select * 
	, curr_amount - prev_amount_1year as diff_amount
	, 100.0 * curr_amount / prev_amount_1year as prev_pct 
	, 100.0 * (curr_amount - prev_amount_1year) / prev_amount_1year as prev_growth_pct 
from temp_02 
where prev_month_1year is not null; 

/* 작년 분기와 이번 년도 분기 비교 */ 
WITH temp_01 AS (
    SELECT date_trunc('quarter', order_date)::date AS quarter_start
        , SUM(amount) AS sum_amount
    FROM nw.orders a 
    JOIN nw.order_items b ON a.order_id = b.order_id 
    GROUP BY date_trunc('quarter', order_date)::date 
),
temp_02 AS (
    SELECT quarter_start, sum_amount AS curr_amount 
        , LAG(quarter_start, 4) OVER (ORDER BY quarter_start) AS prev_quarter_1year
        , LAG(sum_amount, 4) OVER (ORDER BY quarter_start) AS prev_amount_1year
    FROM temp_01
)
SELECT * 
    , curr_amount - prev_amount_1year AS diff_amount
    , 100.0 * curr_amount / prev_amount_1year AS prev_pct 
    , 100.0 * (curr_amount - prev_amount_1year) / prev_amount_1year AS prev_growth_pct 
FROM temp_02 
WHERE prev_quarter_1year IS NOT NULL;