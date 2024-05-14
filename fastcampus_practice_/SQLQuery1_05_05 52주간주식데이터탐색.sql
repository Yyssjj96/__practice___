-- 52주간의 최고가, 최저가를 구하고 차이를 본다. 
-- 상승했으면 상승 수치를 보고 
-- 변동이 큰 종목들을 변동성 기준으로 내림차순으로 봐보자 

/* 주식 분석용으로 사용하는 테이블의 정보 
nasdaq_company = 기업의 정보 
stock = 기업의 일일 주가 정보 
industry_group_symbol = 그룹 별로 모아논 심볼 정보 
industry_group = 기업의 산업 종류와 구분키 정보 
*/

-- stock = datetime 보통 float 기업의 symbol = nvarchar(255)

use doitsql 

-- 52주간 최소, 최대 둘의 차이 둘의 차이를 보자! 
select 
	symbol,
	convert(decimal(18,2), min([close])) as w52_min,
	convert(decimal(18,2), max([close])) as w52_max,
	convert(decimal(18,2), max([close]) - min([close])) as w52_max,
	convert(decimal(18,2), (max([close]) - min([close])) / min([close]) * 100 ) as w52_diff_ratio 
from stock 
where date >= dateadd(week, -52, '2021-10-04')
	-- and symbol = 'MSFT', 'TSLA'
group by symbol 
order by w52_diff_ratio desc; 

-- 서브쿼리로도 만들자! 
-- 오류가 난다 ㅠ 0값이 있어서 ㅠ 
select 
x.symbol,
w52_min, 
w52_max,
w52_max - w52_min as w52_diff_price, 
(w52_max - w52_min) / w52_min * 100 as w52_diff_ratio
-- 서브쿼리로 먼저 짜르고 계산해서 0값이 포함되어 버린듯. 
-- 해결법 : convert (decimal(18,2), case when w52_min > 0 then (w52_max - w52_min) / w52_min * 100 else 0 end ) as w52_diff_ratio 
from ( 
	select 
		symbol, 
		convert(decimal(18,2), min([close])) as w52_min,
		convert(decimal(18,2), max([close])) as w52_max 
		from stock 
		where date >= dateadd(week,-52,'2021-10-04')
			and date <= '2021-10-04'
		group by symbol) as x 

-- 무슨 종목이 최근 상승세 인지 보자! 

-- 최저가 기록시 가장 늦은 날짜 구해보기 
select 
	max(a.date) as date, 
	a.symbol, 
	a.[close] into #temp_min -- 이 세션에서만 작동하는 임시테이블 
from 
	(select 
		date, 
		symbol, 
		convert(decimal(18,2),[close]) as [close] 
	 from stock 
	 where date >= dateadd(week, -52, '2021-10-04')
		and date <= '2021-10-04' ) as a  
	 inner join 
	 (select 
		symbol,
		convert(decimal(18,2), max([close])) as w52_max 
	  from stock 
	  where date >= dateadd(week, -52, '2021-10-04')
		and date <= '2021-10-04'
	  group by symbol )
	  as b on a.symbol = b.symbol and a.[close] = b.w52_max 
group by a.symbol, a.[close]

-- 최고가 기록시 가장 늦은 날짜 
select 
	max(a.date) as date, 
	a.symbol,
	a.[close] into #temp_max 
from ( 
	select 
		date, 
		symbol,
		convert(decimal(18,2),[close]) as [close] 
	from stock 
	where date >= dateadd(week, -52, '2021-10-04')
		and date <= '2021-10-04'
	) as a 
	inner join 
	( select 
		symbol, 
		convert(decimal(18,2),max([close])) as w52_max 
		from stock 
		where date >= dateadd( week, -52, '2021-10-04')
			and date <= '2021-10-04' 
		group by symbol 
		) as b on a.symbol = b.symbol and a.[close] = w52_max 
	group by a.symbol, a.[close] 


-- 임시테이블 확인 
select * from #temp_min
select * from #temp_max 

-- 합쳐서 확인해보자 
-- 최근 날짜가 최저가 대비해서 상승인지 
select 
	b.symbol,
	case when b.date >= a.date then 'Y' else 'N' end as increase_yn 
from #temp_min as a 
	inner join #temp_max b on a.symbol = b.symbol 

-- 52주간의 최소, 최대값으로 우상향인 종목 찾기 
select 
	x.symbol, 
	x.w52_max, 
	x.w52_min,
	x.w52_diff_price, 
	x.w52_diff_ratio, 
	y.increase_yn 
from (
	select 
		symbol,
		convert(decimal(18,2), min([close])) as w52_min,
		convert(decimal(18,2), max([close])) as w52_max,
		convert(decimal(18,2), max([close]) - min([close])) as w52_diff_price,
		convert(decimal(18,2), (max([close]) - min([close])) / min([close]) * 100 ) as w52_diff_ratio 
	from stock 
	where date >= dateadd(week, -52, '2021-10-04')
	and date <= '2021-10-04'
	group by symbol 
	) as x 
	inner join 
	(select 
		b.symbol, 
		case when b.date >= a.date then 'Y' else 'N' end as increase_yn
		from #temp_min as a 
		inner join 
			#temp_max as b on a.symbol = b.symbol ) as y on x.symbol = y.symbol 
where increase_yn = 'Y' 
order by w52_diff_ratio desc 








