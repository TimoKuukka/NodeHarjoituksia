--
-- PostgreSQL database dump
--

-- Dumped from database version 15.4
-- Dumped by pg_dump version 15.4

-- Started on 2023-11-14 10:25:34

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 214 (class 1259 OID 19475)
-- Name: hourly_price; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.hourly_price (
    timeslot timestamp with time zone NOT NULL,
    price real NOT NULL
);


ALTER TABLE public.hourly_price OWNER TO postgres;

--
-- TOC entry 3405 (class 0 OID 0)
-- Dependencies: 214
-- Name: TABLE hourly_price; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.hourly_price IS 'This table will store electricity prices by hour';


--
-- TOC entry 220 (class 1259 OID 19508)
-- Name: average_by_weekday_number; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.average_by_weekday_number AS
 SELECT EXTRACT(isodow FROM hourly_price.timeslot) AS vpnumero,
    avg(hourly_price.price) AS avg
   FROM public.hourly_price
  GROUP BY (EXTRACT(isodow FROM hourly_price.timeslot))
  ORDER BY (EXTRACT(isodow FROM hourly_price.timeslot));


ALTER TABLE public.average_by_weekday_number OWNER TO postgres;

--
-- TOC entry 3406 (class 0 OID 0)
-- Dependencies: 220
-- Name: VIEW average_by_weekday_number; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON VIEW public.average_by_weekday_number IS 'Calculates an average for each weekday using ISO- weekday number ';


--
-- TOC entry 216 (class 1259 OID 19491)
-- Name: average_by_year; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.average_by_year AS
 SELECT EXTRACT(year FROM hourly_price.timeslot) AS vuosi,
    avg(hourly_price.price) AS keskihinta
   FROM public.hourly_price
  GROUP BY (EXTRACT(year FROM hourly_price.timeslot));


ALTER TABLE public.average_by_year OWNER TO postgres;

--
-- TOC entry 3407 (class 0 OID 0)
-- Dependencies: 216
-- Name: VIEW average_by_year; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON VIEW public.average_by_year IS 'Average electricity prices on yearly basis';


--
-- TOC entry 217 (class 1259 OID 19495)
-- Name: average_by_year_and_month; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.average_by_year_and_month AS
 SELECT EXTRACT(year FROM hourly_price.timeslot) AS vuosi,
    EXTRACT(month FROM hourly_price.timeslot) AS kuukausi,
    avg(hourly_price.price) AS keskihinta,
    stddev_pop(hourly_price.price) AS hajonta,
    (avg(hourly_price.price) + stddev_pop(hourly_price.price)) AS "yläraja",
    (avg(hourly_price.price) - stddev_pop(hourly_price.price)) AS alaraja
   FROM public.hourly_price
  GROUP BY (EXTRACT(year FROM hourly_price.timeslot)), (EXTRACT(month FROM hourly_price.timeslot));


ALTER TABLE public.average_by_year_and_month OWNER TO postgres;

--
-- TOC entry 3408 (class 0 OID 0)
-- Dependencies: 217
-- Name: VIEW average_by_year_and_month; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON VIEW public.average_by_year_and_month IS 'Calculates average electricity prices for year-month basis';


--
-- TOC entry 218 (class 1259 OID 19499)
-- Name: average_by_year_month_and_day; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.average_by_year_month_and_day AS
 SELECT EXTRACT(year FROM hourly_price.timeslot) AS vuosi,
    EXTRACT(month FROM hourly_price.timeslot) AS kuukausi,
    EXTRACT(day FROM hourly_price.timeslot) AS "päivä",
    avg(hourly_price.price) AS keskihinta
   FROM public.hourly_price
  GROUP BY (EXTRACT(year FROM hourly_price.timeslot)), (EXTRACT(month FROM hourly_price.timeslot)), (EXTRACT(day FROM hourly_price.timeslot));


ALTER TABLE public.average_by_year_month_and_day OWNER TO postgres;

--
-- TOC entry 3409 (class 0 OID 0)
-- Dependencies: 218
-- Name: VIEW average_by_year_month_and_day; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON VIEW public.average_by_year_month_and_day IS 'Calculates average electricity prices for year-month-day basis';


--
-- TOC entry 219 (class 1259 OID 19503)
-- Name: weekday_lookup; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.weekday_lookup (
    weekday_number integer NOT NULL,
    fin_name character varying(20) NOT NULL,
    swe_name character varying(20) NOT NULL,
    eng_name character varying(20) NOT NULL,
    ger_name character varying(20) NOT NULL,
    tur_name character varying(20) NOT NULL
);


ALTER TABLE public.weekday_lookup OWNER TO postgres;

