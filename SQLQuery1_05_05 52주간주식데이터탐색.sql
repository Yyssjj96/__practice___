-- 52�ְ��� �ְ�, �������� ���ϰ� ���̸� ����. 
-- ��������� ��� ��ġ�� ���� 
-- ������ ū ������� ������ �������� ������������ ������ 

/* �ֽ� �м������� ����ϴ� ���̺��� ���� 
nasdaq_company = ����� ���� 
stock = ����� ���� �ְ� ���� 
industry_group_symbol = �׷� ���� ��Ƴ� �ɺ� ���� 
industry_group = ����� ��� ������ ����Ű ���� 
*/

-- stock = datetime ���� float ����� symbol = nvarchar(255)

use doitsql 

-- 52�ְ� �ּ�, �ִ� ���� ���� ���� ���̸� ����! 
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

-- ���������ε� ������! 
-- ������ ���� �� 0���� �־ �� 
select 
x.symbol,
w52_min, 
w52_max,
w52_max - w52_min as w52_diff_price, 
(w52_max - w52_min) / w52_min * 100 as w52_diff_ratio
-- ���������� ���� ¥���� ����ؼ� 0���� ���ԵǾ� ������. 
-- �ذ�� : convert (decimal(18,2), case when w52_min > 0 then (w52_max - w52_min) / w52_min * 100 else 0 end ) as w52_diff_ratio 
from ( 
	select 
		symbol, 
		convert(decimal(18,2), min([close])) as w52_min,
		convert(decimal(18,2), max([close])) as w52_max 
		from stock 
		where date >= dateadd(week,-52,'2021-10-04')
			and date <= '2021-10-04'
		group by symbol) as x 

-- ���� ������ �ֱ� ��¼� ���� ����! 

-- ������ ��Ͻ� ���� ���� ��¥ ���غ��� 
select 
	max(a.date) as date, 
	a.symbol, 
	a.[close] into #temp_min -- �� ���ǿ����� �۵��ϴ� �ӽ����̺� 
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

-- �ְ� ��Ͻ� ���� ���� ��¥ 
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


-- �ӽ����̺� Ȯ�� 
select * from #temp_min
select * from #temp_max 

-- ���ļ� Ȯ���غ��� 
-- �ֱ� ��¥�� ������ ����ؼ� ������� 
select 
	b.symbol,
	case when b.date >= a.date then 'Y' else 'N' end as increase_yn 
from #temp_min as a 
	inner join #temp_max b on a.symbol = b.symbol 

-- 52�ְ��� �ּ�, �ִ밪���� ������� ���� ã�� 
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








