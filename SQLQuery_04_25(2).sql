select 
a.symbol,  -- ��Ī �� ������ 
a.last_crawel_date,
b.date
from nasdaq_company a -- ��Ī �� ���������� 
	inner join stock b on a.last_crawel_date = b.date
where a.symbol = 'MSFT'

-- inner join 
-- �� ���� �̸��� ���� ���ص��ȴ�. 
-- �ٸ� �̷��� �� ���Ѵ�. 

select 
	a.industry,
	c.symbol,
	c.company_name,
	c.ipo_year,
	c.sector
from industry_group as a 
	inner join industry_group_symbol as b on a.num=b.num 
	inner join nasdaq_company as c on b.symbol = c.symbol 

-- a,b �ʹ� inner join, �� ������ b,c �̳����� 

-- �� �ֹ� ���̺��� ���� �� � ���� �ֹ��� �߳�, �� �߳�
-- Ȯ���Ϸ��� �� ���̺� ���� left join ���ָ� �ȴ� 
-- �� �� ���� null ���� ���� �� �ְ� �ϰ� �ʹٸ� left, right join ��� 

-- left, right (outer) join �� �� ���̺� �������� �� ������ left, right ���̺��� ������ �����ش�. 

-- full outer ������ ���� ������� ������ ����ġ �ϴ� �����͸� ã�� �� 
-- isnull �Ἥ ���ϸ鼭 �� �� �ִ�. 
 
select 
	a.symbol as a_symbol, 
	b.symbol as b_symbol
from nasdaq_company as a 
	right outer join industry_group_symbol as b on a.symbol = b.symbol 


-- īŸ�þ� �� cross join ������ ��� ����� ��Ī �ϸ� ���� 
-- ���� on ������ ������ �ʾƵ� �ȴ�. 

-- self join�� ���� ���̺��� ����ϴ� Ư���� ���� 
-- ���̺��� ���� ���� ���̺��� �ȿ� �ִ� �ٸ� ��� ���� �Ѵ�. 
-- ������ ������ ���̺�ȭ �� ��� ����Ѵ�. 
-- �ݵ�� ���̺� alias ���� ����ؾ� �Ѵ�. 
-- self join�� �������� ������ ������ join ������ �ʿ����. 


/* self join ���� 
select 
t1.(col), t2(col)
from [tabel1] as t1 
	inner join [table1] as t2 
	on t1.col = t2.col */ 

/* left outer join�� ��� 1:1, n:1�� ��� 
���̺��� ����� ������ ������, 1:n ��� ���� 
���̺��� �����Ͱ� �ߺ��Ǳ� ������ ��� ����� �þ� �� �� �ִ�.
���� ���� outer join�� ���� ������ �þ� �� �� ������ ��������!*/








