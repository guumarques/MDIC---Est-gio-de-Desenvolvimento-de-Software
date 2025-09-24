--
-- PostgreSQL database dump
--

\restrict QdilJtuq5eEipFhMLwzb1pyeAOd9KvNegC0mAb196jmy9Ib6d2yi9QmcXpkFOCl

-- Dumped from database version 17.6
-- Dumped by pg_dump version 17.6

-- Started on 2025-09-24 09:42:03a

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 218 (class 1259 OID 16392)
-- Name: pets; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pets (
    id integer NOT NULL,
    nome text NOT NULL,
    especie text NOT NULL,
    tutor text NOT NULL,
    criado_em timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT pets_especie_check CHECK ((especie = ANY (ARRAY['Cachorro'::text, 'Gato'::text, 'Outro'::text])))
);


ALTER TABLE public.pets OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 16391)
-- Name: pets_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.pets_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.pets_id_seq OWNER TO postgres;

--
-- TOC entry 4911 (class 0 OID 0)
-- Dependencies: 217
-- Name: pets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.pets_id_seq OWNED BY public.pets.id;


--
-- TOC entry 220 (class 1259 OID 16403)
-- Name: servicos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.servicos (
    id integer NOT NULL,
    pet_id integer NOT NULL,
    descricao text NOT NULL,
    data timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.servicos OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 16402)
-- Name: servicos_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.servicos_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.servicos_id_seq OWNER TO postgres;

--
-- TOC entry 4912 (class 0 OID 0)
-- Dependencies: 219
-- Name: servicos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.servicos_id_seq OWNED BY public.servicos.id;


--
-- TOC entry 4747 (class 2604 OID 16395)
-- Name: pets id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pets ALTER COLUMN id SET DEFAULT nextval('public.pets_id_seq'::regclass);


--
-- TOC entry 4749 (class 2604 OID 16406)
-- Name: servicos id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.servicos ALTER COLUMN id SET DEFAULT nextval('public.servicos_id_seq'::regclass);


--
-- TOC entry 4903 (class 0 OID 16392)
-- Dependencies: 218
-- Data for Name: pets; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.pets (id, nome, especie, tutor, criado_em) FROM stdin;
\.


--
-- TOC entry 4905 (class 0 OID 16403)
-- Dependencies: 220
-- Data for Name: servicos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.servicos (id, pet_id, descricao, data) FROM stdin;
\.


--
-- TOC entry 4913 (class 0 OID 0)
-- Dependencies: 217
-- Name: pets_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.pets_id_seq', 1, false);


--
-- TOC entry 4914 (class 0 OID 0)
-- Dependencies: 219
-- Name: servicos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.servicos_id_seq', 1, false);


--
-- TOC entry 4753 (class 2606 OID 16401)
-- Name: pets pets_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pets
    ADD CONSTRAINT pets_pkey PRIMARY KEY (id);


--
-- TOC entry 4755 (class 2606 OID 16411)
-- Name: servicos servicos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.servicos
    ADD CONSTRAINT servicos_pkey PRIMARY KEY (id);


--
-- TOC entry 4756 (class 2606 OID 16412)
-- Name: servicos servicos_pet_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.servicos
    ADD CONSTRAINT servicos_pet_id_fkey FOREIGN KEY (pet_id) REFERENCES public.pets(id) ON DELETE CASCADE;


-- Completed on 2025-09-24 09:42:03

--
-- PostgreSQL database dump complete
--

\unrestrict QdilJtuq5eEipFhMLwzb1pyeAOd9KvNegC0mAb196jmy9Ib6d2yi9QmcXpkFOCl

