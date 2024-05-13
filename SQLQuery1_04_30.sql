-- ���ڿ� ��ġ�� 
select concat('str1',' ','str2')
select 'str1' + ' ' +'str2'

-- cast, convert�� �� ������ ������ ���� �ٸ� ������ �������� ��ȯ 
cast( expression as data_type[(length)] )
convert ( data_type[(length)], expression[,style]) 

/*
expression : ��ȿ�� �� 
data_type : ��� ������ �������� xml, bigint �� sql_variant�� �ִ�. 
length : data_type�� ���� ���̸� ����, �⺻�� 30
style : convert �Լ��� ���� ��ȯ�ϴ� ����� �����ϴ� ������ null ��Ÿ���� null �� ��ȯ 
*/

-- �Ҽ� �ڸ����� �ٸ� ������ ������ ��ȯ�� ��� sql server�� ��� ���� �ڸ��ų� �ݿø� �� �� �ִ�. 

use DoItSQL

-- IPO YEAR�� ���ڷ� �ٲٰ� ����Ѱ� 
select 
convert(nvarchar(50), ipo_year) + ' ' + open_price
from nasdaq_company
where symbol = 'MSFT' 

-- ���� + ��¥ ���� 
SELECT 
IPO_YEAR + LAST_CRAWEL_DATE 
FROM nasdaq_company
WHERE SYMBOL = 'MSFT'

-- ISNULL: ISNULL(COL,���� ��) 
-- COALESCE 
-- LOWER, UPPER 
-- TRIM ���� ���� LTRIM, RTRIM, TRIM 
-- TRIM�� �ܾ� �� �ڿ� ����� �Բ� ����� ���� ���ڵ� ���� ���� �ϴ�. 
-- LEN ���ڿ� ���� ��ȯ 


SELECT DATALENGTH('     DO IT! SQL'), DATALENGTH('DO IT! SQL         ')

SELECT * FROM nasdaq_company

SELECT MAX(DATALENGTH(COMPANY_NAME)) FROM nasdaq_company 

SELECT COMPANY_NAME, LEN(COMPANY_NAME) FROM nasdaq_company
WHERE LEN(COMPANY_NAME) >= 30 

-- charindex �� Ư�� ���ڱ����� ���̸� ��ȯ 
-- ���ڿ� ��ġ�� ���۰��� 1�̴�. 
/* 
charindex(
1. ã������ �������� ���Ե� ���� �� 
2. �˻� �� ���� �� 
3. �˻��� ���۵Ǵ� int �Ǵ� bigint ������ �������� 
�ʰų� ���� �Ǵ� 0���̸� ���ڿ� ó������ �˻� �Ѵ�. 
*/

-- substring �Լ��� ������ ������ ���ڿ��� ��ȯ �Ѵ�. 
/* 
substring ( expression, start, length ) 
start : ��ȯ�� ������ ���� ��ġ ����, int or bigint 
length : ��ȯ�� ���� �� ���� int or bigint 
*/

-- replace �Լ��� ���� ���ڸ� �ٸ� ���ڷ� ��ü 
/*
replace (
string_expression, string_pattern, string_replacement) 
*/ 

-- replicate �� ������ ���ڸ� �ݺ� �� �� ��� 
/* 
replace( string_expression, integer_expression)
*/

-- reverse �Լ��� ���ڿ��� �������� ǥ�� 

-- stuff �Լ��� ������ ������ ���ڿ��� �����ϰ� �� ���ڿ��� ���� �ִ´�. 
-- stuff ( character_expression, start, length, replace_expression ) 

-- str �Լ��� cast convert ó�� ���ڸ� ���ڿ��� ��ȯ 
-- str (float_expression, [length [, decimal]])

select 'Do it!! SQL', CHARINDEX('!', 'Do it!! SQL') -- !�� ��ġ ���ڷ� ��ȯ 

select charindex(',',company_name), company_name from nasdaq_company)

declare @document varchar(64)
select @document = 'Reflectors vital are vital satety components of you bicycle'
select charindex('vital', @document, 15); -- 15�� �����ϴ� �ڿ� ����Ż�� ��ȣ�� ���� 
go  

select 'do it! sql', left('do it! sql',2) 

select substring ('do it! sql', 4, 2) 
select substring (company_name,2,3), company_name from nasdaq_company -- ���� ����Ѵ�! 


-- charindex @ ã�� �ű⼭ -1 �ϸ� ���̵� ������ �����´�. 
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
-- reverse ���� 

with ip_list(ip)
as(
select '192.168.0.1' union all 
select '10.6.100.99' union all 
select '8.8.8.8' union all 
select '192.200.212.113' )
select ip, substring(ip,1,len(ip) - charindex('.',reverse(ip)))
from ip_list 

select stuff ('abcdef',2,3,'ijklmn'); -- 2���� 3�� 

select str(123.45, 2, 2)