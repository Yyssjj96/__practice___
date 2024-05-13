SELECT TOP (10) [date]
      ,[symbol]
      ,[open]
      ,[high]
      ,[low]
      ,[close]
      ,[adj_close]
      ,[volume]
  FROM [DoItSQL].[dbo].[stock]
  -- 날짜별 거래량 
  -- ui로 진행한 추출을 쿼리로 다시 받아볼 수 있다. 
