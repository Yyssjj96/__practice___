-- 과거에 내가 특정 종목을 삿다면 어떤 결과가 되었을지 확인해보자 

use doitsql

-- 임시 테이블 생성 'mystock'
create table mystock (
date datetime,
symbol nvarchar(255),
qty int, 
price decimal(18,2)) 

insert into mystock values ('2019-01-02','TSLA',10,61.00)
insert into mystock values ('2019-05-23','TSLA',2,39.00)
insert into mystock values ('2019-07-14','TSLA',5,300.00)
insert into mystock values ('2019-01-07','MSFT',3,100.00)
insert into mystock values ('2019-01-07','MSFT',6,132.00)
insert into mystock values ('2019-01-07','MSFT',2,151.00)

delete mystock 

insert into mystock 
select date, symbol, 10, [close] from stock where symbol = 'MSFT' and date = '2019-10-28'
union all 
select date, symbol, 10, [close] from stock where symbol = 'MSFT' and date = '2019-08-23'

SELECT * FROM MYSTOCK

select 
	convert(nvarchar(10), x.date, 120 ) as date,
	convert(decimal(18,2) , sum(x.benefit)) as benefit,
	x.symbol
from 
(
select 
	b.date, 
	b.symbol,
	(b.[close] * a.price) * qty as benefit 
from 
mystock as a
	left outer join stock as b on a.symbol = b.symbol and a.date <= b.date
	) as x 
group by x.symbol, x.date
order by x.symbol, x.date 

-- 이동 평균선 구하기 
-- 일정 기간에 주가를 산술 평균한 값을 모두 연결한 선 
-- 보통 5일선, 20일, 60일, 120일 범위로 보여준다.
-- 현재 날짜로 부터 5일 이동, 20일 이동 평균값을 검색하자 

select 
	a.date,
	a.symbol, 
	a.[close],
	'' as '----',
	min(b.date) as day5_start, 
	max(b.date) as day5_end,
	avg(b.[close]) as day5_close,
	'' as '----',
	min(c.date) as day20_start,
	max(c.date) as day20_end,
	avg(c.[close]) as day_20_close
from stock as a 
	left outer join stock as b on a.symbol = b.symbol and a.date <= dateadd(day,5,b.date) and a.date >= b.date 
	left outer join stock as c on a.symbol = c.symbol and a.date <= dateadd(day,20,c.date) and a.date >= c.date 
where a.symbol = 'MSFT' 
group by a.date, a.symbol, a.[close]
order by a.date 

-- 주식 시장의 특성상 토,일,공휴일은 시장이 움직이지 않으니 그걸 제외하고 활동하는 5일,20일만 보자 
-- cte를 사용해 일별 순위를 구한다음에 평균을 검색하자 

with cte_avg as (
select 
	row_number() over(partition by symbol order by date asc) as num,
	convert(nvarchar(10), date, 120) as date,
	symbol,
	convert(decimal(18,2),[close]) as [close]
from stock 
where symbol = 'MSFT' 
group by date, symbol,[close]
)
select 
	a.date,
	a.symbol, 
	a.[close],
	'' as '----',
	min(b.date) as day5_start, 
	max(b.date) as day5_end,
	avg(b.[close]) as day5_close,
	'' as '----',
	min(c.date) as day20_start,
	max(c.date) as day20_end,
	avg(c.[close]) as day_20_close
from cte_avg as a 
	left outer join cte_avg as b on a.symbol = b.symbol and a.num <= (b.num+5) and a.num >= b.num
	left outer join cte_avg as c on a.symbol = c.symbol and a.num <= (c.num+20) and a.num >= c.num
group by a.date, a.symbol,a.[close]
order by a.date 
