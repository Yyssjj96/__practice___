-- 문자열 합치기 
select concat('str1',' ','str2')
select 'str1' + ' ' +'str2'

-- cast, convert는 한 데이터 형식의 식을 다른 데이터 형식으로 변환 
cast( expression as data_type[(length)] )
convert ( data_type[(length)], expression[,style]) 

/*
expression : 유효한 식 
data_type : 대상 데이터 형식으로 xml, bigint 및 sql_variant가 있다. 
length : data_type에 대한 길이를 지정, 기본값 30
style : convert 함수가 식을 반환하는 방법을 지정하는 정수식 null 스타일은 null 값 반환 
*/

-- 소수 자릿수가 다른 데이터 형식을 반환할 경우 sql server는 결과 값을 자르거나 반올림 할 수 있다. 

use DoItSQL

-- IPO YEAR를 문자로 바꾸고 출력한거 
select 
convert(nvarchar(50), ipo_year) + ' ' + open_price
from nasdaq_company
where symbol = 'MSFT' 

-- 숫자 + 날짜 연결 
SELECT 
IPO_YEAR + LAST_CRAWEL_DATE 
FROM nasdaq_company
WHERE SYMBOL = 'MSFT'

-- ISNULL: ISNULL(COL,넣을 값) 
-- COALESCE 
-- LOWER, UPPER 
-- TRIM 공백 제거 LTRIM, RTRIM, TRIM 
-- TRIM은 단어 앞 뒤에 공백과 함께 사용자 지정 문자도 제거 가능 하다. 
-- LEN 문자열 개수 반환 


SELECT DATALENGTH('     DO IT! SQL'), DATALENGTH('DO IT! SQL         ')

SELECT * FROM nasdaq_company

SELECT MAX(DATALENGTH(COMPANY_NAME)) FROM nasdaq_company 

SELECT COMPANY_NAME, LEN(COMPANY_NAME) FROM nasdaq_company
WHERE LEN(COMPANY_NAME) >= 30 

-- charindex 는 특정 문자까지의 길이를 반환 
-- 문자열 위치의 시작값은 1이다. 
/* 
charindex(
1. 찾으려는 시퀀스가 포함된 문자 식 
2. 검색 할 문자 식 
3. 검색이 시작되는 int 또는 bigint 값으로 지정되지 
않거나 음수 또는 0값이면 문자열 처음부터 검색 한다. 
*/

-- substring 함수는 지정한 범위의 문자열을 반환 한다. 
/* 
substring ( expression, start, length ) 
start : 반환할 문자의 시작 위치 지정, int or bigint 
length : 반환할 문자 수 지정 int or bigint 
*/

-- replace 함수는 지정 문자를 다른 문자로 대체 
/*
replace (
string_expression, string_pattern, string_replacement) 
*/ 

-- replicate 는 지정한 문자를 반복 할 때 사용 
/* 
replace( string_expression, integer_expression)
*/

-- reverse 함수는 문자열을 역순으로 표시 

-- stuff 함수는 지정한 범위의 문자열을 삭제하고 새 문자열을 끼워 넣는다. 
-- stuff ( character_expression, start, length, replace_expression ) 

-- str 함수는 cast convert 처럼 숫자를 문자열로 변환 
-- str (float_expression, [length [, decimal]])

select 'Do it!! SQL', CHARINDEX('!', 'Do it!! SQL') -- !의 위치 숫자로 반환 

select charindex(',',company_name), company_name from nasdaq_company)

declare @document varchar(64)
select @document = 'Reflectors vital are vital satety components of you bicycle'
select charindex('vital', @document, 15); -- 15로 지정하니 뒤에 바이탈의 번호가 나옴 
go  

select 'do it! sql', left('do it! sql',2) 

select substring ('do it! sql', 4, 2) 
select substring (company_name,2,3), company_name from nasdaq_company -- 자주 사용한다! 


-- charindex @ 찾고 거기서 -1 하면 아이디 정보만 가져온다. 
select substring('email@aaa.com', 1, charindex('@','email@aaa.com') -1 ) 

select replace ('abcdefghijk','cde','xxx')

declare @str nvarchar(100), @len int, @len2 int; 
set @str = 'this is a sentence with spaces in it.';
set @len = len(@str);
set @str = replace(@str, ' ', '');
set @len2 = len(@str); 
select 'number of spaces in the string : ' + convert(nvarchar(20), @len - @len2);

select replicate('1', 50)

select 
replace(symbol ,'A', REPLICATE('C',100)), SYMBOL FROM nasdaq_company
where symbol like '%a%'

select reverse(1234) 
-- reverse 사용법 

with ip_list(ip)
as(
select '192.168.0.1' union all 
select '10.6.100.99' union all 
select '8.8.8.8' union all 
select '192.200.212.113' )
select ip, substring(ip,1,len(ip) - charindex('.',reverse(ip)))
from ip_list 

select stuff ('abcdef',2,3,'ijklmn'); -- 2부터 3개 

select str(123.45, 2, 2)
