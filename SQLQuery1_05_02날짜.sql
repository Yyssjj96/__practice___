-- getdate : ���� �������� �����ͺ��̽� ������ �ð��� �Ҽ��� 3�ڸ� ���� ��ȯ 
-- sysdatetime : ���� �������� �����ͺ��̽� ������ �ð��� �Ҽ��� 7�ڸ� ���� ��ȯ 

-- �� �Լ����� ȣ�� �� ������ �ٸ� ���� ��ȯ�ؼ� ������� �Լ��� �Ѵ�. 

-- getdate(), sysdatetime() 

-- utc�� ���� �����÷� �� �������� �ð��� �ٸ��� ������ �����谡 ���� �ð� ������ ��� �� �� ��� 

-- getutcdate : ���� �������� ���� ������ ��ȯ 

-- dateadd �Լ��� ��¥�� ���ϰų� �� �� �ִ�. 
-- year, quarter, day �� �پ��� ��¥ ���� ��� ���� 

-- dateadd(datepart, number, date) 

-- datediff �� �� ��¥�� ���̸� ���� �� �󤵤� 
-- datediff_big �� ���̰� Ŭ �� ���
-- datediff (datepart, startdate, enddate) 

-- datepart, datename �Լ��� ������ ��¥�� �Ϻθ� ��ȯ 
-- datepart �Լ��� ��ȯ���� ������ �̸� 1�� ��ȯ 
-- datename �� ������ �׷��� ��ȯ 
-- datepart(datepart, date) , datename(datepart,date) 


-- day, month, year �� ���� ��, ��, ���� �����´� 

select getdate() 
select sysdatetime()
select getutcdate() 
select sysutcdatetime()

select getdate(), dateadd(year, 1, getdate()) -- 1�� �� 



declare @datetime2 datetime2 = '2021-08-01 13:10:10.1111111' ;
select 'year', dateadd(year,1,@datetime2) 
union all 
select 'quarter', dateadd(quarter,1,@datetime2) 
union all 
select 'month', dateadd( month,1,@datetime2) 

select datediff(day, '2019-12-31 23:59:59.9999999', '2021-01-01 00:00:00.0000000')

use DoItSQL

select symbol, last_crawel_date,
datename(year, last_crawel_date),
datename(month, last_crawel_date),
datename(day, last_crawel_date),
datename(weekday,last_crawel_date)
from nasdaq_company

select symbol, last_crawel_date,
year(last_crawel_date),
month(last_crawel_date),
day(last_crawel_date)
from nasdaq_company

-- ��¥ ������ �����ʹ� convert �Լ��� �Բ� ��Ÿ�� �ɼ��� ����ϸ� �پ��� ǥ���� �����ϴ� 

-- ��¥ ���ڿ��� DATETIME2(0) �������� ��ȯ �ϰ� �̸� CEST �ð���� ��ȯ 
SELECT CONVERT(datetime2(0), '2015-03-29 01:01:00', 126)
AT TIME ZONE 'Central European Standard Time';

SELECT 
LAST_CRAWEL_DATE AT TIME ZONE 'Pacific Standard Time'
AT TIME ZONE 'Central European Standard Time' 
from nasdaq_company

-- ���� ������ �����ͺ��̽��� Ÿ���� Ȯ�� 
select current_timezone()

select getdate() 

declare @now_date datetime = getdate() 
select convert (nvarchar(20), @now_date, 100) as [�⺻��]
select convert (nvarchar(20), @now_date, 101) as [�̱�]
select convert (nvarchar(20), @now_date, 102) as [ansi]
select convert (nvarchar(20), @now_date, 120) as [odbc ǥ��]

select * from nasdaq_company

select last_crawel_date at time zone 'Pacific Standard Time' from nasdaq_company

