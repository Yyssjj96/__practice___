-- 하락 없이 연속적인 상승을 보인 종목을 찾아보자 
use doitsql 

-- 2월17일 부터 2월24일까지 하락하지 않고 10% 이상 오른 종목만 보자 


-- 기간 동안 종목별 누락 계산 
select 
	a.symbol, a.[close] as a_close,
	b.[close] as b_close, 
	b.[close] - a.[close] as close_diff,
	(b.[close] - a.[close]) / a.[close] * 100 as ratio_diff
	into #temp 
from 
(select 
	symbol,
	[close]
from stock 
where date = '2021-02-17' ) as a 
inner join (
select 
	symbol, 
	[close]
	from stock 
	where date = '2021-02-24') as b 
 on a.symbol=b.symbol 

select 
	ROW_NUMBER() over(partition by a.symbol order by date asc) as num,
	a.symbol,
	b.date,
	b.[close] 
	into #temp2 
from #temp as a
	inner join stock as b on a.symbol = b.symbol 
where a.ratio_diff >= 10 
	and b.date >= '2021-02-17' and b.date <= '2021-02-24'

select * from #temp2

-- 같은 종목 기준으로 데이터 비교 
select 
	b.symbol,
	a.[date] as a_date, 
	a.[close] as a_close, 
	b.[date] as b_date, 
	b.[close] as b_close, 
	b.[close] - a.[close] as close_diff,
	(b.[close] - a.[close]) / a.[close] * 100 as ratio_diff
	into #temp3 
from #temp2 as a 
	inner join #temp2 as b on a.symbol = b.symbol and a.num=b.num -1 

select * from #temp3 

-- #temp3 에서 하락이 없는 애들만 가져오기 
select 
	symbol,
	a_date,
	round(a_close,2) as a_close,
	b_date,
	round(b_close,2) as b_close, 
	round(close_diff,2) as close_diff,
	round(ratio_diff,2) as ratio_diff
	into #temp4 
from #temp3 
where symbol not in ( select symbol from #temp3 where ratio_diff < 0 group by symbol )

select * from #temp4 

select 
	a.symbol, 
	d.company_name,
	d.industry,
	round(a.a_close,2) as a_close,
	round(a.b_close,2) as b_close, 
	round(a.close_diff,2) as diff_price,
	round(a.ratio_diff,2) as ratio_diff
from #temp as a 
	inner join (select symbol from #temp2 group by symbol ) as b on a.symbol = b.symbol 
	inner join (select symbol from #temp4 group by symbol ) as c on a.symbol = c.symbol 
	inner join nasdaq_company as d on a.symbol = d.symbol 
order by ratio_diff desc 

-- 하락 한 후 회복한 종목 분석 
-- 2020 3월 코로나로 세계 주식 시장이 큰 하락, 코로나가 발생하기 1주일 평균 
-- 시장 가격과 도중 시장 가격, 현재 시장 가격을 비교하여 보자 

-- 1.기준 날짜 생성 
select 
	symbol,
	avg([close]) as [close] 
	into #temp1 
from stock 
where date >= '2021-05-31' and date < '2021-06-04' 
group by symbol

select * from #temp1 

-- 2. 1번과 비교할 데이터 저장 
select 
	symbol,
	avg([close]) as [close] 
	into #temp2
from stock 
where date >= '2021-06-28' and date < '2021-07-02' 
group by symbol

select * from #temp2 

-- 3. 1번과 비교할 데이터 저장 
select 
	symbol,
	avg([close]) as [close] 
	into #temp3
from stock 
where date >= '2021-07-05' and date < '2021-07-09' 
group by symbol

-- 4 임시 테이블을 결합한 기초 데이터 생성 
select 
	a.symbol,
	a.[close] as a_close, 
	b.[close] as b_close,
	c.[close] as c_close,
	(b.[close] - a.[close]) / a.[close] * 100 as b_a_ratio,
	(c.[close] - a.[close] ) / a.[close] * 100 as c_a_ratio,
	(c.[close] - b.[close] ) / b.[close] * 100 as c_b_ratio
	into #result 
from #temp1 as a 
	inner join #temp2 as b on a.symbol = b.symbol
	inner join #temp3 as c on a.symbol = c.symbol 
	
-- 5 조건에 맞는 데이터 검색 
-- #temp1 대비 #temp2가 20% 하락한 종목 중에 #temp3 회복 가격이 -20%~10%인 종목 
select 
	b.company_name,
	b.industry,
	a.symbol,
	a.a_close,
	a.b_close,
	a.c_close,
	a.b_a_ratio,
	a.c_a_ratio,
	a.c_b_ratio
from #result as a 
	inner join nasdaq_company as b on a.symbol = b.symbol 
where a.b_a_ratio <= -20 
	and a.c_a_ratio >= -20 
	and a.c_a_ratio <= -10 
-- 이러한 종목은 원 주가보다 아직 회복이 덜 되서 더 올라갈 기미가 보인다. 


