-- Average prices by weekday name in Finnish

SELECT fin_name AS viikonpäivä, avg AS keskihinta
	FROM public.weekday_lookup, public.average_by_weekday_number
	WHERE public.weekday_lookup.weekday_number = public.average_by_weekday_number.vpnumero
	ORDER BY vpnumero