--
-- TOC entry 3410 (class 0 OID 0)
-- Dependencies: 219
-- Name: TABLE weekday_lookup; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.weekday_lookup IS 'Allows weekday lookup with several languages';


--
-- TOC entry 222 (class 1259 OID 19519)
-- Name: avg_price_by_weekday_name; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.avg_price_by_weekday_name AS
 SELECT weekday_lookup.fin_name AS "viikonpäivä",
    weekday_lookup.swe_name AS veckodag,
    weekday_lookup.eng_name AS weekday,
    weekday_lookup.ger_name AS wochentag,
    weekday_lookup.tur_name AS haftaici,
    round((average_by_weekday_number.avg)::numeric, 3) AS keskihinta
   FROM public.weekday_lookup,
    public.average_by_weekday_number
  WHERE ((weekday_lookup.weekday_number)::numeric = average_by_weekday_number.vpnumero)
  ORDER BY average_by_weekday_number.vpnumero;


ALTER TABLE public.avg_price_by_weekday_name OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 27901)
-- Name: current_prices; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.current_prices AS
 SELECT hourly_price.timeslot,
    hourly_price.price
   FROM public.hourly_price
  WHERE (hourly_price.timeslot >= now())
  ORDER BY hourly_price.timeslot;


ALTER TABLE public.current_prices OWNER TO postgres;

--
-- TOC entry 3411 (class 0 OID 0)
-- Dependencies: 225
-- Name: VIEW current_prices; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON VIEW public.current_prices IS 'Shows electricity prices from now on';


--
-- TOC entry 228 (class 1259 OID 27934)
-- Name: forecast; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.forecast (
    "timestamp" timestamp with time zone NOT NULL,
    place character varying(50) NOT NULL,
    wind_speed real,
    wind_direction real,
    temperature real
);


ALTER TABLE public.forecast OWNER TO postgres;

--
-- TOC entry 3412 (class 0 OID 0)
-- Dependencies: 228
-- Name: TABLE forecast; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.forecast IS 'FMI weather forecast for 36 hours';


--
-- TOC entry 3413 (class 0 OID 0)
-- Dependencies: 228
-- Name: COLUMN forecast."timestamp"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.forecast."timestamp" IS 'ISO timestamp with timezone';


--
-- TOC entry 3414 (class 0 OID 0)
-- Dependencies: 228
-- Name: COLUMN forecast.place; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.forecast.place IS 'Name of weather station';


--
-- TOC entry 227 (class 1259 OID 27909)
-- Name: hourly_page; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.hourly_page AS
 SELECT EXTRACT(day FROM hourly_price.timeslot) AS day,
    EXTRACT(hour FROM hourly_price.timeslot) AS hour,
    hourly_price.price
   FROM public.hourly_price
  WHERE (hourly_price.timeslot >= now())
  ORDER BY (EXTRACT(day FROM hourly_price.timeslot)), (EXTRACT(hour FROM hourly_price.timeslot));


ALTER TABLE public.hourly_page OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 19523)
-- Name: month_name_lookup; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.month_name_lookup (
    month_number integer NOT NULL,
    fin_name character varying(20) NOT NULL,
    swe_name character varying(20),
    eng_name character varying(20),
    ger_name character varying(20),
    tur_name character varying(20)
);


ALTER TABLE public.month_name_lookup OWNER TO postgres;

--
-- TOC entry 3415 (class 0 OID 0)
-- Dependencies: 223
-- Name: TABLE month_name_lookup; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.month_name_lookup IS 'Gives a month name by number';


--
-- TOC entry 224 (class 1259 OID 19528)
-- Name: monthly_averages_by_year_fin; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.monthly_averages_by_year_fin AS
 SELECT average_by_year_and_month.vuosi,
    month_name_lookup.fin_name,
    average_by_year_and_month.keskihinta
   FROM public.average_by_year_and_month,
    public.month_name_lookup
  WHERE (average_by_year_and_month.kuukausi = (month_name_lookup.month_number)::numeric)
  ORDER BY average_by_year_and_month.vuosi, average_by_year_and_month.kuukausi;


ALTER TABLE public.monthly_averages_by_year_fin OWNER TO postgres;

--
-- TOC entry 3416 (class 0 OID 0)
-- Dependencies: 224
-- Name: VIEW monthly_averages_by_year_fin; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON VIEW public.monthly_averages_by_year_fin IS 'Monthly averages with Finnish month names';


--
-- TOC entry 229 (class 1259 OID 27939)
-- Name: observation; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.observation (
    "timestamp" timestamp with time zone NOT NULL,
    place character varying(50) NOT NULL,
    wind_speed real,
    wind_direction real,
    temperature real
);


ALTER TABLE public.observation OWNER TO postgres;

