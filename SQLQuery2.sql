/*select sector, industry, count(*) as cnt from nasdaq_company
group by sector, industry 
having count(*) >= 10 -- ���⼭�� ��Ī ��� �Ұ� 
order by cnt desc;*/ -- order by ������ ��Ī��밡��

-- distinct, group by ��� �ߺ��� ������������ distinct ���� �����Լ��� ��� �� �� ����. 

select distinct sector, industry from nasdaq_company;