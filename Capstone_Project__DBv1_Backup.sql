--
-- PostgreSQL database dump
--

\restrict ZE8sjj2ZFqKYxGSNDTyWyav7Ro5bNDi8TaiR5b6aJw76IMOmmfRFAhEyjyak495

-- Dumped from database version 18.4
-- Dumped by pg_dump version 18.4

-- Started on 2026-07-04 05:39:10

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
-- TOC entry 4 (class 2615 OID 2200)
-- Name: public; Type: SCHEMA; Schema: -; Owner: pg_database_owner
--

CREATE SCHEMA public;


ALTER SCHEMA public OWNER TO pg_database_owner;

--
-- TOC entry 5190 (class 0 OID 0)
-- Dependencies: 4
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: pg_database_owner
--

COMMENT ON SCHEMA public IS 'standard public schema';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 248 (class 1259 OID 17151)
-- Name: campaign_criteria; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.campaign_criteria (
    id integer NOT NULL,
    campaign_id integer NOT NULL,
    gender_id integer,
    min_age smallint,
    max_age smallint,
    grade_id integer,
    status_id integer
);


ALTER TABLE public.campaign_criteria OWNER TO postgres;

--
-- TOC entry 247 (class 1259 OID 17150)
-- Name: campaign_criteria_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.campaign_criteria ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.campaign_criteria_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 250 (class 1259 OID 17179)
-- Name: campaign_enrollments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.campaign_enrollments (
    id integer NOT NULL,
    campaign_id integer NOT NULL,
    credential_id integer NOT NULL,
    enrolled_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.campaign_enrollments OWNER TO postgres;

--
-- TOC entry 249 (class 1259 OID 17178)
-- Name: campaign_enrollments_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.campaign_enrollments ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.campaign_enrollments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 246 (class 1259 OID 17132)
-- Name: campaign_institution_criteria; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.campaign_institution_criteria (
    id integer NOT NULL,
    campaign_id integer NOT NULL,
    institution_id integer NOT NULL
);


ALTER TABLE public.campaign_institution_criteria OWNER TO postgres;

--
-- TOC entry 245 (class 1259 OID 17131)
-- Name: campaign_institution_criteria_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.campaign_institution_criteria ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.campaign_institution_criteria_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 244 (class 1259 OID 17110)
-- Name: campaigns; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.campaigns (
    id integer NOT NULL,
    title character varying(200) NOT NULL,
    type character varying(20) NOT NULL,
    description text,
    creator_name character varying(150),
    credential_creator_id integer,
    target_audience character varying(200),
    scope character varying(20) NOT NULL,
    start_date date NOT NULL,
    end_date date NOT NULL,
    status character varying(20) NOT NULL,
    CONSTRAINT campaigns_scope_check CHECK (((scope)::text = ANY ((ARRAY['Institucional'::character varying, 'Global'::character varying])::text[]))),
    CONSTRAINT campaigns_type_check CHECK (((type)::text = ANY ((ARRAY['Educativa'::character varying, 'Deportiva'::character varying, 'Cultural'::character varying])::text[])))
);


ALTER TABLE public.campaigns OWNER TO postgres;

--
-- TOC entry 243 (class 1259 OID 17109)
-- Name: campaigns_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.campaigns ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.campaigns_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 234 (class 1259 OID 16986)
-- Name: credentials; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.credentials (
    id integer NOT NULL,
    username character varying(100) NOT NULL,
    password character varying(255) NOT NULL,
    role_id integer NOT NULL
);


ALTER TABLE public.credentials OWNER TO postgres;

--
-- TOC entry 233 (class 1259 OID 16985)
-- Name: credentials_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.credentials ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.credentials_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 222 (class 1259 OID 16931)
-- Name: document_types; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.document_types (
    id integer NOT NULL,
    abbreviation character varying(5) NOT NULL,
    name character varying(50) NOT NULL
);


ALTER TABLE public.document_types OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 16930)
-- Name: document_types_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.document_types ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.document_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 224 (class 1259 OID 16940)
-- Name: genders; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.genders (
    id integer NOT NULL,
    name character varying(50) NOT NULL
);


