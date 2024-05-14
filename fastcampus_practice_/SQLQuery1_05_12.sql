-- 데이터 로드 후 전처리 

-- 스타 스키마 
-- 다차원 데이터를 효과적으로 저장 조회하기 위한 관계형 db 설계 기법 

-- 스노우 플레이크 
-- 팩트 테이블과 조인 되는 차원 테이블이 있고, 이 차원 테이블은 또 다른 테이블의 기본키를 참조한다.

create database ecommers 
go 

use [ecommers]
go
-- csv 형태의 파일을 불러와서 사용, 데이터 형식을 유니코드로 변경 후 사용 

select top 10 * from [dbo].[Fact_orders]

drop table [dbo].[Fact_orders]
