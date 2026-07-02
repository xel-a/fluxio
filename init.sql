--
-- PostgreSQL database dump
--

\restrict R9kWUKTPQjBpp9cpVg3h3RNODDov420bdkQeIEaHbCD3rpx7NpOaYsYjD0uKFtI

-- Dumped from database version 18.4
-- Dumped by pg_dump version 18.2

-- Started on 2026-07-01 16:15:49

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 233 (class 1255 OID 16385)
-- Name: distribute_income(); Type: FUNCTION; Schema: public; Owner: CURRENT_USER
--

CREATE FUNCTION public.distribute_income() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE 
	necessity_amount NUMERIC(10, 2);
	investment_amount NUMERIC(10, 2);
	savings_amount NUMERIC(10, 2);
	desires_amount NUMERIC(10, 2);
BEGIN
	necessity_amount := NEW.amount * 0.50;
	investment_amount := NEW.amount * 0.25;
	savings_amount := NEW.amount * 0.15;
	desires_amount := NEW.amount * 0.10;
	
	-- distribute income using 50/25/15/10 rule
	-- necessity
	INSERT INTO income_distribution (amount, category_group_id, income_id)
	VALUES (necessity_amount, 1, NEW.id);
	-- investment
	INSERT INTO income_distribution (amount, category_group_id, income_id)
	VALUES (investment_amount, 2, NEW.id);

	INSERT INTO income_distribution (amount, category_group_id, income_id)
	VALUES (savings_amount, 3, NEW.id);

	INSERT INTO income_distribution (amount, category_group_id, income_id)
	VALUES (desires_amount, 4, NEW.id);

	RETURN NEW;
END;
$$;


ALTER FUNCTION public.distribute_income() OWNER TO CURRENT_USER;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 219 (class 1259 OID 16386)
-- Name: expense_category; Type: TABLE; Schema: public; Owner: CURRENT_USER
--

CREATE TABLE public.expense_category (
    id integer CONSTRAINT budget_category_id_not_null NOT NULL,
    name character varying(64),
    category_group_id smallint
);


ALTER TABLE public.expense_category OWNER TO CURRENT_USER;

--
-- TOC entry 220 (class 1259 OID 16390)
-- Name: budget_category_id_seq; Type: SEQUENCE; Schema: public; Owner: CURRENT_USER
--

CREATE SEQUENCE public.budget_category_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.budget_category_id_seq OWNER TO CURRENT_USER;

--
-- TOC entry 3548 (class 0 OID 0)
-- Dependencies: 220
-- Name: budget_category_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: CURRENT_USER
--

ALTER SEQUENCE public.budget_category_id_seq OWNED BY public.expense_category.id;


--
-- TOC entry 221 (class 1259 OID 16391)
-- Name: budget_plan; Type: TABLE; Schema: public; Owner: CURRENT_USER
--

CREATE TABLE public.budget_plan (
    id integer CONSTRAINT monthly_budget_id_not_null NOT NULL,
    amount numeric(10,2),
    expense_category_id smallint,
    period_start date,
    period_end date
);


ALTER TABLE public.budget_plan OWNER TO CURRENT_USER;

--
-- TOC entry 222 (class 1259 OID 16395)
-- Name: category_group; Type: TABLE; Schema: public; Owner: CURRENT_USER
--

CREATE TABLE public.category_group (
    id integer CONSTRAINT distribution_category_id_not_null NOT NULL,
    name character varying(32)
);


ALTER TABLE public.category_group OWNER TO CURRENT_USER;

--
-- TOC entry 223 (class 1259 OID 16399)
-- Name: distribution_category_id_seq; Type: SEQUENCE; Schema: public; Owner: CURRENT_USER
--

CREATE SEQUENCE public.distribution_category_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.distribution_category_id_seq OWNER TO CURRENT_USER;

--
-- TOC entry 3549 (class 0 OID 0)
-- Dependencies: 223
-- Name: distribution_category_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: CURRENT_USER
--

ALTER SEQUENCE public.distribution_category_id_seq OWNED BY public.category_group.id;


--
-- TOC entry 224 (class 1259 OID 16400)
-- Name: expense_transaction; Type: TABLE; Schema: public; Owner: CURRENT_USER
--