ALTER TABLE public.genders OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 16939)
-- Name: genders_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.genders ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.genders_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 226 (class 1259 OID 16948)
-- Name: grades; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.grades (
    id integer NOT NULL,
    grade character varying(50) NOT NULL
);


ALTER TABLE public.grades OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 16947)
-- Name: grades_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.grades ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.grades_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 240 (class 1259 OID 17050)
-- Name: institutions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.institutions (
    id integer NOT NULL,
    institution_name character varying(200) NOT NULL,
    director character varying(150),
    address character varying(200),
    principal character varying(150),
    neighborhood_id integer,
    credential_id integer,
    dane_code character varying(20) NOT NULL
);


ALTER TABLE public.institutions OWNER TO postgres;

--
-- TOC entry 239 (class 1259 OID 17049)
-- Name: institutions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.institutions ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.institutions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 230 (class 1259 OID 16964)
-- Name: localities; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.localities (
    id integer NOT NULL,
    name character varying(100) NOT NULL
);


ALTER TABLE public.localities OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 16963)
-- Name: localities_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.localities ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.localities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 232 (class 1259 OID 16972)
-- Name: neighborhoods; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.neighborhoods (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    locality_id integer NOT NULL
);


ALTER TABLE public.neighborhoods OWNER TO postgres;

--
-- TOC entry 231 (class 1259 OID 16971)
-- Name: neighborhoods_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.neighborhoods ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.neighborhoods_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 236 (class 1259 OID 17003)
-- Name: people; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.people (
    id integer NOT NULL,
    first_name character varying(100) NOT NULL,
    last_name character varying(100) NOT NULL,
    gender_id integer,
    birth_date date NOT NULL,
    email character varying(150),
    phone character varying(20),
    document_type_id integer NOT NULL,
    document_number character varying(20) NOT NULL,
    address character varying(200),
    neighborhood_id integer
);


ALTER TABLE public.people OWNER TO postgres;

--
-- TOC entry 235 (class 1259 OID 17002)
-- Name: people_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.people ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.people_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 238 (class 1259 OID 17034)
-- Name: personal_contacts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.personal_contacts (
    id integer NOT NULL,
    first_name character varying(100) NOT NULL,
    last_name character varying(100) NOT NULL,
    phone character varying(20),
    person_id integer NOT NULL,
    relationship character varying(50) NOT NULL
);


ALTER TABLE public.personal_contacts OWNER TO postgres;

--
-- TOC entry 237 (class 1259 OID 17033)
-- Name: personal_contacts_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.personal_contacts ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.personal_contacts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 228 (class 1259 OID 16956)
-- Name: statuses; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.statuses (
    id integer NOT NULL,
    status character varying(50) NOT NULL
);


ALTER TABLE public.statuses OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 16955)
-- Name: statuses_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.statuses ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.statuses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 242 (class 1259 OID 17073)
-- Name: student_profiles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.student_profiles (
    id integer NOT NULL,
    person_id integer NOT NULL,
    institution_id integer NOT NULL,
    credential_id integer NOT NULL,
    status_id integer NOT NULL,
    grade_id integer,
    start_date date NOT NULL,
    end_date date
);


ALTER TABLE public.student_profiles OWNER TO postgres;

--
-- TOC entry 241 (class 1259 OID 17072)
-- Name: student_profiles_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.student_profiles ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.student_profiles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 252 (class 1259 OID 17200)
-- Name: updates; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.updates (
    id integer NOT NULL,
    person_id integer NOT NULL,
    campaign_id integer NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.updates OWNER TO postgres;

--
-- TOC entry 251 (class 1259 OID 17199)
-- Name: updates_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.updates ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.updates_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 220 (class 1259 OID 16923)
-- Name: user_roles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_roles (
    id integer NOT NULL,
    name character varying(50) NOT NULL
);


ALTER TABLE public.user_roles OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 16922)
-- Name: user_roles_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.user_roles ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.user_roles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 5180 (class 0 OID 17151)
-- Dependencies: 248
-- Data for Name: campaign_criteria; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.campaign_criteria (id, campaign_id, gender_id, min_age, max_age, grade_id, status_id) FROM stdin;
\.


