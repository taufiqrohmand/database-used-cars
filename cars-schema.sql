/*
SQL Queries for creating:
1. Table Structure (Fild and Atribute)
2. Constraint
3. Relatioship
4. Index 
*/


-- locations Table
CREATE TABLE locations(
	location_id INT PRIMARY KEY,
	city_name VARCHAR(255) UNIQUE NOT NULL,
	latitude FLOAT8 NOT NULL,
	longitude FLOAT8 NOT NULL
	);


-- cars Table
CREATE TABLE cars(
	car_id SERIAL PRIMARY KEY,
	brand VARCHAR(25) NOT NULL,
	model VARCHAR(50) NOT NULL,
	body_type VARCHAR(20) NOT NULL,
	fuel_type VARCHAR(20) NOT NULL,
	manufacture_year INT NOT NULL,
	transmission VARCHAR(20) NOT NULL,
	color VARCHAR(255) NOT NULL
	);
	
-- users Table
CREATE TABLE users(
	user_id SERIAL PRIMARY KEY,
	first_name VARCHAR(255) NOT NULL,
	last_name VARCHAR(255) NOT NULL,
	full_name VARCHAR(255) NOT NULL,
	user_name VARCHAR(50) UNIQUE NOT NULL,
	email VARCHAR(255) UNIQUE NOT NULL,
	phone_number VARCHAR(20) UNIQUE NOT NULL,
	address VARCHAR(255),
	location_id INT,
	onboarded_on TIMESTAMP NOT NULL,
	CONSTRAINT fk_kota
		FOREIGN KEY (location_id)
		REFERENCES locations(location_id)
	);
	
-- adverts Table	
CREATE TABLE adverts(
	ads_id SERIAL PRIMARY KEY,
	ads_name VARCHAR(255) NOT NULL,
	date_posted TIMESTAMP NOT NULL,
	car_id INT REFERENCES cars(car_id),
	seller_id INT REFERENCES users(user_id),
	owner_type VARCHAR(20) NOT NULL,
	mileage INT NOT NULL CHECK (mileage > 0),
	price INT NOT NULL CHECK (price > 0),
	location_id INT REFERENCES locations(location_id),
	is_bid BOOLEAN NOT NULL DEFAULT FALSE
	);

-- bids Table
CREATE TABLE bids(
	bid_id SERIAL PRIMARY KEY,
	ads_id INT REFERENCES adverts(ads_id),
	buyer_id INT  REFERENCES users(user_id),
	bid_price INT NOT NULL CHECK (bid_price > 0),
	bid_status VARCHAR(255) NOT NULL,
	bided_at TIMESTAMP NOT NULL
	);


-- INDEX
-- index cars model
CREATE INDEX cars_model
ON cars USING btree(model);

-- index cars manufacture year 
CREATE INDEX cars_year
ON cars USING btree(manufacture_year);


