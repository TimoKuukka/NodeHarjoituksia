CREATE OR REPLACE VIEW public.average_by_year_and_month
 AS
 SELECT EXTRACT (year FROM hourly_price.timeslot) AS vuosi,
 	EXTRACT (month FROM hourly_price.timeslot) AS kuukausi,
	avg(hourly_price.price) AS keskihinta,
	stddev_pop(hourly_price.price) AS hajonta,
	avg(hourly_price.price) + stddev_pop(hourly_price.price) AS "yläraja",
	avg(hourly_price.price) - stddev_pop(hourly_price.price) AS alaraja
  FROM hourly_price
 GROUP BY (EXTRACT(year FROM hourly_price.timeslot)), (EXTRACT(month FROM hourly_price.timeslot));