--
-- TOC entry 5182 (class 0 OID 17179)
-- Dependencies: 250
-- Data for Name: campaign_enrollments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.campaign_enrollments (id, campaign_id, credential_id, enrolled_at) FROM stdin;
\.


--
-- TOC entry 5178 (class 0 OID 17132)
-- Dependencies: 246
-- Data for Name: campaign_institution_criteria; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.campaign_institution_criteria (id, campaign_id, institution_id) FROM stdin;
\.


--
-- TOC entry 5176 (class 0 OID 17110)
-- Dependencies: 244
-- Data for Name: campaigns; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.campaigns (id, title, type, description, creator_name, credential_creator_id, target_audience, scope, start_date, end_date, status) FROM stdin;
\.


--
-- TOC entry 5166 (class 0 OID 16986)
-- Dependencies: 234
-- Data for Name: credentials; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.credentials (id, username, password, role_id) FROM stdin;
\.


--
-- TOC entry 5154 (class 0 OID 16931)
-- Dependencies: 222
-- Data for Name: document_types; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.document_types (id, abbreviation, name) FROM stdin;
\.


--
-- TOC entry 5156 (class 0 OID 16940)
-- Dependencies: 224
-- Data for Name: genders; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.genders (id, name) FROM stdin;
\.


--
-- TOC entry 5158 (class 0 OID 16948)
-- Dependencies: 226
-- Data for Name: grades; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.grades (id, grade) FROM stdin;
\.


--
-- TOC entry 5172 (class 0 OID 17050)
-- Dependencies: 240
-- Data for Name: institutions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.institutions (id, institution_name, director, address, principal, neighborhood_id, credential_id, dane_code) FROM stdin;
\.


--
-- TOC entry 5162 (class 0 OID 16964)
-- Dependencies: 230
-- Data for Name: localities; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.localities (id, name) FROM stdin;
\.


--
-- TOC entry 5164 (class 0 OID 16972)
-- Dependencies: 232
-- Data for Name: neighborhoods; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.neighborhoods (id, name, locality_id) FROM stdin;
\.


--
-- TOC entry 5168 (class 0 OID 17003)
-- Dependencies: 236
-- Data for Name: people; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.people (id, first_name, last_name, gender_id, birth_date, email, phone, document_type_id, document_number, address, neighborhood_id) FROM stdin;
\.


--
-- TOC entry 5170 (class 0 OID 17034)
-- Dependencies: 238
-- Data for Name: personal_contacts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.personal_contacts (id, first_name, last_name, phone, person_id, relationship) FROM stdin;
\.


--
-- TOC entry 5160 (class 0 OID 16956)
-- Dependencies: 228
-- Data for Name: statuses; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.statuses (id, status) FROM stdin;
\.


--
-- TOC entry 5174 (class 0 OID 17073)
-- Dependencies: 242
-- Data for Name: student_profiles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.student_profiles (id, person_id, institution_id, credential_id, status_id, grade_id, start_date, end_date) FROM stdin;
\.


--
-- TOC entry 5184 (class 0 OID 17200)
-- Dependencies: 252
-- Data for Name: updates; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.updates (id, person_id, campaign_id, updated_at) FROM stdin;
\.


--
-- TOC entry 5152 (class 0 OID 16923)
-- Dependencies: 220
-- Data for Name: user_roles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_roles (id, name) FROM stdin;
\.


--
-- TOC entry 5191 (class 0 OID 0)
-- Dependencies: 247
-- Name: campaign_criteria_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.campaign_criteria_id_seq', 1, false);


--
-- TOC entry 5192 (class 0 OID 0)
-- Dependencies: 249
-- Name: campaign_enrollments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.campaign_enrollments_id_seq', 1, false);


--
-- TOC entry 5193 (class 0 OID 0)
-- Dependencies: 245
-- Name: campaign_institution_criteria_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.campaign_institution_criteria_id_seq', 1, false);


--
-- TOC entry 5194 (class 0 OID 0)
-- Dependencies: 243
-- Name: campaigns_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.campaigns_id_seq', 1, false);