--
-- TOC entry 3417 (class 0 OID 0)
-- Dependencies: 229
-- Name: TABLE observation; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.observation IS 'Stores FMI weather observations in 10 minute intervals';


--
-- TOC entry 3418 (class 0 OID 0)
-- Dependencies: 229
-- Name: COLUMN observation."timestamp"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.observation."timestamp" IS 'ISO timestamp with timezone';


--
-- TOC entry 3419 (class 0 OID 0)
-- Dependencies: 229
-- Name: COLUMN observation.place; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.observation.place IS 'Name of weather station';


--
-- TOC entry 226 (class 1259 OID 27905)
-- Name: previous_month_average; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.previous_month_average AS
 SELECT average_by_year_and_month.keskihinta,
    average_by_year_and_month."yläraja",
    average_by_year_and_month.alaraja
   FROM public.average_by_year_and_month
  WHERE ((average_by_year_and_month.vuosi = EXTRACT(year FROM now())) AND (average_by_year_and_month.kuukausi = (EXTRACT(month FROM now()) - (1)::numeric)));


ALTER TABLE public.previous_month_average OWNER TO postgres;

--
-- TOC entry 215 (class 1259 OID 19487)
-- Name: running_average; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.running_average AS
 SELECT round((avg(hourly_price.price))::numeric, 3) AS keskihinta
   FROM public.hourly_price;


ALTER TABLE public.running_average OWNER TO postgres;

--
-- TOC entry 3420 (class 0 OID 0)
-- Dependencies: 215
-- Name: VIEW running_average; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON VIEW public.running_average IS 'Calculates average electricity price form all rows';


--
-- TOC entry 221 (class 1259 OID 19515)
-- Name: running_average_stdev; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.running_average_stdev AS
 SELECT avg(hourly_price.price) AS hinta,
    stddev(hourly_price.price) AS keskihajonta
   FROM public.hourly_price;


ALTER TABLE public.running_average_stdev OWNER TO postgres;

--
-- TOC entry 3421 (class 0 OID 0)
-- Dependencies: 221
-- Name: VIEW running_average_stdev; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON VIEW public.running_average_stdev IS 'Calculates average electricity price and standard deviation from whole price data ';


