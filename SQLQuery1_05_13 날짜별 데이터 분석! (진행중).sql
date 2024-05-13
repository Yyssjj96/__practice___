use ecommers 

-- 가장 많이 결제를 취소한 사람,
-- 월 별 매출 현황 
-- 주별 많이 판매된 강좌 
-- 주별 판매된 강좌 중 각 주별 상위 카테고리 

-- 1. 결제 취소한 고객! 
select
	customer_id, 
	count(*) as cnt, 
	sum(convert(bigint, transaction_amount)) as transaction_amount 
from fact_orders 
where type in (N'ORDER', N'PAYMENT') 
	and state in (N'CANCELLED') 
group by customer_id 
order by cnt desc 

-- customer_id 23171 33번 취소했다 봐보자 
select * from fact_orders 
where customer_id = '23171' 
-- 다양한 카테고리 보통 pg inicis method card 로 결제 후 취소한 것으로 보인다. 
-- completed 한 강의들은 쿠폰, 프로모션을 사용한 결제건들이다! 

-- 월별 매출 현황 
select 
	convert(nvarchar(7), completed_at, 120) as completed_at,  -- 여기서 월별로 잘라줌 
	count(*) as cnt, 
	sum(convert(bigint, transaction_amount)) as transaction_amount 
from fact_orders 
where type in (N'ORDER',N'PAYMENT')
	and state in (N'completed') 
group by convert(nvarchar(7), completed_at, 120) 
order by completed_at 

select convert(nvarchar(7), getdate(), 120)
-- 7월의 주문 금액이 가장 크다! 
-- 내부 요인이 아니면 조사해 볼 만 하다! 

-- 주별은 만들어 놓은 time 디멘션 테이블을 이용한다 