--
-- TOC entry 5195 (class 0 OID 0)
-- Dependencies: 233
-- Name: credentials_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.credentials_id_seq', 1, false);


--
-- TOC entry 5196 (class 0 OID 0)
-- Dependencies: 221
-- Name: document_types_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.document_types_id_seq', 1, false);


--
-- TOC entry 5197 (class 0 OID 0)
-- Dependencies: 223
-- Name: genders_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.genders_id_seq', 1, false);


--
-- TOC entry 5198 (class 0 OID 0)
-- Dependencies: 225
-- Name: grades_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.grades_id_seq', 1, false);


--
-- TOC entry 5199 (class 0 OID 0)
-- Dependencies: 239
-- Name: institutions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.institutions_id_seq', 1, false);


--
-- TOC entry 5200 (class 0 OID 0)
-- Dependencies: 229
-- Name: localities_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.localities_id_seq', 1, false);


--
-- TOC entry 5201 (class 0 OID 0)
-- Dependencies: 231
-- Name: neighborhoods_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.neighborhoods_id_seq', 1, false);


--
-- TOC entry 5202 (class 0 OID 0)
-- Dependencies: 235
-- Name: people_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.people_id_seq', 1, false);


--
-- TOC entry 5203 (class 0 OID 0)
-- Dependencies: 237
-- Name: personal_contacts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.personal_contacts_id_seq', 1, false);


--
-- TOC entry 5204 (class 0 OID 0)
-- Dependencies: 227
-- Name: statuses_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.statuses_id_seq', 1, false);


--
-- TOC entry 5205 (class 0 OID 0)
-- Dependencies: 241
-- Name: student_profiles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.student_profiles_id_seq', 1, false);


--
-- TOC entry 5206 (class 0 OID 0)
-- Dependencies: 251
-- Name: updates_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.updates_id_seq', 1, false);


--
-- TOC entry 5207 (class 0 OID 0)
-- Dependencies: 219
-- Name: user_roles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.user_roles_id_seq', 1, false);


--
-- TOC entry 4975 (class 2606 OID 17157)
-- Name: campaign_criteria campaign_criteria_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.campaign_criteria
    ADD CONSTRAINT campaign_criteria_pkey PRIMARY KEY (id);


--
-- TOC entry 4977 (class 2606 OID 17188)
-- Name: campaign_enrollments campaign_enrollments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.campaign_enrollments
    ADD CONSTRAINT campaign_enrollments_pkey PRIMARY KEY (id);


--
-- TOC entry 4973 (class 2606 OID 17139)
-- Name: campaign_institution_criteria campaign_institution_criteria_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.campaign_institution_criteria
    ADD CONSTRAINT campaign_institution_criteria_pkey PRIMARY KEY (id);


--
-- TOC entry 4971 (class 2606 OID 17125)
-- Name: campaigns campaigns_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.campaigns
    ADD CONSTRAINT campaigns_pkey PRIMARY KEY (id);


--
-- TOC entry 4955 (class 2606 OID 16994)
-- Name: credentials credentials_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.credentials
    ADD CONSTRAINT credentials_pkey PRIMARY KEY (id);


--
-- TOC entry 4957 (class 2606 OID 16996)
-- Name: credentials credentials_username_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.credentials
    ADD CONSTRAINT credentials_username_key UNIQUE (username);


--
-- TOC entry 4943 (class 2606 OID 16938)
-- Name: document_types document_types_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.document_types
    ADD CONSTRAINT document_types_pkey PRIMARY KEY (id);


--
-- TOC entry 4945 (class 2606 OID 16946)
-- Name: genders genders_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.genders
    ADD CONSTRAINT genders_pkey PRIMARY KEY (id);


--
-- TOC entry 4947 (class 2606 OID 16954)
-- Name: grades grades_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.grades
    ADD CONSTRAINT grades_pkey PRIMARY KEY (id);


--
-- TOC entry 4965 (class 2606 OID 17061)
-- Name: institutions institutions_dane_code_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.institutions
    ADD CONSTRAINT institutions_dane_code_key UNIQUE (dane_code);


