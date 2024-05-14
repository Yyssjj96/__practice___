-- where 서브쿼리는 nested subquery , 중첩 서브 쿼리 
-- 조건문의 일부로 사용 
-- 비교 연산자와 사용 할 수 있는데 그럴 경우 결과가 1건이어야 한다
-- 2건 이상이면 다중 행 연산자를 사용 해야 한다 

/* 단일 행 서브쿼리

select (col) 
from table 
where (col) = (select <col> from table)

비교 연산자인 '=' 가 쓰임 

*/

/* 다중 행 서브쿼리 

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
FROM industry_group AS A  -- FROM 절 먼저 확인 하는게 분석에 좋음 
INNER JOIN industry_group_symbol AS B ON A.NUM = B.NUM 
INNER JOIN nasdaq_company AS C ON B.SYMBOL = C.SYMBOL
WHERE A.industry = N'자동차'
ORDER BY SYMBOL 

-- 위의 쿼리를 서브쿼리로 해보자 

SELECT *
FROM nasdaq_company
WHERE SYMBOL IN ( 
	SELECT SYMBOL FROM industry_group AS A 
	INNER JOIN industry_group_symbol AS B 
		ON A.NUM = B.NUM 
	WHERE A.industry = N'자동차')

-- IN, ANY = 하나라도 만족하면 반환 
-- EXIST, NOT EXIST 조건의 결과값이 있는지 없는지, 있으면 TRUE 없으면 FALSE 


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

-- EXIST 서브쿼리가 TRUE 면 메인쿼리 실행 
SELECT * FROM NASDAQ_COMPANY 
WHERE EXISTS (
	SELECT SYMBOL FROM NASDAQ_COMPANY
	WHERE SYMBOL IN ('MSFT','AMD','AMZN')
	)	

-- ALL 세개 다 만족해야 메인쿼리 실행 
SELECT * FROM NASDAQ_COMPANY 
WHERE SYMBOL = ALL (
	SELECT SYMBOL FROM NASDAQ_COMPANY
	WHERE SYMBOL IN ('MSFT','LTCH','ZY')
	)

-- 보통 IN, EXIST 많이 사용한다고 합니다~


/* 
FROM 절에 서브 쿼리 사용 
인라인 뷰 라고 한다 
SELECT 절의 결과를 FROM 절에서 하나의 테이블 처럼 사용하고 싶을 때 
FROM 문에 사용하는 서브 쿼리 결과는 조인 할 수 있으므로 
쿼리를 논리적으로 격리 할 수 있다. 안에 있는 서브쿼리만 사용 가능

SELECT <COL> FROM 
서브쿼리 (인라인 뷰) AS A 
서브쿼리 (인라인 뷰) AS B 
ON A.COL = B.COL 
WHERE COL = VALUE

인라인 뷰 서브쿼리는 반드시 별칭 사용 
인라인 뷰 에는 기본적으로 ORDER BY 사용 불가 
특별 할 경우 사용 가능 
*/

SELECT 
A.SYMBOL , A.company_name, A.ipo_year, A.sector, A.industry,
B.DATE, B.[open], B.[high],B.[LOW],B.[CLOSE], B.adj_close
FROM nasdaq_company A 
INNER JOIN STOCK AS B ON A.SYMBOL = B.SYMBOL 
WHERE A.SYMBOL = 'MSFT'
AND B.DATE >= '2021-10-01'
AND B.DATE < '2021-11-01'

-- 이걸 인라인뷰로 바꿔보자 
-- STOCK 테이블을 조건을 갖춰서 먼저 추출하고 조인한다. 
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

-- JOIN SUBQUERY를 생각하며 더 좋은 성능의 쿼리 문을 사용해보자 


-- ALIAS를 쓰지 않으면 에러가 난다. 
SELECT * 
FROM(
	SELECT * FROM DoItSQL.DBO.nasdaq_company
	) AS A 


-- ORDER BY 절은 사용 불가하지마 TOP10같은 특징이 있으면 사용가능 
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

-- 위의 쿼리를 서브쿼리로 바꿔보자 

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

-- WHERE 중첩서브쿼리, FROM 인라인 뷰, SELECT 스칼라 서브 쿼리 
-- 스칼라 서브 쿼리는 반드시 하나의 값을 출력 한다. 
-- 그러므로 보통 SUM, COUNT, MIN, MAX 와 같은 집계함수와 같이 쓰이는 경우가 많다. 
-- 스칼라 서브쿼리는 메인쿼리 -> 서브쿼리 순서로 실해된다. 
-- 메인 쿼리 결과 건수 만큼 서브 쿼리가 실행되기 때문에 집합이 많은 경우 성능 문제가 발생 
-- 현업에서 별로 권장되지 않는데... 
 
/* SELECT <COL>
	서브쿼리 
	서브쿼리 
	서브쿼리 
	서브쿼리 
FROM TABLE_NAME 
WHERE <COL> = <VALUE> */ 



