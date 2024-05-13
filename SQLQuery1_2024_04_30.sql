-- ���� ���̺� �� �� �ַ� ������ ���̽��� ���� ���̺��� �ʿ� �� �� ����� �� �ִ�. 
-- cte �ȿ��� union, union all, intersect, except ���� ����� ���� ���� �Ϲ� cte ������ ���� �� �� �ִ�. 
-- �Ϲ� cte�� ������ ������ �ܼ��ϰ� ���� �� ����ϱ� ����. 


/* cte ����

with [cte_table] col
as 
(
select col from table 
)
select col from cte_table 

*/

-- with ���� cte ���̺�� ���� 
-- ���̺� ��� �� Į�� ���� 
-- ��� �� �÷��� as �ؿ� ������ select ���� �÷��� �����ؼ� ����. 

-- union, union all���� �������� �ߺ��� ������ �� ���� ���� 
-- union�� �ߺ��� ������ ����� �����ش�. 
-- union all�� �ߺ��� ������ ����� �����ش� 
-- ���� ������ union���ٴ� union all�� ����ϴ� ���� ����ȴ�. 


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

-- CTE �� �ȿ��� INTERSECT�� ����� ���� ���ΰ� ���������
-- INTERSECT�� �������� �����ϰ� ��ȯ�Ѵ�. 

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

-- EXCEPT �� NOT IN�� ��������� EXCEPT�� ��� ������ �ߺ��� ������
-- ������ ���� ��ȯ�ϰ� NOT IN ���� �ߺ��� �������� �ʴ´�. 

-- EXCEPT ���� ���� ������ ���� ����� �޶�����. 

WITH CTE_STOCK_PRICE (DATE, SYMBOL, [CLOSE])
AS 
( SELECT DATE, SYMBOL, [CLOSE]FROM DoItSQL.DBO.STOCK 
WHERE DATE >= '2021-01-01' AND DATE <= '2021-01-10' 
UNION ALL 
SELECT DATE, SYMBOL, [CLOSE]FROM DoItSQL.DBO.STOCK 
WHERE DATE >= '2021-02-01' AND DATE <= '2021-02-07' )
SELECT * FROM CTE_STOCK_PRICE WHERE SYMBOL ='MSFT' ORDER BY DATE 


-- �� ������ 1��1�Ϻ��� 10�� ������ ������ �� 1��7�Ϻ��� 20�ϱ����� �����Ϳ� ��ġ�� �ʴ� �͸� �����ش�. 
-- ���� ������ ���� ����� �޶� ����. 
WITH CTE_STOCK_PRICE (DATE, SYMBOL, [CLOSE])
AS 
( SELECT DATE, SYMBOL, [CLOSE]FROM DoItSQL.DBO.STOCK 
WHERE DATE >= '2021-01-01' AND DATE <= '2021-01-10' 
EXCEPT 
SELECT DATE, SYMBOL, [CLOSE]FROM DoItSQL.DBO.STOCK 
WHERE DATE >= '2021-01-07' AND DATE <= '2021-01-20' )
SELECT * FROM CTE_STOCK_PRICE WHERE SYMBOL ='MSFT' ORDER BY DATE 

-- ����, ���ĺ�, �ѱ� �� ~
use doitsql;
with cte(col_1) as(
select 'abc' union all 
select '123' union all 
select N'������' 
)
select * from cte 
order by col_1 asc; 