--
-- TOC entry 4967 (class 2606 OID 17059)
-- Name: institutions institutions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.institutions
    ADD CONSTRAINT institutions_pkey PRIMARY KEY (id);


--
-- TOC entry 4951 (class 2606 OID 16970)
-- Name: localities localities_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.localities
    ADD CONSTRAINT localities_pkey PRIMARY KEY (id);


--
-- TOC entry 4953 (class 2606 OID 16979)
-- Name: neighborhoods neighborhoods_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.neighborhoods
    ADD CONSTRAINT neighborhoods_pkey PRIMARY KEY (id);


--
-- TOC entry 4959 (class 2606 OID 17017)
-- Name: people people_document_number_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.people
    ADD CONSTRAINT people_document_number_key UNIQUE (document_number);


--
-- TOC entry 4961 (class 2606 OID 17015)
-- Name: people people_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.people
    ADD CONSTRAINT people_pkey PRIMARY KEY (id);


--
-- TOC entry 4963 (class 2606 OID 17043)
-- Name: personal_contacts personal_contacts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.personal_contacts
    ADD CONSTRAINT personal_contacts_pkey PRIMARY KEY (id);


--
-- TOC entry 4949 (class 2606 OID 16962)
-- Name: statuses statuses_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.statuses
    ADD CONSTRAINT statuses_pkey PRIMARY KEY (id);


--
-- TOC entry 4969 (class 2606 OID 17083)
-- Name: student_profiles student_profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_profiles
    ADD CONSTRAINT student_profiles_pkey PRIMARY KEY (id);


--
-- TOC entry 4979 (class 2606 OID 17209)
-- Name: updates updates_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.updates
    ADD CONSTRAINT updates_pkey PRIMARY KEY (id);


--
-- TOC entry 4941 (class 2606 OID 16929)
-- Name: user_roles user_roles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_roles
    ADD CONSTRAINT user_roles_pkey PRIMARY KEY (id);