CREATE TABLE public.expense_transaction (
    id integer NOT NULL,
    date date,
    amount numeric(10,2),
    expense_category_id smallint,
    transaction_type_id smallint,
    description character varying(255)
);


ALTER TABLE public.expense_transaction OWNER TO CURRENT_USER;

--
-- TOC entry 225 (class 1259 OID 16404)
-- Name: expense_transaction_id_seq; Type: SEQUENCE; Schema: public; Owner: CURRENT_USER
--

CREATE SEQUENCE public.expense_transaction_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.expense_transaction_id_seq OWNER TO CURRENT_USER;

--
-- TOC entry 3550 (class 0 OID 0)
-- Dependencies: 225
-- Name: expense_transaction_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: CURRENT_USER
--

ALTER SEQUENCE public.expense_transaction_id_seq OWNED BY public.expense_transaction.id;


--
-- TOC entry 226 (class 1259 OID 16405)
-- Name: income_distribution; Type: TABLE; Schema: public; Owner: CURRENT_USER
--

CREATE TABLE public.income_distribution (
    id integer NOT NULL,
    amount numeric(10,2),
    category_group_id smallint,
    income_id integer
);


ALTER TABLE public.income_distribution OWNER TO CURRENT_USER;

--
-- TOC entry 227 (class 1259 OID 16409)
-- Name: income_distribution_id_seq; Type: SEQUENCE; Schema: public; Owner: CURRENT_USER
--

CREATE SEQUENCE public.income_distribution_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.income_distribution_id_seq OWNER TO CURRENT_USER;

--
-- TOC entry 3551 (class 0 OID 0)
-- Dependencies: 227
-- Name: income_distribution_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: CURRENT_USER
--

ALTER SEQUENCE public.income_distribution_id_seq OWNED BY public.income_distribution.id;


--
-- TOC entry 228 (class 1259 OID 16410)
-- Name: income_transaction; Type: TABLE; Schema: public; Owner: CURRENT_USER
--

CREATE TABLE public.income_transaction (
    id integer CONSTRAINT income_id_not_null NOT NULL,
    date date,
    description character varying(32),
    source character varying(32),
    amount numeric(10,2)
);


ALTER TABLE public.income_transaction OWNER TO CURRENT_USER;

--
-- TOC entry 229 (class 1259 OID 16414)
-- Name: income_id_seq; Type: SEQUENCE; Schema: public; Owner: CURRENT_USER
--

CREATE SEQUENCE public.income_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.income_id_seq OWNER TO CURRENT_USER;

--
-- TOC entry 3552 (class 0 OID 0)
-- Dependencies: 229
-- Name: income_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: CURRENT_USER
--

ALTER SEQUENCE public.income_id_seq OWNED BY public.income_transaction.id;


--
-- TOC entry 230 (class 1259 OID 16415)
-- Name: monthly_budget_id_seq; Type: SEQUENCE; Schema: public; Owner: CURRENT_USER
--

CREATE SEQUENCE public.monthly_budget_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.monthly_budget_id_seq OWNER TO CURRENT_USER;

--
-- TOC entry 3553 (class 0 OID 0)
-- Dependencies: 230
-- Name: monthly_budget_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: CURRENT_USER
--

ALTER SEQUENCE public.monthly_budget_id_seq OWNED BY public.budget_plan.id;


--
-- TOC entry 231 (class 1259 OID 16416)
-- Name: transaction_type; Type: TABLE; Schema: public; Owner: CURRENT_USER
--

CREATE TABLE public.transaction_type (
    id integer NOT NULL,
    name character varying(32)
);


ALTER TABLE public.transaction_type OWNER TO CURRENT_USER;

--
-- TOC entry 232 (class 1259 OID 16420)
-- Name: transaction_type_id_seq; Type: SEQUENCE; Schema: public; Owner: CURRENT_USER
--

CREATE SEQUENCE public.transaction_type_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.transaction_type_id_seq OWNER TO CURRENT_USER;

--
-- TOC entry 3554 (class 0 OID 0)
-- Dependencies: 232
-- Name: transaction_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: CURRENT_USER
--

