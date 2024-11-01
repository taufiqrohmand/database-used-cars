

-- 1. Popularity ranking of car models based on number of bids
SELECT c.model, c.fuel_type, c.body_type, COUNT(a.ads_id) AS count_product, COUNT(b.bid_id)  AS count_bid
FROM adverts a
LEFT JOIN bids b
ON a.ads_id = b.ads_id 
LEFT JOIN cars c 
ON c.car_id  = a.car_id 
GROUP BY c.model, c.fuel_type, c.body_type 
ORDER BY 5 DESC
LIMIT 10;


-- 2. Compare car prices based on average prices per city
WITH avgcitycar AS (
		SELECT l.city_name, c.model, c.fuel_type, c.manufacture_year , a.price,
		ROUND(AVG(a.price) OVER (PARTITION BY l.city_name, c.model, c.fuel_type, c.manufacture_year)) AS avg_price_city,
		row_number () OVER (PARTITION BY l.city_name ORDER BY random()) baris
		FROM adverts a 
		LEFT JOIN cars c 
		ON a.car_id  = c.car_id 
		LEFT JOIN locations l 
		ON a.location_id  = l.location_id
		ORDER BY l.location_id, 6
		)

SELECT acc.city_name, acc.model, acc.fuel_type, acc.manufacture_year, acc.price, acc.avg_price_city
FROM avgcitycar acc
WHERE acc.baris <=5;


-- 3. From the offer of a car model, find a comparison of the date the user made a bid with the next bid along with the offered price.
WITH behavior_bid AS (
SELECT b.buyer_id , c.model, c.fuel_type, b.bided_at  AS first_bid_date, b.bid_price  AS first_bid_price,
LEAD(b.bided_at,1) OVER (PARTITION BY c.model, b.buyer_id , c.fuel_type ORDER BY b.bided_at) AS second_bid_date,
LEAD(b.bid_price,1) OVER (PARTITION BY c.model, b.buyer_id , c.fuel_type ORDER BY b.bided_at) AS second_bid_price
FROM adverts a
RIGHT JOIN bids b 
ON a.ads_id = b.ads_id 
LEFT JOIN cars c 
ON c.car_id  = a.car_id )

SELECT *
FROM behavior_bid
WHERE model = 'Xpander'
AND second_bid_price IS NOT NULL;


-- 4. Compare the percentage difference in the average car price based on the model and the average bid price offered by customers in the last 6 months.
SELECT c.model, c.fuel_type, ROUND(AVG(a.price)) AS Avg_Price,
ROUND(AVG(b.bid_price) FILTER (WHERE b.bided_at < CURRENT_DATE - INTERVAL '6 months')) AS avg_bid_6month,
ROUND(AVG(a.price) - AVG(b.bid_price) FILTER (WHERE b.bided_at < CURRENT_DATE - INTERVAL '6 months')) AS difference,
ROUND((AVG(a.price) - AVG(b.bid_price) FILTER (WHERE b.bided_at < CURRENT_DATE - INTERVAL '6 months')) / 
AVG(a.price) * 100, 2) AS difference_percent

FROM adverts a
LEFT JOIN bids b
ON a.ads_id = b.ads_id 
LEFT JOIN cars c 
ON c.car_id  = a.car_id 
GROUP BY c.model , c.fuel_type
ORDER BY  6,1;


-- 5. The average bid price of a car brand and model over the last 6 months.

SELECT c.brand , c.model , c.fuel_type, 
ROUND(AVG(b.bid_price) FILTER (WHERE b.bided_at < CURRENT_DATE - INTERVAL '1 months')) AS m_min_1,
ROUND(AVG(b.bid_price) FILTER (WHERE b.bided_at < CURRENT_DATE - INTERVAL '2 months')) AS m_min_2,
ROUND(AVG(b.bid_price) FILTER (WHERE b.bided_at < CURRENT_DATE - INTERVAL '3 months')) AS m_min_3,
ROUND(AVG(b.bid_price) FILTER (WHERE b.bided_at < CURRENT_DATE - INTERVAL '4 months')) AS m_min_4,
ROUND(AVG(b.bid_price) FILTER (WHERE b.bided_at < CURRENT_DATE - INTERVAL '5 months')) AS m_min_5,
ROUND(AVG(b.bid_price) FILTER (WHERE b.bided_at < CURRENT_DATE - INTERVAL '6 months')) AS m_min_6
FROM cars c 
LEFT JOIN adverts a 
ON c.car_id = a.car_id 
LEFT JOIN bids b 
ON b.ads_id = a.ads_id 
GROUP BY 1,2,3


