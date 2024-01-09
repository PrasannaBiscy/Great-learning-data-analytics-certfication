-- 1a.

CREATE SCHEMA Travego;

USE Travego;

CREATE TABLE Passenger (
    Passenger_id INT NOT NULL,
    Passenger_name VARCHAR(50) NOT NULL,
    Category VARCHAR(50),
    Gender CHAR(5),
    Boarding_City VARCHAR(50) NOT NULL,
    Destination_City VARCHAR(50) NOT NULL,
    Distance INT NOT NULL,
    BUS_TYPE VARCHAR(50) NOT NULL,
    PRIMARY KEY (Passenger_id)
);

CREATE TABLE Price (
    id INT NOT NULL,
    Bus_type VARCHAR(50) NOT NULL,
    Distance INT,
    Price INT,
    PRIMARY KEY (id)
);


-- 1b.

INSERT INTO passenger VALUES('1','Sejal','AC','F','Bengaluru','Chennai','350','Sleeper');
INSERT INTO passenger VALUES('2','Anmol','Non-AC','M','Mumbai','Hyderabad','700','Sitting');
INSERT INTO passenger VALUES('3','Pallavi','AC','F','Panaji','Bengaluru','600','Sleeper');
INSERT INTO passenger VALUES('4','Khusboo','AC','F','Chennai','Mumbai','1500','Sleeper');
INSERT INTO passenger VALUES('5','Udit','Non-AC','M','Trivandrum','Panaji','1000','Sleeper');
INSERT INTO passenger VALUES('6','Ankur','AC','M','Nagpur','Hyderabad','500','Sitting');
INSERT INTO passenger VALUES('7','Hemant','Non-AC','M','Panaji','Mumbai','700','Sleeper');
INSERT INTO passenger VALUES('8','Manish','Non-AC','M','Hyderabad','Bengaluru','500','Sitting');
INSERT INTO passenger VALUES('9','Piyush','AC','M','Pune','Nagpur','700','Sitting');

INSERT INTO Price VALUES('1','Sleeper','350','770');
INSERT INTO Price VALUES('2','Sleeper','500','1100');
INSERT INTO Price VALUES('3','Sleeper','600','1320');
INSERT INTO Price VALUES('4','Sleeper','700','1540');
INSERT INTO Price VALUES('5','Sleeper','1000','2200');
INSERT INTO Price VALUES('6','Sleeper','1200','2640');
INSERT INTO Price VALUES('7','Sleeper','1500','2700');
INSERT INTO Price VALUES('8','Sitting','500','620');
INSERT INTO Price VALUES('9','Sitting','600','744');
INSERT INTO Price VALUES('10','Sitting','700','868');
INSERT INTO Price VALUES('11','Sitting','1000','1240');
INSERT INTO Price VALUES('12','Sitting','1200','1488');
INSERT INTO Price VALUES('13','Sitting','1500','1860');


-- 2a.

SELECT COUNT(*) AS Female_Passengers_Count
FROM Passenger
WHERE Gender = 'F' AND Distance >= 600;

-- 2b.

select passenger_id,passenger_name,Distance,Bus_type from passenger
where distance>500 and bus_type='Sleeper';


-- 2c.

select * from passenger where passenger_name like 's%';


-- 2d.

SELECT p.Passenger_name, p.Boarding_City, p.Destination_City, p.Bus_Type, pr.Price
FROM Passenger p
JOIN Price pr ON p.Bus_Type = pr.Bus_Type AND p.Distance = pr.Distance;


-- 2e.

SELECT p.Passenger_name, pr.Price
FROM Passenger P
JOIN Price pr ON p.Bus_Type = pr.Bus_Type AND p.Distance = pr.Distance
WHERE p.Distance = 1000 AND p.Bus_Type = 'Sitting';


-- 2f.

SELECT p.Passenger_name, pr_sitting.Price AS SittingCharge, pr_sleeper.Price AS SleeperCharge
FROM Passenger p
JOIN Price pr_sitting ON p.Distance = pr_sitting.Distance AND pr_sitting.Bus_Type = 'Sitting'
JOIN Price pr_sleeper ON p.Distance = pr_sleeper.Distance AND pr_sleeper.Bus_Type = 'Sleeper'
WHERE p.Passenger_name = 'Pallavi' AND p.Boarding_City = 'Bangaluru' AND p.Destination_City = 'Panaji';


-- 2g.

UPDATE Passenger
SET Category = 'Non-AC'
WHERE Bus_Type = 'Sleeper';
 
 
 -- 2h.
 
DELETE FROM Passenger
WHERE Passenger_name = 'Piyush';
COMMIT;


-- 2i.

truncate table passenger;


-- 2j.

drop table passenger;
