/*select sector, industry, count(*) as cnt from nasdaq_company
group by sector, industry 
having count(*) >= 10 -- 여기서는 별칭 사용 불가 
order by cnt desc;*/ -- order by 에서는 별칭사용가능

-- distinct, group by 모두 중복을 제거해주지만 distinct 에는 집계함수를 사용 할 수 없다. 

select distinct sector, industry from nasdaq_company;