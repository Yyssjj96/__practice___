-- where ���������� nested subquery , ��ø ���� ���� 
-- ���ǹ��� �Ϻη� ��� 
-- �� �����ڿ� ��� �� �� �ִµ� �׷� ��� ����� 1���̾�� �Ѵ�
-- 2�� �̻��̸� ���� �� �����ڸ� ��� �ؾ� �Ѵ� 

/* ���� �� ��������

select (col) 
from table 
where (col) = (select <col> from table)

�� �������� '=' �� ���� 

*/

/* ���� �� �������� 

select * from nasdaq_company
where symbol in (
select symbol from nasdaq_company
where symbol in ('MSFT','AMD','AMZN')

*/

USE DOITSQL

SELECT 
A.industry,
C.symbol,
C.company_name,
C.ipo_year,
C.sector
FROM industry_group AS A  -- FROM �� ���� Ȯ�� �ϴ°� �м��� ���� 
INNER JOIN industry_group_symbol AS B ON A.NUM = B.NUM 
INNER JOIN nasdaq_company AS C ON B.SYMBOL = C.SYMBOL
WHERE A.industry = N'�ڵ���'
ORDER BY SYMBOL 

-- ���� ������ ���������� �غ��� 

SELECT *
FROM nasdaq_company
WHERE SYMBOL IN ( 
	SELECT SYMBOL FROM industry_group AS A 
	INNER JOIN industry_group_symbol AS B 
		ON A.NUM = B.NUM 
	WHERE A.industry = N'�ڵ���')

-- IN, ANY = �ϳ��� �����ϸ� ��ȯ 
-- EXIST, NOT EXIST ������ ������� �ִ��� ������, ������ TRUE ������ FALSE 


-- ANY 
SELECT * FROM NASDAQ_COMPANY 
WHERE SYMBOL = ANY (
	SELECT SYMBOL FROM NASDAQ_COMPANY
	WHERE SYMBOL IN ('MSFT','AMD','AMZN')
	)

-- ANY ? 
	SELECT * FROM NASDAQ_COMPANY 
WHERE SYMBOL > ANY (
	SELECT SYMBOL FROM NASDAQ_COMPANY
	WHERE SYMBOL IN ('MSFT','LTCH','ZY')
	)

-- EXIST ���������� TRUE �� �������� ���� 
SELECT * FROM NASDAQ_COMPANY 
WHERE EXISTS (
	SELECT SYMBOL FROM NASDAQ_COMPANY
	WHERE SYMBOL IN ('MSFT','AMD','AMZN')
	)	

-- ALL ���� �� �����ؾ� �������� ���� 
SELECT * FROM NASDAQ_COMPANY 
WHERE SYMBOL = ALL (
	SELECT SYMBOL FROM NASDAQ_COMPANY
	WHERE SYMBOL IN ('MSFT','LTCH','ZY')
	)

-- ���� IN, EXIST ���� ����Ѵٰ� �մϴ�~


/* 
FROM ���� ���� ���� ��� 
�ζ��� �� ��� �Ѵ� 
SELECT ���� ����� FROM ������ �ϳ��� ���̺� ó�� ����ϰ� ���� �� 
FROM ���� ����ϴ� ���� ���� ����� ���� �� �� �����Ƿ� 
������ �������� �ݸ� �� �� �ִ�. �ȿ� �ִ� ���������� ��� ����

SELECT <COL> FROM 
�������� (�ζ��� ��) AS A 
�������� (�ζ��� ��) AS B 
ON A.COL = B.COL 
WHERE COL = VALUE

�ζ��� �� ���������� �ݵ�� ��Ī ��� 
�ζ��� �� ���� �⺻������ ORDER BY ��� �Ұ� 
Ư�� �� ��� ��� ���� 
*/

SELECT 
A.SYMBOL , A.company_name, A.ipo_year, A.sector, A.industry,
B.DATE, B.[open], B.[high],B.[LOW],B.[CLOSE], B.adj_close
FROM nasdaq_company A 
INNER JOIN STOCK AS B ON A.SYMBOL = B.SYMBOL 
WHERE A.SYMBOL = 'MSFT'
AND B.DATE >= '2021-10-01'
AND B.DATE < '2021-11-01'

