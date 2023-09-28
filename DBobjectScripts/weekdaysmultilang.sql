-- Query for showing weekdays on different languages
SELECT weekday_lookup.fin_name AS "viikonpäivä",
	weekday_lookup.swe_name AS veckodag,
	weekday_lookup.eng_name AS weekday,
	weekday_lookup.ger_name AS wochentag,
	weekday_lookup.tur_name AS haftaici,
	round(average_by_weekday_number.avg::numeric, 3) AS keskihinta
	FROM weekday_lookup,
		average_by_weekday_number
 WHERE weekday_lookup.weekday_number::numeric = average_by_weekday_number.vpnumero
 ORDER BY average_by_weekday_number.vpnumero;