-- joining without useing "join"
select
	tpep_pickup_datetime,
	tpep_dropoff_datetime,
	total_amount,
	zpu."Borough" || ' / ' || zpu."Zone" as "pickup_loc",
	zdo."Borough" || ' / ' || zdo."Zone" as "dropoff_loc"	
from
	yellow_taxi_data t,
	zones zdo,
	zones zpu
where
 t."PULocationID" = zpu."LocationID" And
 t."DOLocationID" = zdo."LocationID" 
limit 100;

-- using join
select
	tpep_pickup_datetime,
	tpep_dropoff_datetime,
	total_amount,
	zpu."Borough" || ' / ' || zpu."Zone" as "pickup_loc",
	zdo."Borough" || ' / ' || zdo."Zone" as "dropoff_loc"	
from
	yellow_taxi_data t join zones zpu
		on t."PULocationID" = zpu."LocationID"
	join zones zdo
		on t."DOLocationID" = zdo."LocationID"  
limit 100;


-- group by
select
	cast(tpep_dropoff_datetime as date) as "day",
	count(1)

from
	yellow_taxi_data t
group by
	cast(tpep_dropoff_datetime as date)
order by "day" asc;

-- count per day
select
	DATE_TRUNC('DAY', tpep_pickup_datetime) as dt,
	count(DATE_TRUNC('DAY', tpep_pickup_datetime))
from
	yellow_taxi_data t
where
 tpep_pickup_datetime >= '2021-01-15 00:00:00'::timestamp 
 and tpep_pickup_datetime < '2021-01-16 00:00:00'::timestamp 
group by dt
limit 2
;

-- largest tip
select
	tip_amount as tip,
	DATE_TRUNC('DAY', tpep_pickup_datetime)
from
	yellow_taxi_data t
order by
	tip desc
limit 1
;

-- most populate drop off
select
	zdo."Zone",
	count(zdo."Zone")
from
	yellow_taxi_data t join zones zpu
		on t."PULocationID" = zpu."LocationID"
	join zones zdo
		on t."DOLocationID" = zdo."LocationID"  
where
 "tpep_pickup_datetime" >= '2021-01-14 00:00:00'::timestamp 
 and "tpep_pickup_datetime" < '2021-01-15 00:00:00'::timestamp 
group by
 zdo."Zone"
order by count(zdo."Zone") desc
limit(2);

-- most expensive locations
select
	zpu."Zone" || ' / ' || zdo."Zone" as "pickup_dropoff_zone",
	avg(total_amount)
from
	yellow_taxi_data t join zones zpu
		on t."PULocationID" = zpu."LocationID"
	join zones zdo
		on t."DOLocationID" = zdo."LocationID"
group by pickup_dropoff_zone
order by "avg" desc
limit 100;