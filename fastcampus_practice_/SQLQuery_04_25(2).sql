select 
a.symbol,  -- 별칭 잘 쓰자잉 
a.last_crawel_date,
b.date
from nasdaq_company a -- 별칭 잘 지정하자잉 
	inner join stock b on a.last_crawel_date = b.date
where a.symbol = 'MSFT'

-- inner join 
-- 꼭 같은 이름의 열로 안해도된다. 
-- 다만 이렇게 잘 안한다. 

select 
	a.industry,
	c.symbol,
	c.company_name,
	c.ipo_year,
	c.sector
from industry_group as a 
	inner join industry_group_symbol as b on a.num=b.num 
	inner join nasdaq_company as c on b.symbol = c.symbol 

-- a,b 와는 inner join, 그 다음엔 b,c 이너조인 

-- 고객 주문 테이블이 있을 때 어떤 고객이 주문을 했나, 안 했나
-- 확인하려면 고객 테이블 기준 left join 해주면 된다 
-- 한 곳 기준 null 값이 나올 수 있게 하고 싶다면 left, right join 사용 

-- left, right (outer) join 은 두 테이블간 교집합을 뺀 온전한 left, right 테이블의 정보를 보여준다. 

-- full outer 조인은 별로 사용하지 않지만 불일치 하는 데이터를 찾을 때 
-- isnull 써서 비교하면서 할 수 있다. 
 
select 
	a.symbol as a_symbol, 
	b.symbol as b_symbol
from nasdaq_company as a 
	right outer join industry_group_symbol as b on a.symbol = b.symbol 


-- 카타시안 곱 cross join 가능한 모든 경우의 매칭 하면 조인 
-- 따로 on 조건을 써주지 않아도 된다. 

-- self join은 같은 테이블을 사용하는 특수한 조인 
-- 테이블의 행을 같은 테이블의 안에 있는 다른 행과 조인 한다. 
-- 계층적 구조를 테이블화 할 경우 사용한다. 
-- 반드시 테이블에 alias 명을 사용해야 한다. 
-- self join은 개념적인 것으로 별도의 join 구문이 필요없다. 


/* self join 예제 
select 
t1.(col), t2(col)
from [tabel1] as t1 
	inner join [table1] as t2 
	on t1.col = t2.col */ 

/* left outer join의 경우 1:1, n:1의 경우 
테이블의 행수가 변하지 않지만, 1:n 경우 기준 
테이블의 데이터가 중복되기 때문에 결과 행수가 늘어 날 수 있다.
쉽게 말해 outer join은 행의 개수가 늘어 날 수 있음을 인지하자!*/








