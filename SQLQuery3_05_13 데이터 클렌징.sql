USE ecommers
GO


--Fact_Order ���̺��� ��ü Ʈ����� �Ǽ� Ȯ��
SELECT count(*) FROM Fact_Orders

--Fact_Order ���̺� �����ϴ� ����ũ�� ���� ��
SELECT count(*) FROM Dim_customer

--PG ����
SELECT * FROM Dim_PG
--���� ���
SELECT * FROM Dim_method

-- ī�װ� ���� Ȯ��
SELECT * FROM Dim_category
ORDER BY category_title


--Ʈ����� �Ⱓ Ȯ��
SELECT MIN(completed_at), MAX(completed_at)  FROM Fact_orders
SELECT completed_at FROM Fact_orders GROUP BY completed_at ORDER BY completed_at DESC

SELECT * FROM Fact_orders WHERE completed_at = N'B2B'
SELECT * FROM Fact_orders WHERE completed_at = N'���α׷���'
SELECT * FROM Fact_orders WHERE completed_at = N'�̺�Ʈ'
SELECT * FROM Fact_orders WHERE completed_at = N'���ο�'

UPDATE a SET 
	course_title = b.course_title,
	category_title = b.category_title,
	format = b.format,
	completed_at = b.completed_at,
	transaction_amount = b.transaction_amount,
	coupon_title = b.coupon_title,
	coupon_discount_amount = b.coupon_discount_amount,
	sale_price = b.sale_price,
	tax_free_amount = b.tax_free_amount,
	pg = b.pg,
	method = b.method,
	subcategory_title = b.subcategory_title,
	marketing_start_at = b.marketing_start_at
FROM Fact_Orders AS a
	INNER JOIN(

--������ ������ ������Ʈ�Ͽ� ���߱� WHERE completed_at = N'B2B'
SELECT
	id,
	customer_id,
	course_id,
	type,
	state,
	course_title + ' ' + category_title as course_title,
	[format] as category_title,
	completed_at as [format],
	transaction_amount as completed_at,
	coupon_title as transaction_amount,
	coupon_discount_amount as coupon_title,
	sale_price as coupon_discount_amount,
	tax_free_amount as sale_price, 
	pg as tax_free_amount,
	method as pg,
	subcategory_title as method,
	SUBSTRING(marketing_start_at, 1, CHARINDEX(',', marketing_start_at) -1) as subcategory_title,
	SUBSTRING(marketing_start_at,CHARINDEX(',', marketing_start_at) + 1, LEN(marketing_start_at)) as marketing_start_at
FROM Fact_Orders
WHERE completed_at = N'B2B'

UNION ALL

--������ ������ ������Ʈ�Ͽ� ���߱� WHERE completed_at = N'���ο�'
SELECT
	id,
	customer_id,
	course_id,
	type,
	state,
	course_title + ' ' + category_title as course_title,
	[format] as category_title,
	completed_at as [format],
	transaction_amount as completed_at,
	coupon_title as transaction_amount,
	coupon_discount_amount as coupon_title,
	sale_price as coupon_discount_amount,
	tax_free_amount as sale_price,
	pg as tax_free_amount,
	method as pg,
	subcategory_title as method,
	SUBSTRING(marketing_start_at, 1, CHARINDEX(',', marketing_start_at) -1) as subcategory_title,
	SUBSTRING(marketing_start_at, len(marketing_start_at) - CHARINDEX(',', REVERSE(marketing_start_at)) + 2, len(marketing_start_at)) as marketing_start_at
FROM Fact_Orders
WHERE completed_at = N'���ο�'

UNION ALL

--������ ������ ������Ʈ�Ͽ� ���߱� WHERE completed_at = N'���α׷���'
SELECT
	id,
	customer_id,
	course_id,
	type,
	state,
	course_title + ' ' + category_title + ' ' + [format] as course_title,
	completed_at as category_title,
	transaction_amount as [format],
	coupon_title as completed_at,
	coupon_discount_amount as transaction_amount,
	CASE WHEN sale_price = N'NULL' THEN sale_price ELSE sale_price + ' ' + tax_free_amount + ' ' + PG END as coupon_title,
	CASE WHEN sale_price = N'NULL' THEN pg ELSE method END as coupon_discount_amount,
	CASE WHEN sale_price = N'NULL' THEN method ELSE subcategory_title END as sale_price,
	CASE WHEN sale_price = N'NULL' THEN method ELSE SUBSTRING(marketing_start_at, 1, CHARINDEX(',', marketing_start_at) -1) END as tax_free_amount,
	CASE WHEN ISNUMERIC(subcategory_title) = 0 THEN subcategory_title ELSE SUBSTRING(	SUBSTRING(marketing_start_at, CHARINDEX(',', marketing_start_at, CHARINDEX(',', marketing_start_at)) +1, len(marketing_start_at))	,1	,	CHARINDEX(',', SUBSTRING(marketing_start_at, CHARINDEX(',', marketing_start_at, CHARINDEX(',', marketing_start_at)) +1, len(marketing_start_at))	) -1	) END as pg,
	CASE WHEN ISNUMERIC(subcategory_title) = 0 THEN SUBSTRING(marketing_start_at, 1, CHARINDEX(',', marketing_start_at) -1) ELSE  SUBSTRING(	SUBSTRING(marketing_start_at, CHARINDEX(',', marketing_start_at, CHARINDEX(',', marketing_start_at) +1 ) +1, len(marketing_start_at)), 1, CHARINDEX(',', SUBSTRING(marketing_start_at, CHARINDEX(',', marketing_start_at, CHARINDEX(',', marketing_start_at) +1) +1, len(marketing_start_at))) -1) END as method,
	SUBSTRING(marketing_start_at,	len(marketing_start_at) - CHARINDEX(',', REVERSE(marketing_start_at),25) +2,	len(marketing_start_at) - (	(len(marketing_start_at) - CHARINDEX(',', REVERSE(marketing_start_at),25) +2) + CHARINDEX(',', REVERSE(marketing_start_at)) -1	)		) as subcategory_title,
	SUBSTRING(marketing_start_at, len(marketing_start_at) - CHARINDEX(',', REVERSE(marketing_start_at)) + 2, len(marketing_start_at)) as marketing_start_at
FROM Fact_Orders
WHERE completed_at = N'���α׷���'
) AS b ON a.id = b.id


