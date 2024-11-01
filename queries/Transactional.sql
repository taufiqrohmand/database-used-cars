-- 1. Looking car for 2015 or above
SELECT c.*,a.owner_type, a.price 
FROM adverts a
LEFT JOIN cars c 
ON c.car_id  = a.car_id 
WHERE c.manufacture_year  >= '2015';


-- 2. Insert one bid

-- Check the latest bid data
SELECT *
FROM bids b 
ORDER BY bid_id DESC
LIMIT 10;

-- add the bid data with buyer id 578 in ads_id 1498
INSERT INTO bids (bid_id ,ads_id,buyer_id,bid_price,bid_status,bided_at)
VALUES((SELECT MAX(bid_id)+1 FROM bids ),1498,578,340000000,'Pending',
(SELECT MAX(bided_at)+INTERVAL '1 day' FROM bids WHERE ads_id =1498));

-- the result
SELECT *
FROM bids b 
WHERE b.ads_id = 1498
ORDER BY bid_id DESC



-- Check the insert bid data
SELECT *
FROM bids b 
ORDER BY bid_id DESC
WHERE bid_id = 4228;


-- 3. See all cars sold by 1 account from the most recent

SELECT c.*, a.owner_type, a.price, a.date_posted 
FROM adverts a
LEFT JOIN cars c 
ON c.car_id  = a.car_id 
WHERE a.seller_id = 558
ORDER BY 11 DESC;


-- 4. Looking for the cheapest used car based on the keyword 'CR-V'

SELECT c.*, a.owner_type, a.price 
FROM adverts a
LEFT JOIN cars c 
ON c.car_id  = a.car_id 
WHERE c.model ilike 'cr-v'
ORDER BY 10;


-- 5. Search for the nearest used car based on a city ID

--create function euclidean distance
CREATE OR REPLACE FUNCTION euclidean_distance(loc INT, dest INT)
RETURNS NUMERIC AS
$$
DECLARE
    lat1 FLOAT8;
    lon1 FLOAT8;
    lat2 FLOAT8;
    lon2 FLOAT8;
    distance NUMERIC;
BEGIN
    SELECT latitude INTO lat1 FROM locations WHERE location_id = loc;
    SELECT longitude INTO lon1 FROM locations WHERE location_id = loc;
    SELECT latitude INTO lat2 FROM locations WHERE location_id = dest;
    SELECT longitude INTO lon2 FROM locations WHERE location_id = dest;

    distance := sqrt(power((lat2-lat1),2) + power((lon2-lon1),2));

    RETURN distance;
END;
$$
LANGUAGE plpgsql;



SELECT a.ads_id , a.ads_name , c.brand , c.model , c.manufacture_year, a.price,
euclidean_distance(u.location_id,a.location_id)
FROM users u 
LEFT JOIN adverts a ON u.user_id = a.seller_id 
LEFT JOIN cars c ON c.car_id = a.car_id 
WHERE u.location_id = 3173 AND a.ads_id  IS NOT NULL
ORDER BY 7
