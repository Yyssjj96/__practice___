-- 코드를 입력하세요
select c.car_id, c.car_type, (c.daily_fee*((100-d.DISCOUNT_RATE)/100))*30 as fee
from (
    SELECT a.car_id, a.car_type, a.daily_fee
    from CAR_RENTAL_COMPANY_CAR a
    where a.car_id not in (
    select car_id from CAR_RENTAL_COMPANY_RENTAL_HISTORY
    where to_char(START_DATE, 'YYYYMMDD') <= '20221130' and to_char(END_DATE, 'YYYYMMDD') >= '20221101'
    )
    and a.CAR_TYPE in ('세단','SUV') 
) c
,CAR_RENTAL_COMPANY_DISCOUNT_PLAN d
where c.CAR_TYPE = d.CAR_TYPE
and d.DURATION_TYPE LIKE '30%'
and (c.daily_fee*((100-d.DISCOUNT_RATE)/100))*30 BETWEEN 500000 and 2000000
order by 3 desc, 2, 1 desc