--
-- TOC entry 3398 (class 0 OID 27934)
-- Dependencies: 228
-- Data for Name: forecast; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3395 (class 0 OID 19475)
-- Dependencies: 214
-- Data for Name: hourly_price; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.hourly_price VALUES ('2023-10-05 00:00:00+03', -0.016);
INSERT INTO public.hourly_price VALUES ('2023-10-04 23:00:00+03', 0.032);
INSERT INTO public.hourly_price VALUES ('2023-10-04 14:00:00+03', 0.62);
INSERT INTO public.hourly_price VALUES ('2023-09-12 19:00:00+03', 13.99);
INSERT INTO public.hourly_price VALUES ('2023-09-12 18:00:00+03', 12.5);
INSERT INTO public.hourly_price VALUES ('2023-10-04 13:00:00+03', 3.761);
INSERT INTO public.hourly_price VALUES ('2023-09-12 20:00:00+03', 14.6);
INSERT INTO public.hourly_price VALUES ('2023-09-14 13:00:00+03', 10.15);
INSERT INTO public.hourly_price VALUES ('2023-10-04 12:00:00+03', 7.265);
INSERT INTO public.hourly_price VALUES ('2023-09-14 14:00:00+03', 10.5);
INSERT INTO public.hourly_price VALUES ('2023-09-14 15:00:00+03', 14.5);
INSERT INTO public.hourly_price VALUES ('2023-09-14 16:00:00+03', 14.25);
INSERT INTO public.hourly_price VALUES ('2023-09-14 17:00:00+03', 19.3);
INSERT INTO public.hourly_price VALUES ('2023-09-14 18:00:00+03', 11.76);
INSERT INTO public.hourly_price VALUES ('2022-09-14 15:00:00+03', 14.5);
INSERT INTO public.hourly_price VALUES ('2022-09-14 16:00:00+03', 14.25);
INSERT INTO public.hourly_price VALUES ('2022-09-14 17:00:00+03', 19.3);
INSERT INTO public.hourly_price VALUES ('2022-09-14 18:00:00+03', 11.76);
INSERT INTO public.hourly_price VALUES ('2022-08-14 15:00:00+03', 14.5);
INSERT INTO public.hourly_price VALUES ('2022-08-14 16:00:00+03', 14.25);
INSERT INTO public.hourly_price VALUES ('2022-08-14 17:00:00+03', 19.3);
INSERT INTO public.hourly_price VALUES ('2022-08-14 18:00:00+03', 11.76);
INSERT INTO public.hourly_price VALUES ('2023-10-04 11:00:00+03', 8.995);
INSERT INTO public.hourly_price VALUES ('2023-10-04 10:00:00+03', 12.419);
INSERT INTO public.hourly_price VALUES ('2023-10-04 09:00:00+03', 12.427);
INSERT INTO public.hourly_price VALUES ('2023-10-04 08:00:00+03', 10.99);
INSERT INTO public.hourly_price VALUES ('2023-10-04 07:00:00+03', 11.533);
INSERT INTO public.hourly_price VALUES ('2023-10-04 06:00:00+03', 0.366);
INSERT INTO public.hourly_price VALUES ('2023-10-04 05:00:00+03', 0.066);
INSERT INTO public.hourly_price VALUES ('2023-10-04 04:00:00+03', -0.001);
INSERT INTO public.hourly_price VALUES ('2023-10-04 03:00:00+03', -0.002);
INSERT INTO public.hourly_price VALUES ('2023-10-04 02:00:00+03', 0.001);
INSERT INTO public.hourly_price VALUES ('2023-10-04 01:00:00+03', 0.016);
INSERT INTO public.hourly_price VALUES ('2023-10-04 00:00:00+03', 0.091);
INSERT INTO public.hourly_price VALUES ('2023-10-03 23:00:00+03', 0.334);
INSERT INTO public.hourly_price VALUES ('2023-10-03 22:00:00+03', 0.507);
INSERT INTO public.hourly_price VALUES ('2023-10-03 21:00:00+03', 0.667);
INSERT INTO public.hourly_price VALUES ('2023-10-03 20:00:00+03', 11.973);
INSERT INTO public.hourly_price VALUES ('2023-10-03 19:00:00+03', 12.432);
INSERT INTO public.hourly_price VALUES ('2023-10-03 18:00:00+03', 11.26);
INSERT INTO public.hourly_price VALUES ('2023-10-03 17:00:00+03', 7.438);
INSERT INTO public.hourly_price VALUES ('2023-10-03 16:00:00+03', 6.821);
INSERT INTO public.hourly_price VALUES ('2023-10-03 15:00:00+03', 3.72);
INSERT INTO public.hourly_price VALUES ('2023-10-03 14:00:00+03', 3.72);
INSERT INTO public.hourly_price VALUES ('2023-10-03 13:00:00+03', 3.72);
INSERT INTO public.hourly_price VALUES ('2023-10-03 12:00:00+03', 8.061);
INSERT INTO public.hourly_price VALUES ('2023-10-03 11:00:00+03', 13.641);
INSERT INTO public.hourly_price VALUES ('2023-10-03 10:00:00+03', 13.645);
INSERT INTO public.hourly_price VALUES ('2023-10-03 09:00:00+03', 16.652);
INSERT INTO public.hourly_price VALUES ('2023-10-03 08:00:00+03', 13.641);
INSERT INTO public.hourly_price VALUES ('2023-10-03 07:00:00+03', 0.764);
INSERT INTO public.hourly_price VALUES ('2023-10-03 06:00:00+03', 0.547);
INSERT INTO public.hourly_price VALUES ('2023-10-03 05:00:00+03', 0.397);
INSERT INTO public.hourly_price VALUES ('2023-10-03 04:00:00+03', 0.368);
INSERT INTO public.hourly_price VALUES ('2023-10-03 03:00:00+03', 0.367);
INSERT INTO public.hourly_price VALUES ('2023-10-03 02:00:00+03', 0.367);
INSERT INTO public.hourly_price VALUES ('2023-10-03 01:00:00+03', 0.371);
INSERT INTO public.hourly_price VALUES ('2023-10-04 19:00:00+03', 16.406);
INSERT INTO public.hourly_price VALUES ('2023-10-04 21:00:00+03', 0.219);
INSERT INTO public.hourly_price VALUES ('2023-10-04 22:00:00+03', 0.18);
INSERT INTO public.hourly_price VALUES ('2023-10-04 16:00:00+03', 1.117);
INSERT INTO public.hourly_price VALUES ('2023-10-04 20:00:00+03', 0.621);
INSERT INTO public.hourly_price VALUES ('2023-10-04 15:00:00+03', 0.438);
INSERT INTO public.hourly_price VALUES ('2023-10-04 18:00:00+03', 3.099);
INSERT INTO public.hourly_price VALUES ('2023-10-04 17:00:00+03', 4.953);
INSERT INTO public.hourly_price VALUES ('2023-10-26 00:00:00+03', 2.499);
INSERT INTO public.hourly_price VALUES ('2023-10-25 14:00:00+03', 8.68);
INSERT INTO public.hourly_price VALUES ('2023-10-25 13:00:00+03', 8.061);
INSERT INTO public.hourly_price VALUES ('2023-10-25 12:00:00+03', 15.49);
INSERT INTO public.hourly_price VALUES ('2023-10-25 11:00:00+03', 14.879);
INSERT INTO public.hourly_price VALUES ('2023-10-25 10:00:00+03', 12.829);
INSERT INTO public.hourly_price VALUES ('2023-10-25 09:00:00+03', 13.092);
INSERT INTO public.hourly_price VALUES ('2023-10-25 08:00:00+03', 15.488);
INSERT INTO public.hourly_price VALUES ('2023-10-25 07:00:00+03', 7.44);
INSERT INTO public.hourly_price VALUES ('2023-10-25 06:00:00+03', 6.547);
INSERT INTO public.hourly_price VALUES ('2023-10-25 05:00:00+03', 4.801);
INSERT INTO public.hourly_price VALUES ('2023-10-25 04:00:00+03', 2.481);
INSERT INTO public.hourly_price VALUES ('2023-10-25 03:00:00+03', 3.05);
INSERT INTO public.hourly_price VALUES ('2023-10-25 02:00:00+03', 3.556);
INSERT INTO public.hourly_price VALUES ('2023-10-25 01:00:00+03', 4.562);
INSERT INTO public.hourly_price VALUES ('2023-10-25 00:00:00+03', 2.649);
INSERT INTO public.hourly_price VALUES ('2023-10-24 23:00:00+03', 4.959);
INSERT INTO public.hourly_price VALUES ('2023-10-24 22:00:00+03', 4.96);
INSERT INTO public.hourly_price VALUES ('2023-10-24 21:00:00+03', 5.249);
INSERT INTO public.hourly_price VALUES ('2023-10-24 20:00:00+03', 19.547);
INSERT INTO public.hourly_price VALUES ('2023-10-24 19:00:00+03', 20.47);
INSERT INTO public.hourly_price VALUES ('2023-10-24 18:00:00+03', 22.631);
INSERT INTO public.hourly_price VALUES ('2023-10-24 17:00:00+03', 9.227);
INSERT INTO public.hourly_price VALUES ('2023-10-24 16:00:00+03', 9.172);
INSERT INTO public.hourly_price VALUES ('2023-10-24 15:00:00+03', 15.489);
INSERT INTO public.hourly_price VALUES ('2023-10-24 14:00:00+03', 14.606);
INSERT INTO public.hourly_price VALUES ('2023-10-24 13:00:00+03', 12.282);
INSERT INTO public.hourly_price VALUES ('2023-10-24 12:00:00+03', 11.368);
INSERT INTO public.hourly_price VALUES ('2023-10-24 11:00:00+03', 15.918);
INSERT INTO public.hourly_price VALUES ('2023-10-24 10:00:00+03', 16.907);
INSERT INTO public.hourly_price VALUES ('2023-10-24 09:00:00+03', 20.467);
INSERT INTO public.hourly_price VALUES ('2023-10-24 08:00:00+03', 20.472);
INSERT INTO public.hourly_price VALUES ('2023-10-24 07:00:00+03', 8.214);
INSERT INTO public.hourly_price VALUES ('2023-10-24 06:00:00+03', 5.476);
INSERT INTO public.hourly_price VALUES ('2023-10-24 05:00:00+03', 3.436);
INSERT INTO public.hourly_price VALUES ('2023-10-24 04:00:00+03', 3.102);
INSERT INTO public.hourly_price VALUES ('2023-10-24 03:00:00+03', 3.054);
INSERT INTO public.hourly_price VALUES ('2023-10-24 02:00:00+03', 3.129);
INSERT INTO public.hourly_price VALUES ('2023-10-24 01:00:00+03', 3.207);
INSERT INTO public.hourly_price VALUES ('2023-10-25 23:00:00+03', 3.757);
INSERT INTO public.hourly_price VALUES ('2023-10-25 22:00:00+03', 3.101);
INSERT INTO public.hourly_price VALUES ('2023-10-25 21:00:00+03', 3.198);
INSERT INTO public.hourly_price VALUES ('2023-10-25 16:00:00+03', 7.439);
INSERT INTO public.hourly_price VALUES ('2023-10-25 15:00:00+03', 7.44);
INSERT INTO public.hourly_price VALUES ('2023-10-25 20:00:00+03', 5.054);
INSERT INTO public.hourly_price VALUES ('2023-10-25 17:00:00+03', 8.68);
INSERT INTO public.hourly_price VALUES ('2023-10-25 19:00:00+03', 8.072);
INSERT INTO public.hourly_price VALUES ('2023-10-25 18:00:00+03', 8.065);
INSERT INTO public.hourly_price VALUES ('2023-10-27 00:00:00+03', 4.243);
INSERT INTO public.hourly_price VALUES ('2023-10-26 14:00:00+03', 8.676);
INSERT INTO public.hourly_price VALUES ('2023-10-26 13:00:00+03', 8.93);
INSERT INTO public.hourly_price VALUES ('2023-10-26 12:00:00+03', 8.934);
INSERT INTO public.hourly_price VALUES ('2023-10-26 11:00:00+03', 8.488);
INSERT INTO public.hourly_price VALUES ('2023-10-26 10:00:00+03', 8.484);
INSERT INTO public.hourly_price VALUES ('2023-10-26 09:00:00+03', 7.13);
INSERT INTO public.hourly_price VALUES ('2023-10-26 08:00:00+03', 7.671);
INSERT INTO public.hourly_price VALUES ('2023-10-26 07:00:00+03', 4.437);
INSERT INTO public.hourly_price VALUES ('2023-10-26 06:00:00+03', 3.688);
INSERT INTO public.hourly_price VALUES ('2023-10-26 05:00:00+03', 2.471);
INSERT INTO public.hourly_price VALUES ('2023-10-26 04:00:00+03', 2.308);
INSERT INTO public.hourly_price VALUES ('2023-10-26 03:00:00+03', 2.296);
INSERT INTO public.hourly_price VALUES ('2023-10-26 02:00:00+03', 2.38);
INSERT INTO public.hourly_price VALUES ('2023-10-26 01:00:00+03', 2.521);
INSERT INTO public.hourly_price VALUES ('2023-10-26 19:00:00+03', 9.429);
INSERT INTO public.hourly_price VALUES ('2023-10-26 18:00:00+03', 9.839);
INSERT INTO public.hourly_price VALUES ('2023-10-26 22:00:00+03', 4.887);
INSERT INTO public.hourly_price VALUES ('2023-10-26 20:00:00+03', 8.493);
INSERT INTO public.hourly_price VALUES ('2023-10-26 23:00:00+03', 4.674);
INSERT INTO public.hourly_price VALUES ('2023-10-26 17:00:00+03', 8.849);
INSERT INTO public.hourly_price VALUES ('2023-10-26 21:00:00+03', 5.803);
INSERT INTO public.hourly_price VALUES ('2023-10-26 16:00:00+03', 8.778);
INSERT INTO public.hourly_price VALUES ('2023-10-26 15:00:00+03', 8.413);
INSERT INTO public.hourly_price VALUES ('2023-10-27 20:00:00+03', 14.879);
INSERT INTO public.hourly_price VALUES ('2023-10-27 14:00:00+03', 13.194);
INSERT INTO public.hourly_price VALUES ('2023-10-27 13:00:00+03', 14.706);
INSERT INTO public.hourly_price VALUES ('2023-10-27 12:00:00+03', 13.456);
INSERT INTO public.hourly_price VALUES ('2023-10-27 11:00:00+03', 13.449);
INSERT INTO public.hourly_price VALUES ('2023-10-27 10:00:00+03', 18.348);
INSERT INTO public.hourly_price VALUES ('2023-10-27 09:00:00+03', 18.55);
INSERT INTO public.hourly_price VALUES ('2023-10-27 08:00:00+03', 13.161);
INSERT INTO public.hourly_price VALUES ('2023-10-27 07:00:00+03', 8.836);
INSERT INTO public.hourly_price VALUES ('2023-10-27 06:00:00+03', 6.1);
INSERT INTO public.hourly_price VALUES ('2023-10-27 05:00:00+03', 6.159);
INSERT INTO public.hourly_price VALUES ('2023-10-27 04:00:00+03', 5.86);
INSERT INTO public.hourly_price VALUES ('2023-10-27 03:00:00+03', 6.029);
INSERT INTO public.hourly_price VALUES ('2023-10-27 02:00:00+03', 6.165);
INSERT INTO public.hourly_price VALUES ('2023-10-27 01:00:00+03', 6.31);
INSERT INTO public.hourly_price VALUES ('2023-10-27 21:00:00+03', 9.156);
INSERT INTO public.hourly_price VALUES ('2023-10-27 19:00:00+03', 16.792);
INSERT INTO public.hourly_price VALUES ('2023-10-27 16:00:00+03', 9.908);
INSERT INTO public.hourly_price VALUES ('2023-10-27 23:00:00+03', 5.714);
INSERT INTO public.hourly_price VALUES ('2023-10-27 17:00:00+03', 10.995);
INSERT INTO public.hourly_price VALUES ('2023-10-27 15:00:00+03', 12.204);
INSERT INTO public.hourly_price VALUES ('2023-10-28 00:00:00+03', 5.447);
INSERT INTO public.hourly_price VALUES ('2023-10-27 18:00:00+03', 15.109);
INSERT INTO public.hourly_price VALUES ('2023-10-27 22:00:00+03', 8.506);
INSERT INTO public.hourly_price VALUES ('2023-11-10 00:00:00+02', 3.529);
INSERT INTO public.hourly_price VALUES ('2023-11-09 14:00:00+02', 15.924);
INSERT INTO public.hourly_price VALUES ('2023-11-09 13:00:00+02', 13.616);
INSERT INTO public.hourly_price VALUES ('2023-11-09 12:00:00+02', 12.07);
INSERT INTO public.hourly_price VALUES ('2023-11-09 11:00:00+02', 12.41);
INSERT INTO public.hourly_price VALUES ('2023-11-09 10:00:00+02', 13.597);
INSERT INTO public.hourly_price VALUES ('2023-11-09 09:00:00+02', 15.087);
INSERT INTO public.hourly_price VALUES ('2023-11-09 08:00:00+02', 14.887);
INSERT INTO public.hourly_price VALUES ('2023-11-09 07:00:00+02', 13.592);
INSERT INTO public.hourly_price VALUES ('2023-11-09 06:00:00+02', 8.681);
INSERT INTO public.hourly_price VALUES ('2023-11-09 05:00:00+02', 3.719);
INSERT INTO public.hourly_price VALUES ('2023-11-09 04:00:00+02', 3.172);
INSERT INTO public.hourly_price VALUES ('2023-11-09 03:00:00+02', 3.377);
INSERT INTO public.hourly_price VALUES ('2023-11-09 02:00:00+02', 3.648);
INSERT INTO public.hourly_price VALUES ('2023-11-09 01:00:00+02', 4.125);
INSERT INTO public.hourly_price VALUES ('2023-11-09 00:00:00+02', 3.804);
INSERT INTO public.hourly_price VALUES ('2023-11-08 23:00:00+02', 4.948);
INSERT INTO public.hourly_price VALUES ('2023-11-08 22:00:00+02', 6.333);
INSERT INTO public.hourly_price VALUES ('2023-11-08 21:00:00+02', 7.347);
INSERT INTO public.hourly_price VALUES ('2023-11-08 20:00:00+02', 9.006);
INSERT INTO public.hourly_price VALUES ('2023-11-08 19:00:00+02', 9.735);
INSERT INTO public.hourly_price VALUES ('2023-11-08 18:00:00+02', 10.539);
INSERT INTO public.hourly_price VALUES ('2023-11-08 17:00:00+02', 10.263);
INSERT INTO public.hourly_price VALUES ('2023-11-08 16:00:00+02', 9.98);
INSERT INTO public.hourly_price VALUES ('2023-11-08 15:00:00+02', 9.991);
INSERT INTO public.hourly_price VALUES ('2023-11-08 14:00:00+02', 9.434);
INSERT INTO public.hourly_price VALUES ('2023-11-08 13:00:00+02', 9.388);
INSERT INTO public.hourly_price VALUES ('2023-11-08 12:00:00+02', 9.777);
INSERT INTO public.hourly_price VALUES ('2023-11-08 11:00:00+02', 10.259);
INSERT INTO public.hourly_price VALUES ('2023-11-08 10:00:00+02', 11.251);
INSERT INTO public.hourly_price VALUES ('2023-11-08 09:00:00+02', 12.632);
INSERT INTO public.hourly_price VALUES ('2023-11-08 08:00:00+02', 10.655);
INSERT INTO public.hourly_price VALUES ('2023-11-08 07:00:00+02', 9.319);
INSERT INTO public.hourly_price VALUES ('2023-11-08 06:00:00+02', 5.646);
INSERT INTO public.hourly_price VALUES ('2023-11-08 05:00:00+02', 4.593);
INSERT INTO public.hourly_price VALUES ('2023-11-08 04:00:00+02', 4.375);
INSERT INTO public.hourly_price VALUES ('2023-11-08 03:00:00+02', 4.459);
INSERT INTO public.hourly_price VALUES ('2023-11-08 02:00:00+02', 4.635);
INSERT INTO public.hourly_price VALUES ('2023-11-08 01:00:00+02', 4.949);
INSERT INTO public.hourly_price VALUES ('2023-11-09 20:00:00+02', 10.514);
INSERT INTO public.hourly_price VALUES ('2023-11-09 21:00:00+02', 4.827);
INSERT INTO public.hourly_price VALUES ('2023-11-09 16:00:00+02', 8.164);
INSERT INTO public.hourly_price VALUES ('2023-11-09 18:00:00+02', 11.706);
INSERT INTO public.hourly_price VALUES ('2023-11-09 19:00:00+02', 11.584);
INSERT INTO public.hourly_price VALUES ('2023-11-09 22:00:00+02', 4.604);
INSERT INTO public.hourly_price VALUES ('2023-11-09 15:00:00+02', 12.179);
INSERT INTO public.hourly_price VALUES ('2023-11-09 17:00:00+02', 11.409);
INSERT INTO public.hourly_price VALUES ('2023-11-09 23:00:00+02', 4.114);


