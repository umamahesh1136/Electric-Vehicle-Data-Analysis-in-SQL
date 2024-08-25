
CREATE TABLE EV_Data (
    `VIN(1-10)` VARCHAR(10),
    `County` VARCHAR(255),
    `City` VARCHAR(255),
    `State` VARCHAR(2),
    `Postal Code` VARCHAR(10),
    `Model Year` INT,
    `Make` VARCHAR(255),
    `Model` VARCHAR(255),
    `Electric Vehicle Type` VARCHAR(255),
    `Clean Alternative Fuel Vehicle (CAFV) Eligibility` VARCHAR(255),
    `Electric Range` INT,
    `Base MSRP` DECIMAL(10, 2),
    `Legislative District` VARCHAR(255),
    `DOL Vehicle ID`INT,
    `Vehicle Location` VARCHAR(255),
    `Electric Utility` VARCHAR(255),
    `2020 Census Tract` VARCHAR(255)
);

LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Mahesh Uma - Electric_Vehicle_Population_Data.csv"
INTO TABLE EV_Data
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(
    `VIN(1-10)`, 
    `County`, 
    `City`, 
    `State`, 
    `Postal Code`, 
    `Model Year`, 
    `Make`, 
    `Model`, 
    `Electric Vehicle Type`, 
    `Clean Alternative Fuel Vehicle (CAFV) Eligibility`, 
    `Electric Range`, 
    `Base MSRP`, 
    `Legislative District`, 
    `DOL Vehicle ID`, 
    `Vehicle Location`, 
    `Electric Utility`, 
    `2020 Census Tract`
);

select * from ev_data;

#1. Write a query to list all electric vehicles with their VIN (1-10),Make,and Model.--UMA MAHESH
select `VIN(1-10)`,Make,Model from ev_data;

#2.Write a query to display all columns for electric vehicles with a Model Year of 2020 or later.
-- UMA MAHESH
select * from ev_data
where `model year` >= 2020;

#3. Write a query to list electric vehicles manufactured by Tesla. -- UMA MAHESH
select * from ev_data
where make = 'Tesla';

-- UMA MAHESH --
#4. Write a query to find all electric vehicles where the Model contains the word Leaf.
select * from ev_data
where model like '%leaf%';

-- UMA MAHESH --
#5. Write a query to count the total number of electric vehicles in the dataset.
select count(distinct(`vin(1-10)`)) as total_number_electric_vehicles 
from ev_data;

-- UMA MAHESH --
#6. Write a query to find the average Electric Range of all electric vehicles.
select avg(`Electric Range`) as Average_Electric_Range
from ev_data;

-- UMA MAHESH --
#7. Write a query to list the top 5 electric vehicles with the highest Base MSRP, 
-- sorted in descending order.
select * from ev_data
order by `Base MSRP` desc
limit 5;

-- UMA MAHESH --
#8. Write a query to list all pairs of electric vehicles that have the same Make and Model Year. 
-- Include columns for VIN_1, VIN_2, Make, and Model Year.
select ev1.`VIN(1-10)` as VIN_1, ev2.`VIN(1-10)` as VIN_2, ev1.Make, ev1.`Model Year`
from ev_data ev1
join ev_data ev2
on ev1.Make = ev2.Make 
and ev1.`Model Year` = ev2.`Model Year`
and ev1.`VIN(1-10)` <>  ev2.`VIN(1-10)`;

-- UMA MAHESH --
#9. Write a query to find the total number of electric vehicles for each Make. 
-- Display Make and the count of vehicles.
select make,count(*) as vehical_count from ev_data
group by make 
order by vehical_count;

-- UMA MAHESH --
#10. Write a query using a CASE statement to categorize electric vehicles into three categories based on 
-- their Electric Range:Short Range for ranges less than 100 miles, 
-- Medium Range for ranges between 100 and 200 miles, and Long Range for ranges more than 200 miles.
select `VIN(1-10)`, make,`Electric Range`,
case
    when `Electric Range`<100 then 'Short Range'
    when `Electric Range`between 100 and 200 then 'Medium Range'
    else 'Long Range'
    end as Type_
from ev_data;

-- UMA MAHESH --
#11. Write a query to add a new column Model_Length to the electric vehicles table 
-- that calculates the length of each Model name.
alter table ev_data add column Model_Length INT;
update ev_data SET Model_Length = length(Model);
select model,Model_length from ev_data;

-- UMA MAHESH --
#12. Write a query using an advanced function to find the electric vehicle 
-- with the highest Electric Range.
select model,`Electric Range`from
(select model,`Electric Range`,row_number() over(order by `Electric Range` desc)as rn
from ev_data) v
where rn=1;

-- UMA MAHESH --
#13. Create a view named HighEndVehicles that includes electric vehicles with
-- a Base MSRP of $50,000 or higher.
create view HighEndVehicles as 
(select * from ev_data
where `Base MSRP` >= 50000);
select * from HighEndVehicles;

-- UMA MAHESH --
#14. Write a query using a window function to rank electric vehicles 
-- based on their Base MSRP within each Model Year.
select distinct `VIN(1-10)`, make, model, `model year`,`Base MSRP`,
rank() over (partition by`Model Year`order by`Base MSRP`desc) as ranking
from ev_data;

-- UMA MAHESH -- 
#15. Write a query to calculate the cumulative count of electric vehicles 
-- registered each year sorted by Model Year.
select `Model Year`,count(*) as yearly_count,
sum(count(*)) over (order by`Model Year`) as cummulative_count
from ev_data
group by `Model Year`;

-- UMA MAHESH --
#16. Write a stored procedure to update the Base MSRP of a vehicle given its VIN (1-10) and new Base MSRP.
delimiter //
create procedure Update_msrp(in a
text, in b int)
begin
update ev_data set `Base MSRP` = b
where `VIN(1-10)` = a;
end //
DELIMITER ;
set SQL_SAFE_UPDATES = 0;
call Update_msrp('WBY8P6C58K', 5000);
select `VIN(1-10)`,`Base MSRP`from ev_data;

-- UMA MAHESH --
#17. Write a query to find the county with the highest average Base MSRP for electric vehicles. 
-- Use subqueries and aggregate functions to achieve this.
select COUNTY, AVG_
from (select County, avg(`Base MSRP`) as AVG_
 from ev_data
 group by County
) as t
order by AVG_ desc
limit 1;

-- UMA MAHESH --
#18. Write a query to find pairs of electric vehicles from the same City 
-- where one vehicle has a longer Electric Range than the other. 
-- Display columns for VIN_1, Range_1, VIN_2, and Range_2.
select ev1.city as city_ , ev1.`VIN(1-10)`as VIN_1,ev1.`Electric Range`as range_1,
ev2.`VIN(1-10)`as VIN_2,ev2.`Electric Range`as range_2
from ev_data ev1
join ev_data ev2
on ev1.city = ev2.city and ev1.`Electric Range`> ev2.`Electric Range`;
