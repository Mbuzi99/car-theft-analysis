
/* ASSIGNMENT
To help the NewZealand police department release a public service statement announement
to ecourage citizens to be aware of theft and stay safe.
*/

/*Objective
1. Identify when vehicles are most likely to be stolen
2. Identify which vehicles are most likely to be stolen 
3. Identify where vehicles are most likely to be stolen
*/

/*creating database to import csv dataset to be cleaned and analysed*/
create database CarTheft;
use CarTheft;

/*Data cleaning and transformation */
--assigning  FKs--
alter table stolen_vehicles add constraint fk_make_id  foreign key (make_id) references make_details(make_id)
alter table stolen_vehicles add constraint fk_location_id  foreign key (location_id) references locations(location_id)

--check for Null rows,duplicated rows and removing them--
SELECT vehicle_id, COUNT(*) AS DuplicateCount
FROM stolen_vehicles
GROUP BY vehicle_id
HAVING COUNT(*) > 1;

delete from stolen_vehicles where vehicle_type is null;

update stolen_vehicles set vehicle_desc = 'UNKNOWN' 
where vehicle_id 
in (4510,4511,4512,4513,4514,4515,4516,4517,4518,4519,4520,4521,4522,4523,4524,4525,4526,4527)

/*Data insights*/
--What day of the week are vehicles most often and least often stolen?
select datename (WEEKDAY,date_stolen) as day_of_week, count(*) as totaltheft
from stolen_vehicles 
group by datename (WEEKDAY,date_stolen) 
order by totaltheft desc

--which month of the  year are cars most often and least often stolen?
select datename (month,date_stolen) as month_of_year, count(*) as totaltheft
from stolen_vehicles 
group by datename (month,date_stolen) 
order by totaltheft desc

--which month per  year are cars most often and least often stolen?
select year(date_stolen) as year_stolen, datename (month,date_stolen) as month_of_year, count(*) as totaltheft
from stolen_vehicles 
group by year(date_stolen), datename (month,date_stolen) 
order by totaltheft desc

--What types of vehicles are most often and least often stolen? Does this vary by region?
select l.region,s.vehicle_type,count(make_id) as totalcount
from locations l 
join stolen_vehicles s on l.location_id = s.location_id
group by l.region, vehicle_type
order by region,totalcount desc 

--make of vehicle most oftern and least often stolen 
select l.region,m.make_name,count(s.make_id) as totalcount
from stolen_vehicles s 
join make_details m on s.make_id = m.make_id
join locations l on s.location_id = l.location_id
group by l.region, make_name
order by region,totalcount desc 

--What is the average age of the vehicles that are stolen? Does this vary based on the vehicle type?
select vehicle_type,s.make_id,m.make_name,
       AVG(YEAR(date_stolen) - model_year) as AvgVehicleAgeWhenStolen
FROM Stolen_Vehicles s
join make_details m on m.make_id = s.make_id
GROUP BY vehicle_type,s.make_id,m.make_name
ORDER BY AvgVehicleAgeWhenStolen DESC;

/*Which regions have the most and least number of stolen vehicles?
What are the characteristics of the regions?*/
select l.region, count(make_id) as totalcount
from locations l 
join stolen_vehicles s on l.location_id = s.location_id
group by  l.region
order by totalcount desc 

--What are the characteristics of the regions?
select region,population,density from locations order by population desc

select * from locations
select * from stolen_vehicles
select * from make_details