--
-- TOC entry 3397 (class 0 OID 19523)
-- Dependencies: 223
-- Data for Name: month_name_lookup; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.month_name_lookup VALUES (1, 'tammikuu', 'januari', 'january', 'Januar', 'ocak');
INSERT INTO public.month_name_lookup VALUES (2, 'helmikuu', 'februari', 'february', 'Februar', 'şubat');
INSERT INTO public.month_name_lookup VALUES (3, 'maaliskuu', 'mars', 'march', 'März', 'mart');
INSERT INTO public.month_name_lookup VALUES (4, 'huhtikuu', 'april', 'april', 'April', 'nīsan ');
INSERT INTO public.month_name_lookup VALUES (5, 'toukokuu', 'maj', 'may', 'Mai', 'mayis');
INSERT INTO public.month_name_lookup VALUES (6, 'kesäkuu', 'juni', 'june', 'Juni', 'hazīran');
INSERT INTO public.month_name_lookup VALUES (7, 'heinäkuu', 'juli', 'july', 'Juli', 'temmuz');
INSERT INTO public.month_name_lookup VALUES (8, 'elokuu', 'augusti', 'august', 'August', 'ağustos');
INSERT INTO public.month_name_lookup VALUES (9, 'syyskuu', 'september', 'september', 'September', 'eylül');
INSERT INTO public.month_name_lookup VALUES (10, 'lokakuu', 'oktober', 'october', 'Oktober', 'ekim');
INSERT INTO public.month_name_lookup VALUES (11, 'marraskuu', 'november', 'november', 'November', 'kasim');
INSERT INTO public.month_name_lookup VALUES (12, 'joulukuu', 'december', 'december', 'Dezember', 'aralik');


