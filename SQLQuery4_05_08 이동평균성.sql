-- ���ſ� ���� Ư�� ������ ��ٸ� � ����� �Ǿ����� Ȯ���غ��� 

use doitsql

-- �ӽ� ���̺� ���� 'mystock'
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

-- �̵� ��ռ� ���ϱ� 
-- ���� �Ⱓ�� �ְ��� ��� ����� ���� ��� ������ �� 
-- ���� 5�ϼ�, 20��, 60��, 120�� ������ �����ش�.
-- ���� ��¥�� ���� 5�� �̵�, 20�� �̵� ��հ��� �˻����� 

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

-- �ֽ� ������ Ư���� ��,��,�������� ������ �������� ������ �װ� �����ϰ� Ȱ���ϴ� 5��,20�ϸ� ���� 
-- cte�� ����� �Ϻ� ������ ���Ѵ����� ����� �˻����� 

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