ALTER SEQUENCE public.transaction_type_id_seq OWNED BY public.transaction_type.id;


--
-- TOC entry 3355 (class 2604 OID 16421)
-- Name: budget_plan id; Type: DEFAULT; Schema: public; Owner: CURRENT_USER
--

ALTER TABLE ONLY public.budget_plan ALTER COLUMN id SET DEFAULT nextval('public.monthly_budget_id_seq'::regclass);


--
-- TOC entry 3356 (class 2604 OID 16422)
-- Name: category_group id; Type: DEFAULT; Schema: public; Owner: CURRENT_USER
--

ALTER TABLE ONLY public.category_group ALTER COLUMN id SET DEFAULT nextval('public.distribution_category_id_seq'::regclass);


--
-- TOC entry 3354 (class 2604 OID 16423)
-- Name: expense_category id; Type: DEFAULT; Schema: public; Owner: CURRENT_USER
--

ALTER TABLE ONLY public.expense_category ALTER COLUMN id SET DEFAULT nextval('public.budget_category_id_seq'::regclass);


--
-- TOC entry 3357 (class 2604 OID 16424)
-- Name: expense_transaction id; Type: DEFAULT; Schema: public; Owner: CURRENT_USER
--

ALTER TABLE ONLY public.expense_transaction ALTER COLUMN id SET DEFAULT nextval('public.expense_transaction_id_seq'::regclass);


--
-- TOC entry 3358 (class 2604 OID 16425)
-- Name: income_distribution id; Type: DEFAULT; Schema: public; Owner: CURRENT_USER
--

ALTER TABLE ONLY public.income_distribution ALTER COLUMN id SET DEFAULT nextval('public.income_distribution_id_seq'::regclass);


--
-- TOC entry 3359 (class 2604 OID 16426)
-- Name: income_transaction id; Type: DEFAULT; Schema: public; Owner: CURRENT_USER
--

ALTER TABLE ONLY public.income_transaction ALTER COLUMN id SET DEFAULT nextval('public.income_id_seq'::regclass);


--
-- TOC entry 3360 (class 2604 OID 16427)
-- Name: transaction_type id; Type: DEFAULT; Schema: public; Owner: CURRENT_USER
--

ALTER TABLE ONLY public.transaction_type ALTER COLUMN id SET DEFAULT nextval('public.transaction_type_id_seq'::regclass);


--
-- TOC entry 3531 (class 0 OID 16391)
-- Dependencies: 221
-- Data for Name: budget_plan; Type: TABLE DATA; Schema: public; Owner: CURRENT_USER
--

COPY public.budget_plan (id, amount, expense_category_id, period_start, period_end) FROM stdin;
1	120.00	1	2026-06-01	2026-06-30
2	240.00	2	2026-06-01	2026-06-30
3	120.00	3	2026-06-01	2026-06-30
\.


--
-- TOC entry 3532 (class 0 OID 16395)
-- Dependencies: 222
-- Data for Name: category_group; Type: TABLE DATA; Schema: public; Owner: CURRENT_USER
--

COPY public.category_group (id, name) FROM stdin;
1	necessity
2	investment
3	savings
4	desires
5	debt
\.


--
-- TOC entry 3529 (class 0 OID 16386)
-- Dependencies: 219
-- Data for Name: expense_category; Type: TABLE DATA; Schema: public; Owner: CURRENT_USER
--

COPY public.expense_category (id, name, category_group_id) FROM stdin;
1	groceries	1
2	transportation	1
3	health & hygiene	1
\.


--
-- TOC entry 3534 (class 0 OID 16400)
-- Dependencies: 224
-- Data for Name: expense_transaction; Type: TABLE DATA; Schema: public; Owner: CURRENT_USER
--

COPY public.expense_transaction (id, date, amount, expense_category_id, transaction_type_id, description) FROM stdin;
1	2026-06-11	13.89	2	3	Uber payment
2	2026-06-12	20.00	2	3	Presto reload
3	2026-06-15	20.00	2	3	Presto reload
4	2026-06-19	10.00	2	3	Presto reload
5	2026-06-28	25.00	3	3	Haircut
\.


