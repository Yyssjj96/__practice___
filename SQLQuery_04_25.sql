create table doit_cross1(num int) 
insert into doit_cross1 values (1),(2),(3)

select * from doit_cross1 

create table doit_cross2(name nvarchar(10))
insert into doit_cross2 values (N'Do'),(N'It'),(N'SQL')

-- CROSS JOIN 이해해보기  
SELECT 
	A.NUM,
	B.NAME
FROM DOIT_CROSS1 A
	CROSS JOIN DOIT_CROSS2 B 
WHERE NUM = 1

DROP TABLE doit_cross2

-- SELF JOIN 

SELECT 
	A.SYMBOL, B.COMPANY_NAME -- ALIAS 필수		
FROM DoItSQL.DBO.nasdaq_company AS A 
	INNER JOIN DoItSQL.DBO.nasdaq_company AS B 
	ON A.SYMBOL = B.SYMBOL 

-- 오늘의 데이터와 어제의 데이터의 차이를 보여주는 쿼리문 
SELECT
	A.DATE AS A_DATE,
	A.[close] AS A_CLOSE,
	B.DATE AS B_DATE,
	B.[CLOSE] AS B_CLOSE,
	B.[CLOSE] - A.[CLOSE] AS CAL
FROM DoItSQL.DBO.STOCK AS A  
	LEFT OUTER JOIN DOITSQL.DBO.STOCK AS B ON A.DATE = DATEADD(DAY, -1, B.DATE) AND A.SYMBOL=B.SYMBOL
WHERE A.SYMBOL = N'MSFT'
AND A.DATE >= '2021-10-01' AND A.DATE < '2021-11-01'
AND B.DATE >= '2021-10-01' AND B.DATE < '2021-11-01'
ORDER BY A.DATE 

CREATE TABLE DOIT_LEFT_A(
COL_A NVARCHAR(10),
COL_B INT )

CREATE TABLE DOIT_LEFT_B(
COL_A NVARCHAR(10),
COL_B NVARCHAR(10),)

INSERT INTO DOIT_LEFT_A VALUES ('A',10)
INSERT INTO DOIT_LEFT_A VALUES ('B',20)
INSERT INTO DOIT_LEFT_A VALUES ('C',30)
INSERT INTO DOIT_LEFT_A VALUES ('D',40)
INSERT INTO DOIT_LEFT_A VALUES ('D',50)

INSERT INTO DOIT_LEFT_B VALUES ('A','FAST')
INSERT INTO DOIT_LEFT_B VALUES ('C','CAMPUS')
INSERT INTO DOIT_LEFT_B VALUES ('D','DOIT')
INSERT INTO DOIT_LEFT_B VALUES ('D','YOU')

SELECT 
A.*, B.*
FROM DOIT_LEFT_A AS A 
LEFT OUTER JOIN DOIT_LEFT_B AS B ON A.COL_A = B.COL_A