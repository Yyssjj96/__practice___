-- dbo는 스키마 구별 하는 용도 
--select * from DBO.nasdaq_company

-- 링크명. 디비명. 스키마명. 테이블 
--select * from DoItSQL.DBO.nasdaq_company

/* 부등호, 논리연산자, like, between */

-- 약 50byte 크기의 데이터를 저장하는 열이 50개, 행의 개수가 1만개면 전체 열을 조회 할 시 25mb 정도의 네트워크가 전송

-- set statistics io on 쿼리 작성의 성능을 확인 논리적 읽기 259는 페이지의 수 한페이지는 = 8kb

-- set statistics io on 
-- select * from nasdaq_company

-- ctrl + t = 텍스트로 결과 보기 
-- ctrl + d = 표 형태로 결과 보기

-- select * from nasdaq_company where ipo_year = 2021

-- 테이블의 열정보를 확인하려면 alt+f1 을 사용하거나 ssms에서 테이블 정보 확장 이용 

select * from nasdaq_company 
where (sector = 'Technology' or sector = 'Consumer Services')
and symbol in ('MSFT', 'AMD' , 'AMZN');