--
-- TOC entry 3399 (class 0 OID 27939)
-- Dependencies: 229
-- Data for Name: observation; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3396 (class 0 OID 19503)
-- Dependencies: 219
-- Data for Name: weekday_lookup; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.weekday_lookup VALUES (1, 'maanantai', 'måndag', 'monday', 'Montag', 'Pazartesi');
INSERT INTO public.weekday_lookup VALUES (2, 'tiistai', 'tisdag', 'tuesday', 'Dienstag', 'Sali');
INSERT INTO public.weekday_lookup VALUES (3, 'keskiviikko', 'onsdag', 'wednesday', 'Mittwoch', 'Carsamba');
INSERT INTO public.weekday_lookup VALUES (4, 'torstai', 'torsdag', 'thursday', 'Donnerstag', 'Persemble');
INSERT INTO public.weekday_lookup VALUES (5, 'perjantai', 'fredag', 'friday', 'Freitag', 'Cuma');
INSERT INTO public.weekday_lookup VALUES (6, 'lauantai', 'lördag', 'saturday', 'Samstag', 'Cumartesi');
INSERT INTO public.weekday_lookup VALUES (7, 'sunnuntai', 'söndag', 'sunday', 'Sonntag', 'Pazar');


--
-- TOC entry 3239 (class 2606 OID 27948)
-- Name: forecast forecast_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.forecast
    ADD CONSTRAINT forecast_pk PRIMARY KEY ("timestamp", place);


--
-- TOC entry 3233 (class 2606 OID 19479)
-- Name: hourly_price hourly_price_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hourly_price
    ADD CONSTRAINT hourly_price_pk PRIMARY KEY (timeslot);


--
-- TOC entry 3237 (class 2606 OID 19527)
-- Name: month_name_lookup month_name_lookup_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.month_name_lookup
    ADD CONSTRAINT month_name_lookup_pkey PRIMARY KEY (month_number);


--
-- TOC entry 3241 (class 2606 OID 27954)
-- Name: observation observation_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.observation
    ADD CONSTRAINT observation_pk PRIMARY KEY ("timestamp", place);


--
-- TOC entry 3235 (class 2606 OID 19507)
-- Name: weekday_lookup weekday_lookup_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.weekday_lookup
    ADD CONSTRAINT weekday_lookup_pk PRIMARY KEY (weekday_number);


-- Completed on 2023-11-14 10:25:34

--
-- PostgreSQL database dump complete
--

