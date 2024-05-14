-- getdate : 현재 접속중인 데이터베이스 서버의 시간을 소수점 3자리 까지 반환 
-- sysdatetime : 현재 접속중인 데이터베이스 서버의 시간을 소수점 7자리 까지 반환 

-- 이 함수들은 호출 할 때마다 다른 값을 반환해서 비결정적 함수라 한다. 

-- getdate(), sysdatetime() 

-- utc는 세계 협정시로 각 국가마다 시간이 다르디 때문에 전세계가 같은 시간 기준을 사용 할 때 사용 

-- getutcdate : 현재 접속중인 세계 협정시 반환 

-- dateadd 함수는 날짜를 더하거나 뺄 수 있다. 
-- year, quarter, day 등 다양한 날짜 형식 사용 가능 

-- dateadd(datepart, number, date) 

-- datediff 는 두 날짜의 차이를 구할 때 상ㅅㅇ 
-- datediff_big 은 차이가 클 때 사용
-- datediff (datepart, startdate, enddate) 

-- datepart, datename 함수는 지정된 날짜의 일부를 반환 
-- datepart 함수는 반환값이 월요일 이면 1로 반환 
-- datename 은 월요일 그래도 반환 
-- datepart(datepart, date) , datename(datepart,date) 


-- day, month, year 은 각각 일, 월, 년을 가져온다 

select getdate() 
select sysdatetime()
select getutcdate() 
select sysutcdatetime()

select getdate(), dateadd(year, 1, getdate()) -- 1년 후 



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

-- 날짜 형식의 데이터는 convert 함수와 함께 스타일 옵션을 사용하면 다양한 표현이 가능하다 

-- 날짜 문자열을 DATETIME2(0) 형식으로 변환 하고 이를 CEST 시간대로 변환 
SELECT CONVERT(datetime2(0), '2015-03-29 01:01:00', 126)
AT TIME ZONE 'Central European Standard Time';

SELECT 
LAST_CRAWEL_DATE AT TIME ZONE 'Pacific Standard Time'
AT TIME ZONE 'Central European Standard Time' 
from nasdaq_company

-- 현재 접속한 데이터베이스의 타임존 확인 
select current_timezone()

select getdate() 

declare @now_date datetime = getdate() 
select convert (nvarchar(20), @now_date, 100) as [기본값]
select convert (nvarchar(20), @now_date, 101) as [미국]
select convert (nvarchar(20), @now_date, 102) as [ansi]
select convert (nvarchar(20), @now_date, 120) as [odbc 표준]

select * from nasdaq_company

select last_crawel_date at time zone 'Pacific Standard Time' from nasdaq_company

