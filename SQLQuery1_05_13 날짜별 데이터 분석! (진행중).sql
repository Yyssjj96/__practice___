use ecommers 

-- ���� ���� ������ ����� ���,
-- �� �� ���� ��Ȳ 
-- �ֺ� ���� �Ǹŵ� ���� 
-- �ֺ� �Ǹŵ� ���� �� �� �ֺ� ���� ī�װ� 

-- 1. ���� ����� ��! 
select
	customer_id, 
	count(*) as cnt, 
	sum(convert(bigint, transaction_amount)) as transaction_amount 
from fact_orders 
where type in (N'ORDER', N'PAYMENT') 
	and state in (N'CANCELLED') 
group by customer_id 
order by cnt desc 

-- customer_id 23171 33�� ����ߴ� ������ 
select * from fact_orders 
where customer_id = '23171' 
-- �پ��� ī�װ� ���� pg inicis method card �� ���� �� ����� ������ ���δ�. 
-- completed �� ���ǵ��� ����, ���θ���� ����� �����ǵ��̴�! 

-- ���� ���� ��Ȳ 
select 
	convert(nvarchar(7), completed_at, 120) as completed_at,  -- ���⼭ ������ �߶��� 
	count(*) as cnt, 
	sum(convert(bigint, transaction_amount)) as transaction_amount 
from fact_orders 
where type in (N'ORDER',N'PAYMENT')
	and state in (N'completed') 
group by convert(nvarchar(7), completed_at, 120) 
order by completed_at 

select convert(nvarchar(7), getdate(), 120)
-- 7���� �ֹ� �ݾ��� ���� ũ��! 
-- ���� ������ �ƴϸ� ������ �� �� �ϴ�! 

-- �ֺ��� ����� ���� time ���� ���̺��� �̿��Ѵ� 
