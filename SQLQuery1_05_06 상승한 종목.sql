use doitsql 

-- �Ϸ� ���� ���, �϶� ���� �м� 
-- �Ϸ� �ֽ��� ���۰�, ����, �ŷ� �ִ밡, �ŷ� �ּҰ����� �̿�
-- ���� ����� ���� ����ߴ��� ���� 

select 
	b.symbol,
	b.company_name,
	b.sector,
	b.industry,
	date,
	convert(decimal(18,2),[open]) as [open],
	convert(decimal(18,2),[close]) as [close],
	convert(decimal(18,2),[close] - [open]) as diff_price,
	convert(decimal(18,2),[close] - [open] / [open]*100 ) as diff_ratio,
    '' AS '---',
	convert(decimal(18,2),[low]) as [low],
	convert(decimal(18,2),[high]) as [high],
	convert(decimal(18,2),[high] - [low]) as diff_high_price,
	convert(decimal(18,2),[high] - [low] / [low]*100 ) as diff_high_ratio
from stock as a 
	inner join nasdaq_company as b on a.symbol = b.symbol 
where date = '2021-10-06'
	and convert(decimal(18,2),[close] - [open] / [open]*100 ) >= 10 --10�ۼ�Ʈ �̻� ������ 
	


-- ���� ����� ���� ������ 
select 
	b.symbol,
	b.company_name,
	b.sector,
	b.industry,
	date,
	convert(decimal(18,2),[open]) as [open],
	convert(decimal(18,2),[close]) as [close],
	convert(decimal(18,2),[close] - [open]) as diff_price,
	convert(decimal(18,2),[close] - [open] / [open]*100 ) as diff_ratio,
    '' AS '---',
	convert(decimal(18,2),[low]) as [low],
	convert(decimal(18,2),[high]) as [high],
	convert(decimal(18,2),[high] - [low]) as diff_high_price,
	convert(decimal(18,2),[high] - [low] / [low]*100 ) as diff_high_ratio into #temp 
from stock as a 
	inner join nasdaq_company as b on a.symbol = b.symbol 
	inner join industry_group_symbol as c on a.symbol = c.symbol 
	inner join industry_group as d on c.num = d.num
where a.date = '2021-10-06' 
	and d.industry = N'�ڵ���' 

select * from industry_group_symbol
select * from industry_group

select * from #temp 

select
TSLA
TM
SOLO
RIDE
NKLA
NIO
LI
KNDI
IDEX
GM
FSR
F

-- �࿭�� ġȯ�ؼ� ���� 

select 
	'Ratio Is' as increase_ratio,
	[F],
	[TSLA],
	[SOLO],
	[KNDI]
from (
	select 
		symbol, diff_high_ratio 
	from #temp 
) as source_table 
pivot(
	sum(diff_high_ratio)
	for symbol in ([F],[TSLA],[SOLO],[KNDI])
	)as pivot_table

-- ���� ��� ��� ���� �м� 
-- ���� ��¥�� ��� ���� ��¥�� ���� ��ġ���Ѽ� ������! 
-- SELF JOIN, LAG/LEAD 
-- SELF JOIN �Ҷ� ��Ī �� ����!

select 
	a.symbol,
	a.date as a_date,
	convert(decimal(18,2),a.[close]) as a_close, 
	'' as '----',
	b.date as b_date,
	convert(decimal(18,2),b.[close]) as b_close,
	'' as '----',
	convert(decimal(18,2), b.[close]-a.[close]) as diff_price,
	convert(decimal(18,2), b.[close]-a.[close] / b.[close]/100 ) as diff_ratio, 
	case when convert(decimal(18,2), b.[close]-a.[close]) > 0 then 'up' else 'down' end as upNdown
from stock as a
	inner join stock as b on a.symbol = b.symbol and
	a.date = dateadd(day, -1, b.date) -- b�� �Ϸ� ���� ������, �ʹ� �����ɸ���... 
where a.date = '2021-10-06' 

-- �̹��� lead �Լ��� ���� ��� ������ ������ �˻� 
select 
	x.symbol,
	x.date,
	convert(decimal(18,2),a_close) as a_close,
	convert(decimal(18,2), b_close ) as b_close,
	convert(decimal(18,2), b_close - a_close) as diff_price,
	convert(decimal(18,2), b_close - a_close / b_close * 100 ) as diff_ratio 	
from 
(select 
	symbol,
	date,
	[close] as a_close,
	lead([close]) over (partition by symbol order by date asc) as b_close
from stock 
where date >= '2021-10-06' and date <= '2021-10-07') as x 
where b_close is not null 
	and convert(decimal(18,2), b_close - a_close ) > 0 
order by symbol --null�� �ƴϰ� 0���� ũ�� 

-- cte ������ ����غ��� 
with cte_stock as (
	select 
		a.symbol,
		a.date as a_date,
		convert(decimal(18,2), a.[close]) as a_close,
		b.date as b_date, 
		convert(decimal(18,2), b.[close]) as b_close,
		convert(decimal(18,2), b.[close] - a.[close]) as diff_price, 
		convert(decimal(18,2), b.[close] - a.[close] / b.[close] * 100 ) as diff_ratio
	from stock as a 
	inner join stock as b on a.symbol = b.symbol and a.date = dateadd(day, -1, b.date) 
	where a.date = '2021-10-06')
	select * from (select top 3 * from cte_stock where diff_price > 0 order by diff_ratio desc ) as x 
	union all 
	select * from (select top 3 * from cte_stock where diff_price > 0 order by diff_ratio asc ) as y 
	
-- ���� 