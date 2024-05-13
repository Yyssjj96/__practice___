/* in : ���������� ����� �����ϴ� ������ ���� ���� ���� �˻� 
   any : ���������� ����� �����ϴ� ��� �ϳ��� ���̶� �����ϴ� ���� �˻� 
   exists : ���������� ����� �����ϴ� ���� �����ϴ��� ���� Ȯ�� 
   all : ���� ������ ����� �����ϴ� ��� ���� �����ϴ� ���� �˻� 
   */

create table doit_sub_a(
col_1 int, 
col_2 nvarchar(50))

insert into doit_sub_a values (1,N'AAA')
insert into doit_sub_a values (2,N'BBB')
insert into doit_sub_a values (3,N'CCC')
insert into doit_sub_a values (4,N'DDD')
insert into doit_sub_a values (5,N'EEE')

create table doit_sub_b(
col_1 int, 
col_2 nvarchar(50))

insert into doit_sub_b values (1,N'111')
insert into doit_sub_b values (2,N'222')
insert into doit_sub_b values (3,N'333')
insert into doit_sub_b values (4,N'444')
insert into doit_sub_b values (5,N'555')

select * from doit_sub_a 
select * from doit_sub_b 

update a
set a.col_2 = ( select b.col_2 from doit_sub_b as b where b.col_1 = a.col_1)
from doit_sub_a as a 