--
-- TOC entry 3536 (class 0 OID 16405)
-- Dependencies: 226
-- Data for Name: income_distribution; Type: TABLE DATA; Schema: public; Owner: CURRENT_USER
--

COPY public.income_distribution (id, amount, category_group_id, income_id) FROM stdin;
5	390.52	1	2
6	195.26	2	2
7	117.16	3	2
8	78.10	4	2
1	100.00	1	1
2	150.80	2	1
3	45.00	3	1
4	30.00	4	1
11	118.11	3	5
12	78.74	4	5
10	127.50	2	5
9	463.03	1	5
\.


--
-- TOC entry 3538 (class 0 OID 16410)
-- Dependencies: 228
-- Data for Name: income_transaction; Type: TABLE DATA; Schema: public; Owner: CURRENT_USER
--

COPY public.income_transaction (id, date, description, source, amount) FROM stdin;
1	2026-06-02	salary	kfc/taco bell	325.80
2	2026-06-16	salary	kfc/taco bell	781.04
5	2026-06-30	salary	kfc/taco bell	787.37
\.


--
-- TOC entry 3541 (class 0 OID 16416)
-- Dependencies: 231
-- Data for Name: transaction_type; Type: TABLE DATA; Schema: public; Owner: CURRENT_USER
--

COPY public.transaction_type (id, name) FROM stdin;
1	bill
2	subscription
3	purchase
\.


--
-- TOC entry 3555 (class 0 OID 0)
-- Dependencies: 220
-- Name: budget_category_id_seq; Type: SEQUENCE SET; Schema: public; Owner: CURRENT_USER
--

SELECT pg_catalog.setval('public.budget_category_id_seq', 3, true);


--
-- TOC entry 3556 (class 0 OID 0)
-- Dependencies: 223
-- Name: distribution_category_id_seq; Type: SEQUENCE SET; Schema: public; Owner: CURRENT_USER
--

SELECT pg_catalog.setval('public.distribution_category_id_seq', 5, true);


--
-- TOC entry 3557 (class 0 OID 0)
-- Dependencies: 225
-- Name: expense_transaction_id_seq; Type: SEQUENCE SET; Schema: public; Owner: CURRENT_USER
--

SELECT pg_catalog.setval('public.expense_transaction_id_seq', 5, true);


--
-- TOC entry 3558 (class 0 OID 0)
-- Dependencies: 227
-- Name: income_distribution_id_seq; Type: SEQUENCE SET; Schema: public; Owner: CURRENT_USER
--

SELECT pg_catalog.setval('public.income_distribution_id_seq', 12, true);


--
-- TOC entry 3559 (class 0 OID 0)
-- Dependencies: 229
-- Name: income_id_seq; Type: SEQUENCE SET; Schema: public; Owner: CURRENT_USER
--

SELECT pg_catalog.setval('public.income_id_seq', 5, true);


--
-- TOC entry 3560 (class 0 OID 0)
-- Dependencies: 230
-- Name: monthly_budget_id_seq; Type: SEQUENCE SET; Schema: public; Owner: CURRENT_USER
--

SELECT pg_catalog.setval('public.monthly_budget_id_seq', 3, true);


--
-- TOC entry 3561 (class 0 OID 0)
-- Dependencies: 232
-- Name: transaction_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: CURRENT_USER
--

SELECT pg_catalog.setval('public.transaction_type_id_seq', 3, true);


--
-- TOC entry 3362 (class 2606 OID 16429)
-- Name: expense_category budget_category_pkey; Type: CONSTRAINT; Schema: public; Owner: CURRENT_USER
--

ALTER TABLE ONLY public.expense_category
    ADD CONSTRAINT budget_category_pkey PRIMARY KEY (id);


--
-- TOC entry 3366 (class 2606 OID 16431)
-- Name: category_group distribution_category_pkey; Type: CONSTRAINT; Schema: public; Owner: CURRENT_USER
--

ALTER TABLE ONLY public.category_group
    ADD CONSTRAINT distribution_category_pkey PRIMARY KEY (id);


--
-- TOC entry 3368 (class 2606 OID 16433)
-- Name: expense_transaction expense_transaction_pkey; Type: CONSTRAINT; Schema: public; Owner: CURRENT_USER
--