--
-- TOC entry 4996 (class 2606 OID 17158)
-- Name: campaign_criteria campaign_criteria_campaign_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.campaign_criteria
    ADD CONSTRAINT campaign_criteria_campaign_id_fkey FOREIGN KEY (campaign_id) REFERENCES public.campaigns(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4997 (class 2606 OID 17163)
-- Name: campaign_criteria campaign_criteria_gender_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.campaign_criteria
    ADD CONSTRAINT campaign_criteria_gender_id_fkey FOREIGN KEY (gender_id) REFERENCES public.genders(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 4998 (class 2606 OID 17168)
-- Name: campaign_criteria campaign_criteria_grade_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.campaign_criteria
    ADD CONSTRAINT campaign_criteria_grade_id_fkey FOREIGN KEY (grade_id) REFERENCES public.grades(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 4999 (class 2606 OID 17173)
-- Name: campaign_criteria campaign_criteria_status_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.campaign_criteria
    ADD CONSTRAINT campaign_criteria_status_id_fkey FOREIGN KEY (status_id) REFERENCES public.statuses(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5000 (class 2606 OID 17189)
-- Name: campaign_enrollments campaign_enrollments_campaign_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.campaign_enrollments
    ADD CONSTRAINT campaign_enrollments_campaign_id_fkey FOREIGN KEY (campaign_id) REFERENCES public.campaigns(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 5001 (class 2606 OID 17194)
-- Name: campaign_enrollments campaign_enrollments_credential_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.campaign_enrollments
    ADD CONSTRAINT campaign_enrollments_credential_id_fkey FOREIGN KEY (credential_id) REFERENCES public.credentials(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4994 (class 2606 OID 17140)
-- Name: campaign_institution_criteria campaign_institution_criteria_campaign_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.campaign_institution_criteria
    ADD CONSTRAINT campaign_institution_criteria_campaign_id_fkey FOREIGN KEY (campaign_id) REFERENCES public.campaigns(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4995 (class 2606 OID 17145)
-- Name: campaign_institution_criteria campaign_institution_criteria_institution_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.campaign_institution_criteria
    ADD CONSTRAINT campaign_institution_criteria_institution_id_fkey FOREIGN KEY (institution_id) REFERENCES public.institutions(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4993 (class 2606 OID 17126)
-- Name: campaigns campaigns_credential_creator_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.campaigns
    ADD CONSTRAINT campaigns_credential_creator_id_fkey FOREIGN KEY (credential_creator_id) REFERENCES public.credentials(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- TOC entry 4981 (class 2606 OID 16997)
-- Name: credentials credentials_role_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.credentials
    ADD CONSTRAINT credentials_role_id_fkey FOREIGN KEY (role_id) REFERENCES public.user_roles(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 4986 (class 2606 OID 17067)
-- Name: institutions institutions_credential_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.institutions
    ADD CONSTRAINT institutions_credential_id_fkey FOREIGN KEY (credential_id) REFERENCES public.credentials(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- TOC entry 4987 (class 2606 OID 17062)
-- Name: institutions institutions_neighborhood_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.institutions
    ADD CONSTRAINT institutions_neighborhood_id_fkey FOREIGN KEY (neighborhood_id) REFERENCES public.neighborhoods(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 4980 (class 2606 OID 16980)
-- Name: neighborhoods neighborhoods_locality_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.neighborhoods
    ADD CONSTRAINT neighborhoods_locality_id_fkey FOREIGN KEY (locality_id) REFERENCES public.localities(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 4982 (class 2606 OID 17023)
-- Name: people people_document_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.people
    ADD CONSTRAINT people_document_type_id_fkey FOREIGN KEY (document_type_id) REFERENCES public.document_types(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 4983 (class 2606 OID 17018)
-- Name: people people_gender_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.people
    ADD CONSTRAINT people_gender_id_fkey FOREIGN KEY (gender_id) REFERENCES public.genders(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 4984 (class 2606 OID 17028)
-- Name: people people_neighborhood_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.people
    ADD CONSTRAINT people_neighborhood_id_fkey FOREIGN KEY (neighborhood_id) REFERENCES public.neighborhoods(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 4985 (class 2606 OID 17044)
-- Name: personal_contacts personal_contacts_person_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.personal_contacts
    ADD CONSTRAINT personal_contacts_person_id_fkey FOREIGN KEY (person_id) REFERENCES public.people(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4988 (class 2606 OID 17094)
-- Name: student_profiles student_profiles_credential_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_profiles
    ADD CONSTRAINT student_profiles_credential_id_fkey FOREIGN KEY (credential_id) REFERENCES public.credentials(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4989 (class 2606 OID 17104)
-- Name: student_profiles student_profiles_grade_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_profiles
    ADD CONSTRAINT student_profiles_grade_id_fkey FOREIGN KEY (grade_id) REFERENCES public.grades(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 4990 (class 2606 OID 17089)
-- Name: student_profiles student_profiles_institution_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_profiles
    ADD CONSTRAINT student_profiles_institution_id_fkey FOREIGN KEY (institution_id) REFERENCES public.institutions(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 4991 (class 2606 OID 17084)
-- Name: student_profiles student_profiles_person_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_profiles
    ADD CONSTRAINT student_profiles_person_id_fkey FOREIGN KEY (person_id) REFERENCES public.people(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4992 (class 2606 OID 17099)
-- Name: student_profiles student_profiles_status_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_profiles
    ADD CONSTRAINT student_profiles_status_id_fkey FOREIGN KEY (status_id) REFERENCES public.statuses(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5002 (class 2606 OID 17215)
-- Name: updates updates_campaign_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.updates
    ADD CONSTRAINT updates_campaign_id_fkey FOREIGN KEY (campaign_id) REFERENCES public.campaigns(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 5003 (class 2606 OID 17210)
-- Name: updates updates_person_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.updates
    ADD CONSTRAINT updates_person_id_fkey FOREIGN KEY (person_id) REFERENCES public.people(id) ON UPDATE CASCADE ON DELETE CASCADE;


-- Completed on 2026-07-04 05:39:10

--
-- PostgreSQL database dump complete
--

\unrestrict ZE8sjj2ZFqKYxGSNDTyWyav7Ro5bNDi8TaiR5b6aJw76IMOmmfRFAhEyjyak495

