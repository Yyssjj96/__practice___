-- �϶� ���� �������� ����� ���� ������ ã�ƺ��� 
use doitsql 

-- 2��17�� ���� 2��24�ϱ��� �϶����� �ʰ� 10% �̻� ���� ���� ���� 


-- �Ⱓ ���� ���� ���� ��� 
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

-- ���� ���� �������� ������ �� 
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

-- #temp3 ���� �϶��� ���� �ֵ鸸 �������� 
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

-- �϶� �� �� ȸ���� ���� �м� 
-- 2020 3�� �ڷγ��� ���� �ֽ� ������ ū �϶�, �ڷγ��� �߻��ϱ� 1���� ��� 
-- ���� ���ݰ� ���� ���� ����, ���� ���� ������ ���Ͽ� ���� 

-- 1.���� ��¥ ���� 
select 
	symbol,
	avg([close]) as [close] 
	into #temp1 
from stock 
where date >= '2021-05-31' and date < '2021-06-04' 
group by symbol

select * from #temp1 

-- 2. 1���� ���� ������ ���� 
select 
	symbol,
	avg([close]) as [close] 
	into #temp2
from stock 
where date >= '2021-06-28' and date < '2021-07-02' 
group by symbol

select * from #temp2 

-- 3. 1���� ���� ������ ���� 
select 
	symbol,
	avg([close]) as [close] 
	into #temp3
from stock 
where date >= '2021-07-05' and date < '2021-07-09' 
group by symbol

-- 4 �ӽ� ���̺��� ������ ���� ������ ���� 
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
	
-- 5 ���ǿ� �´� ������ �˻� 
-- #temp1 ��� #temp2�� 20% �϶��� ���� �߿� #temp3 ȸ�� ������ -20%~10%�� ���� 
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
-- �̷��� ������ �� �ְ����� ���� ȸ���� �� �Ǽ� �� �ö� ��̰� ���δ�. 


