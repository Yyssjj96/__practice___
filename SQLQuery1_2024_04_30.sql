-- 공통 테이블 식 은 주로 데이터 베이스에 없는 테이블이 필요 할 때 사용할 수 있다. 
-- cte 안에서 union, union all, intersect, except 문을 사용해 여러 개의 일반 cte 쿼리를 결합 할 수 있다. 
-- 일반 cte는 복잡한 쿼리를 단순하게 만들 때 사용하기 좋다. 


/* cte 문법

with [cte_table] col
as 
(
select col from table 
)
select col from cte_table 

*/

-- with 다음 cte 테이블명 지정 
-- 테이블에 사용 할 칼럼 지정 
-- 사용 할 컬럼을 as 밑에 나오는 select 문에 컬럼을 지정해서 쓴다. 

-- union, union all문의 차이점은 중복을 제거한 행 포함 여부 
-- union은 중복을 제거한 결과를 보여준다. 
-- union all은 중복을 포함한 결과를 보여준다 
-- 성능 문제로 union보다는 union all을 사용하는 것이 권장된다. 


with cte_stock_price(date,symbol,price)
as
(
select date,symbol,[close] from stock 
where date >= '2021-01-01' and date <= '2021-01-10'
union all 
select date, symbol, [close] from stock 
where date >= '2021-02-01' and date <= '2021-02-07' 
)
select * from cte_stock_price where symbol = 'MSFT'

-- CTE 문 안에서 INTERSECT문 사용은 내부 조인과 비슷하지만
-- INTERSECT는 교집합을 제거하고 반환한다. 

with cte_stock_price(date,symbol,price)
as
(
select date,symbol,[close] from stock 
where date >= '2021-01-01' and date <= '2021-01-10'
INTERSECT 
select date, symbol, [close] from stock 
where date >= '2021-01-07' AND DATE <= '2021-01-20'
)
select * from cte_stock_price where symbol = 'MSFT'

-- EXCEPT 은 NOT IN과 비슷하지만 EXCEPT은 결과 값에서 중복을 제거한
-- 유일한 행을 반환하고 NOT IN 문은 중복을 제거하지 않는다. 

-- EXCEPT 문은 쿼리 순서에 따라 결과가 달라진다. 

WITH CTE_STOCK_PRICE (DATE, SYMBOL, [CLOSE])
AS 
( SELECT DATE, SYMBOL, [CLOSE]FROM DoItSQL.DBO.STOCK 
WHERE DATE >= '2021-01-01' AND DATE <= '2021-01-10' 
UNION ALL 
SELECT DATE, SYMBOL, [CLOSE]FROM DoItSQL.DBO.STOCK 
WHERE DATE >= '2021-02-01' AND DATE <= '2021-02-07' )
SELECT * FROM CTE_STOCK_PRICE WHERE SYMBOL ='MSFT' ORDER BY DATE 


-- 밑 쿼리는 1월1일부터 10일 까지의 데이터 중 1월7일부터 20일까지의 데이터와 겹치지 않는 것만 보여준다. 
-- 쿼리 순서에 따라 결과가 달라 진다. 
WITH CTE_STOCK_PRICE (DATE, SYMBOL, [CLOSE])
AS 
( SELECT DATE, SYMBOL, [CLOSE]FROM DoItSQL.DBO.STOCK 
WHERE DATE >= '2021-01-01' AND DATE <= '2021-01-10' 
EXCEPT 
SELECT DATE, SYMBOL, [CLOSE]FROM DoItSQL.DBO.STOCK 
WHERE DATE >= '2021-01-07' AND DATE <= '2021-01-20' )
SELECT * FROM CTE_STOCK_PRICE WHERE SYMBOL ='MSFT' ORDER BY DATE 

-- 숫자, 알파벳, 한글 순 ~
use doitsql;
with cte(col_1) as(
select 'abc' union all 
select '123' union all 
select N'가나다' 
)
select * from cte 
order by col_1 asc; 

