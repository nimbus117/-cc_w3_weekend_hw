DROP TABLE IF EXISTS tickets;
DROP TABLE IF EXISTS screenings;
DROP TABLE IF EXISTS films;
DROP TABLE IF EXISTS customers;


CREATE TABLE films(
	id SERIAL8 PRIMARY KEY,
	title VARCHAR(255) NOT NULL,
	price VARCHAR(255) NOT NULL
);

CREATE TABLE customers(
	id SERIAL8 PRIMARY KEY,
	name VARCHAR(255) NOT NULL,
	funds INT2 NOT NULL
);

CREATE TABLE screenings(
	id SERIAL8 PRIMARY KEY,
	show_time TIME NOT NULL,
	film_id INT8 REFERENCES films(id),
	capacity INT2 NOT NULL
);

CREATE TABLE tickets(
	id SERIAL8 PRIMARY KEY,
	customer_id INT8 REFERENCES customers(id),
	screening_id INT8 REFERENCES screenings(id)
);
