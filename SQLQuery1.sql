-- dbo�� ��Ű�� ���� �ϴ� �뵵 
--select * from DBO.nasdaq_company

-- ��ũ��. ����. ��Ű����. ���̺� 
--select * from DoItSQL.DBO.nasdaq_company

/* �ε�ȣ, ��������, like, between */

-- �� 50byte ũ���� �����͸� �����ϴ� ���� 50��, ���� ������ 1������ ��ü ���� ��ȸ �� �� 25mb ������ ��Ʈ��ũ�� ����

-- set statistics io on ���� �ۼ��� ������ Ȯ�� ���� �б� 259�� �������� �� ���������� = 8kb

-- set statistics io on 
-- select * from nasdaq_company

-- ctrl + t = �ؽ�Ʈ�� ��� ���� 
-- ctrl + d = ǥ ���·� ��� ����

-- select * from nasdaq_company where ipo_year = 2021

-- ���̺��� �������� Ȯ���Ϸ��� alt+f1 �� ����ϰų� ssms���� ���̺� ���� Ȯ�� �̿� 

select * from nasdaq_company 
where (sector = 'Technology' or sector = 'Consumer Services')
and symbol in ('MSFT', 'AMD' , 'AMZN');