--�̺�Ʈ ������ ������ ����
DELETE Fact_Orders WHERE completed_at = N'�̺�Ʈ'

--PG ������ ���� ����
UPDATE a SET 
	course_title = b.course_title,
	category_title = b.category_title,
	format = b.format,
	completed_at = b.completed_at,
	transaction_amount = b.transaction_amount,
	coupon_title = b.coupon_title,
	coupon_discount_amount = b.coupon_discount_amount,
	sale_price = b.sale_price,
	tax_free_amount = b.tax_free_amount,
	pg = b.pg,
	method = b.method,
	subcategory_title = b.subcategory_title,
	marketing_start_at = b.marketing_start_at
FROM Fact_Orders AS a
	INNER JOIN(
	SELECT
		id,
		customer_id,
		course_id,
		type,
		state,
		course_title,
		category_title,
		[format],
		completed_at,
		transaction_amount,
		coupon_title + coupon_discount_amount as coupon_title,
		sale_price as coupon_discount_amount,
		tax_free_amount as sale_price,
		pg as tax_free_amount,
		method as pg,
		subcategory_title as method,
		CASE WHEN CHARINDEX(',', marketing_start_at) > 0 THEN SUBSTRING(marketing_start_at, 1, CHARINDEX(',', marketing_start_at) -1) ELSE N'NULL' END as subcategory_title,
		CASE WHEN CHARINDEX(',', marketing_start_at) > 0 THEN SUBSTRING(marketing_start_at, len(marketing_start_at) - CHARINDEX(',', REVERSE(marketing_start_at)) + 2, len(marketing_start_at)) ELSE marketing_start_at END as marketing_start_at
	FROM Fact_Orders WHERE ISNUMERIC(PG) = 1
	) as b ON a.id = b.id