-- �̰� �ζ��κ�� �ٲ㺸�� 
-- STOCK ���̺��� ������ ���缭 ���� �����ϰ� �����Ѵ�. 
SELECT 
A.SYMBOL , A.company_name, A.ipo_year, A.sector, A.industry,
B.DATE, B.[open], B.[high],B.[LOW],B.[CLOSE], B.adj_close
FROM nasdaq_company AS A 
INNER JOIN (SELECT SYMBOL, DATE, [OPEN],[HIGH],[CLOSE],[LOW],
ADJ_CLOSE, VOLUME FROM STOCK 
WHERE SYMBOL = 'MSFT'
AND DATE >= '2021-10-01'
AND DATE < '2021-11-01'
) AS B ON A.SYMBOL = B.SYMBOL 

-- JOIN SUBQUERY�� �����ϸ� �� ���� ������ ���� ���� ����غ��� 


-- ALIAS�� ���� ������ ������ ����. 
SELECT * 
FROM(
	SELECT * FROM DoItSQL.DBO.nasdaq_company
	) AS A 


-- ORDER BY ���� ��� �Ұ������� TOP10���� Ư¡�� ������ ��밡�� 
SELECT 
	A.*
FROM DoItSQL.DBO.nasdaq_company AS A 
	INNER JOIN (
		SELECT TOP 10 SYMBOL
		FROM DoItSQL.DBO.nasdaq_company
		WHERE SYMBOL LIKE 'A%'
		ORDER BY ipo_year
		) AS B ON A.SYMBOL = B.SYMBOL 


SELECT 
	A.*,B.*,C.*
FROM DoItSQL.DBO.nasdaq_company AS A 
	INNER JOIN DoItSQL.dbo.STOCK AS B ON A.SYMBOL = B.SYMBOL 
	INNER JOIN DoItSQL.DBO.industry_group_symbol AS C ON A.SYMBOL = C.SYMBOL
	INNER JOIN DoItSQL.DBO.industry_group AS D ON C.NUM = D.NUM 
WHERE A.SYMBOL = 'MSFT'
	AND B.DATE >='2021-10-01'
	AND B.DATE < '2021-11-01'

-- ���� ������ ���������� �ٲ㺸�� 

SELECT A.*, C.INDUSTRY 
FROM (
SELECT 
	A.*,B.NUM 
FROM(
SELECT 
	A.*,B.*
FROM DoItSQL.DBO.nasdaq_company AS A 
	INNER JOIN 
	(SELECT 
	SYMBOL, DATE, [OPEN],[HIGH],[LOW],[CLOSE],ADJ_CLOSE, VOLUME
	FROM DoItSQL.DBO.STOCK 
	WHERE SYMBOL ='MSFT'
		AND DATE >= '2021-10-01'
		AND DATE < '2021-11-01'
	) AS B ON A.SYMBOL = B.SYMBOL ) 
	AS A INNER JOIN DoItSQL.DBO.industry_group_symbol AS B ON A.SYMBOL = B.SYMBOL 
	)
	AS A INNER JOIN DoItSQL.DBO.industry_group AS C ON A.NUM = C.NUM

-- WHERE ��ø��������, FROM �ζ��� ��, SELECT ��Į�� ���� ���� 
-- ��Į�� ���� ������ �ݵ�� �ϳ��� ���� ��� �Ѵ�. 
-- �׷��Ƿ� ���� SUM, COUNT, MIN, MAX �� ���� �����Լ��� ���� ���̴� ��찡 ����. 
-- ��Į�� ���������� �������� -> �������� ������ ���صȴ�. 
-- ���� ���� ��� �Ǽ� ��ŭ ���� ������ ����Ǳ� ������ ������ ���� ��� ���� ������ �߻� 
-- �������� ���� ������� �ʴµ�... 
 
/* SELECT <COL>
	�������� 
	�������� 
	�������� 
	�������� 
FROM TABLE_NAME 
WHERE <COL> = <VALUE> */ 