ALTER TABLE ONLY public.expense_transaction
    ADD CONSTRAINT expense_transaction_pkey PRIMARY KEY (id);


--
-- TOC entry 3370 (class 2606 OID 16435)
-- Name: income_distribution income_distribution_pkey; Type: CONSTRAINT; Schema: public; Owner: CURRENT_USER
--

ALTER TABLE ONLY public.income_distribution
    ADD CONSTRAINT income_distribution_pkey PRIMARY KEY (id);


--
-- TOC entry 3372 (class 2606 OID 16437)
-- Name: income_transaction income_pkey; Type: CONSTRAINT; Schema: public; Owner: CURRENT_USER
--

ALTER TABLE ONLY public.income_transaction
    ADD CONSTRAINT income_pkey PRIMARY KEY (id);


--
-- TOC entry 3364 (class 2606 OID 16439)
-- Name: budget_plan monthly_budget_pkey; Type: CONSTRAINT; Schema: public; Owner: CURRENT_USER
--

ALTER TABLE ONLY public.budget_plan
    ADD CONSTRAINT monthly_budget_pkey PRIMARY KEY (id);


--
-- TOC entry 3374 (class 2606 OID 16441)
-- Name: transaction_type transaction_type_pkey; Type: CONSTRAINT; Schema: public; Owner: CURRENT_USER
--

ALTER TABLE ONLY public.transaction_type
    ADD CONSTRAINT transaction_type_pkey PRIMARY KEY (id);


--
-- TOC entry 3381 (class 2620 OID 16442)
-- Name: income_transaction income_after_insert; Type: TRIGGER; Schema: public; Owner: CURRENT_USER
--

CREATE TRIGGER income_after_insert AFTER INSERT ON public.income_transaction FOR EACH ROW EXECUTE FUNCTION public.distribute_income();


--
-- TOC entry 3375 (class 2606 OID 16443)
-- Name: expense_category budget_category_dist_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: CURRENT_USER
--

ALTER TABLE ONLY public.expense_category
    ADD CONSTRAINT budget_category_dist_category_id_fkey FOREIGN KEY (category_group_id) REFERENCES public.category_group(id);


--
-- TOC entry 3377 (class 2606 OID 16448)
-- Name: expense_transaction expense_transaction_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: CURRENT_USER
--

ALTER TABLE ONLY public.expense_transaction
    ADD CONSTRAINT expense_transaction_category_id_fkey FOREIGN KEY (expense_category_id) REFERENCES public.expense_category(id);


--
-- TOC entry 3378 (class 2606 OID 16453)
-- Name: expense_transaction expense_transaction_transaction_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: CURRENT_USER
--

ALTER TABLE ONLY public.expense_transaction
    ADD CONSTRAINT expense_transaction_transaction_type_id_fkey FOREIGN KEY (transaction_type_id) REFERENCES public.transaction_type(id);


--
-- TOC entry 3379 (class 2606 OID 16458)
-- Name: income_distribution income_distribution_distribution_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: CURRENT_USER
--

ALTER TABLE ONLY public.income_distribution
    ADD CONSTRAINT income_distribution_distribution_category_id_fkey FOREIGN KEY (category_group_id) REFERENCES public.category_group(id);


--
-- TOC entry 3380 (class 2606 OID 16463)
-- Name: income_distribution income_distribution_income_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: CURRENT_USER
--

ALTER TABLE ONLY public.income_distribution
    ADD CONSTRAINT income_distribution_income_id_fkey FOREIGN KEY (income_id) REFERENCES public.income_transaction(id);


--
-- TOC entry 3376 (class 2606 OID 16468)
-- Name: budget_plan monthly_budget_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: CURRENT_USER
--

ALTER TABLE ONLY public.budget_plan
    ADD CONSTRAINT monthly_budget_category_id_fkey FOREIGN KEY (expense_category_id) REFERENCES public.expense_category(id);


-- Completed on 2026-07-01 16:15:50

--
-- PostgreSQL database dump complete
--

\unrestrict R9kWUKTPQjBpp9cpVg3h3RNODDov420bdkQeIEaHbCD3rpx7NpOaYsYjD0uKFtI

