SELECT keskihinta,
yläraja,
alaraja
FROM average_by_year_and_month
WHERE vuosi = EXTRACT(year FROM NOW()) AND
    kuukausi = EXTRACT(month FROM NOW()) -1