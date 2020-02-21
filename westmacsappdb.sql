
-- DB Version 6

DROP DATABASE IF EXISTS westmacsappdb;
CREATE DATABASE westmacsappdb;
\c westmacsappdb

--
-- PostgreSQL database dump
--

-- Dumped from database version 12.1
-- Dumped by pg_dump version 12.1

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

--
-- Name: hdb_catalog; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA hdb_catalog;


--
-- Name: hdb_views; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA hdb_views;


--
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


--
-- Name: postgis; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS postgis WITH SCHEMA public;


--
-- Name: EXTENSION postgis; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION postgis IS 'PostGIS geometry, geography, and raster spatial types and functions';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: campsite_facilities; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.campsite_facilities (
    id integer NOT NULL,
    campsite_id integer NOT NULL,
    campsite_facility_type_id integer NOT NULL,
    description character varying(256) NOT NULL,
    logged_tstz timestamp with time zone NOT NULL
);


--
-- Name: campsite_facilities_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.campsite_facilities_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: campsite_facilities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.campsite_facilities_id_seq OWNED BY public.campsite_facilities.id;


--
-- Name: campsite_facility_observations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.campsite_facility_observations (
    id integer NOT NULL,
    campsite_facility_id integer NOT NULL,
    observation_id integer NOT NULL
);


--
-- Name: campsite_facility_observations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.campsite_facility_observations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: campsite_facility_observations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.campsite_facility_observations_id_seq OWNED BY public.campsite_facility_observations.id;


--
-- Name: campsite_facility_types; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.campsite_facility_types (
    id integer NOT NULL,
    name character varying(256) NOT NULL,
    other_names character varying(256)[],
    description character varying(256) NOT NULL
);


--
-- Name: campsite_facility_types_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.campsite_facility_types_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: campsite_facility_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.campsite_facility_types_id_seq OWNED BY public.campsite_facility_types.id;


--
-- Name: campsite_observations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.campsite_observations (
    id integer NOT NULL,
    campsite_id integer NOT NULL,
    observation_id integer NOT NULL
);


--
-- Name: campsite_observations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.campsite_observations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: campsite_observations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.campsite_observations_id_seq OWNED BY public.campsite_observations.id;


--
-- Name: campsites; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.campsites (
    id integer NOT NULL,
    location_id integer NOT NULL,
    name character varying(256) NOT NULL,
    other_names character varying(256)[],
    description character varying(256)
);


--
-- Name: campsites_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.campsites_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: campsites_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.campsites_id_seq OWNED BY public.campsites.id;


--
-- Name: observations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.observations (
    id integer NOT NULL,
    member_id integer NOT NULL,
    note character varying(5000),
    logged_tstz timestamp with time zone NOT NULL
);


--
-- Name: csdesc1; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.csdesc1 AS
 SELECT campsites.id AS csid,
    campsites.name AS csname,
    campsite_facility_types.id AS csfactyid,
    campsite_facility_types.name AS csfactyname,
    campsite_facilities.id AS csfacid,
    "left"((campsite_facilities.description)::text, 25) AS csfactydes,
    campsite_facilities.logged_tstz AS csfaclog,
    observations.id AS obsid,
    "left"((observations.note)::text, 25) AS csfacobs
   FROM ((((public.campsites
     LEFT JOIN public.campsite_facilities ON ((campsites.id = campsite_facilities.campsite_id)))
     LEFT JOIN public.campsite_facility_types ON ((campsite_facilities.campsite_facility_type_id = campsite_facility_types.id)))
     LEFT JOIN public.campsite_facility_observations ON ((campsite_facilities.id = campsite_facility_observations.campsite_facility_id)))
     LEFT JOIN public.observations ON ((campsite_facility_observations.observation_id = observations.id)));


--
-- Name: VIEW csdesc1; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON VIEW public.csdesc1 IS 'cs + fac + facobs';


--
-- Name: csfac; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.csfac AS
 SELECT campsites.id AS campid,
    campsites.name AS campname,
    campsite_facility_types.name AS facname,
    campsite_facilities.description AS facdesc,
    campsite_facilities.logged_tstz AS logged
   FROM ((public.campsites
     JOIN public.campsite_facilities ON ((campsites.id = campsite_facilities.campsite_id)))
     JOIN public.campsite_facility_types ON ((campsite_facilities.campsite_facility_type_id = campsite_facility_types.id)));


--
-- Name: VIEW csfac; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON VIEW public.csfac IS 'all campsite facilities';


--
-- Name: csfacobs; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.csfacobs AS
 SELECT campsites.id AS campid,
    campsites.name AS campname,
    campsite_facility_types.name AS facname,
    observations.note AS facnote,
    observations.logged_tstz AS loggedobs
   FROM ((((public.campsites
     JOIN public.campsite_facilities ON ((campsites.id = campsite_facilities.campsite_id)))
     JOIN public.campsite_facility_types ON ((campsite_facilities.campsite_facility_type_id = campsite_facility_types.id)))
     JOIN public.campsite_facility_observations ON ((campsite_facilities.id = campsite_facility_observations.campsite_facility_id)))
     JOIN public.observations ON ((campsite_facility_observations.observation_id = observations.id)));


--
-- Name: VIEW csfacobs; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON VIEW public.csfacobs IS 'all campsite facility observations';


--
-- Name: locations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.locations (
    id integer NOT NULL,
    coords point NOT NULL,
    elevation integer
);


--
-- Name: cslocs; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.cslocs AS
 SELECT campsites.id AS csid,
    campsites.name AS csname,
    locations.id AS locid,
    locations.coords
   FROM (public.campsites
     JOIN public.locations ON ((campsites.location_id = locations.id)));


--
-- Name: VIEW cslocs; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON VIEW public.cslocs IS 'all campsite locations';


--
-- Name: csobs; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.csobs AS
 SELECT campsites.name,
    observations.note,
    observations.logged_tstz AS logged
   FROM ((public.observations
     JOIN public.campsite_observations ON ((observations.id = campsite_observations.observation_id)))
     JOIN public.campsites ON ((campsite_observations.campsite_id = campsites.id)));


--
-- Name: VIEW csobs; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON VIEW public.csobs IS 'all campsite observations';


--
-- Name: cswatertank; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.cswatertank AS
 SELECT campsites.id AS csid,
    campsites.name AS csname
   FROM ((public.campsites
     JOIN public.campsite_facilities ON ((campsites.id = campsite_facilities.campsite_id)))
     JOIN public.campsite_facility_types ON ((campsite_facilities.campsite_facility_type_id = campsite_facility_types.id)))
  WHERE (campsite_facility_types.id = 2);


--
-- Name: VIEW cswatertank; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON VIEW public.cswatertank IS 'campsites with water tank(s)';


--
-- Name: locations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.locations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: locations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.locations_id_seq OWNED BY public.locations.id;


--
-- Name: media_types; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.media_types (
    id integer NOT NULL,
    name character varying(256)
);


--
-- Name: media_types_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.media_types_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: media_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.media_types_id_seq OWNED BY public.media_types.id;


--
-- Name: members; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.members (
    id integer NOT NULL,
    profile_name character varying(256)
);


--
-- Name: members_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.members_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: members_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.members_id_seq OWNED BY public.members.id;


--
-- Name: observation_medias; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.observation_medias (
    id integer NOT NULL,
    observation_id integer NOT NULL,
    media_type_id integer NOT NULL,
    link character varying(256)
);


--
-- Name: observation_medias_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.observation_medias_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: observation_medias_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.observation_medias_id_seq OWNED BY public.observation_medias.id;


--
-- Name: observations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.observations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: observations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.observations_id_seq OWNED BY public.observations.id;


--
-- Name: place_observations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.place_observations (
    id integer NOT NULL,
    place_id integer NOT NULL,
    observation_id integer NOT NULL
);


--
-- Name: place_observations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.place_observations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: place_observations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.place_observations_id_seq OWNED BY public.place_observations.id;


--
-- Name: places; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.places (
    id integer NOT NULL,
    location_id integer NOT NULL,
    trail_id integer NOT NULL,
    sovereign_name character varying(256),
    sovereign_name_pronounce character varying(256),
    name character varying(256) NOT NULL,
    other_names character varying(256)[],
    description character varying(5000) NOT NULL
);


--
-- Name: places_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.places_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: places_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.places_id_seq OWNED BY public.places.id;


--
-- Name: plobs; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.plobs AS
 SELECT places.name,
    observations.note,
    observations.logged_tstz AS logged
   FROM ((public.observations
     JOIN public.place_observations ON ((observations.id = place_observations.observation_id)))
     JOIN public.places ON ((place_observations.place_id = places.id)));


--
-- Name: VIEW plobs; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON VIEW public.plobs IS 'all place observations';


--
-- Name: plocs; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.plocs AS
 SELECT locations.id AS locid,
    locations.coords,
    places.id AS placeid,
    places.name AS placename
   FROM (public.locations
     JOIN public.places ON ((locations.id = places.location_id)));


--
-- Name: VIEW plocs; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON VIEW public.plocs IS 'all place locations and names';


--
-- Name: trailheads; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.trailheads (
    id integer NOT NULL,
    location_id integer NOT NULL,
    trail_id integer NOT NULL,
    sequence integer NOT NULL,
    name character varying(256) NOT NULL,
    other_names character varying(256)[],
    description character varying(256) NOT NULL
);


--
-- Name: thlocs; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.thlocs AS
 SELECT locations.id AS locid,
    locations.coords,
    trailheads.sequence,
    trailheads.name,
    places.name AS placename
   FROM ((public.locations
     JOIN public.trailheads ON ((trailheads.location_id = locations.id)))
     LEFT JOIN public.places ON ((locations.id = places.location_id)));


--
-- Name: VIEW thlocs; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON VIEW public.thlocs IS 'all trailhead locations and names';


--
-- Name: trailheads_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.trailheads_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: trailheads_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.trailheads_id_seq OWNED BY public.trailheads.id;


--
-- Name: trails; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.trails (
    id integer NOT NULL,
    location_id integer NOT NULL,
    name character varying(256) NOT NULL,
    other_names character varying(256)[],
    description character varying(256) NOT NULL
);


--
-- Name: trails_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.trails_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: trails_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.trails_id_seq OWNED BY public.trails.id;


--
-- Name: campsite_facilities id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.campsite_facilities ALTER COLUMN id SET DEFAULT nextval('public.campsite_facilities_id_seq'::regclass);


--
-- Name: campsite_facility_observations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.campsite_facility_observations ALTER COLUMN id SET DEFAULT nextval('public.campsite_facility_observations_id_seq'::regclass);


--
-- Name: campsite_facility_types id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.campsite_facility_types ALTER COLUMN id SET DEFAULT nextval('public.campsite_facility_types_id_seq'::regclass);


--
-- Name: campsite_observations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.campsite_observations ALTER COLUMN id SET DEFAULT nextval('public.campsite_observations_id_seq'::regclass);


--
-- Name: campsites id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.campsites ALTER COLUMN id SET DEFAULT nextval('public.campsites_id_seq'::regclass);


--
-- Name: locations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.locations ALTER COLUMN id SET DEFAULT nextval('public.locations_id_seq'::regclass);


--
-- Name: media_types id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.media_types ALTER COLUMN id SET DEFAULT nextval('public.media_types_id_seq'::regclass);


--
-- Name: members id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.members ALTER COLUMN id SET DEFAULT nextval('public.members_id_seq'::regclass);


--
-- Name: observation_medias id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.observation_medias ALTER COLUMN id SET DEFAULT nextval('public.observation_medias_id_seq'::regclass);


--
-- Name: observations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.observations ALTER COLUMN id SET DEFAULT nextval('public.observations_id_seq'::regclass);


--
-- Name: place_observations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.place_observations ALTER COLUMN id SET DEFAULT nextval('public.place_observations_id_seq'::regclass);


--
-- Name: places id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.places ALTER COLUMN id SET DEFAULT nextval('public.places_id_seq'::regclass);


--
-- Name: trailheads id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.trailheads ALTER COLUMN id SET DEFAULT nextval('public.trailheads_id_seq'::regclass);


--
-- Name: trails id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.trails ALTER COLUMN id SET DEFAULT nextval('public.trails_id_seq'::regclass);


--
-- Data for Name: campsite_facilities; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.campsite_facilities (id, campsite_id, campsite_facility_type_id, description, logged_tstz) FROM stdin;
1	2	3	1 x toilet	2019-07-13 12:00:00+10
2	2	4	Shelter suitable for groups. No raised platforms for sleeping pads, although there are raised timber platforms on the site.	2019-07-13 12:00:00+10
3	2	2	1 x tank	2019-07-13 12:00:00+10
\.


--
-- Data for Name: campsite_facility_observations; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.campsite_facility_observations (id, campsite_facility_id, observation_id) FROM stdin;
1	1	5
2	2	6
3	3	7
\.


--
-- Data for Name: campsite_facility_types; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.campsite_facility_types (id, name, other_names, description) FROM stdin;
1	Tap water	\N	Water available from taps.
2	Tank water	\N	Tank water available. All tank water should be treated prior to drinking.
3	Toilet	\N	Toilet available.
4	Shelter	\N	Shelter available.
5	USB charging station	\N	USB charging available.
6	Shower	\N	Shower available.
\.


--
-- Data for Name: campsite_observations; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.campsite_observations (id, campsite_id, observation_id) FROM stdin;
1	1	1
5	7	8
6	8	9
7	6	10
8	5	4
9	4	3
\.


--
-- Data for Name: campsites; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.campsites (id, location_id, name, other_names, description) FROM stdin;
1	17	Millers Flat Campsite	\N	...Millers Flat Campsite...
2	13	Wallaby Gap Campsite	\N	...Wallaby Gap Campsite...
3	19	Brinkley Bluff Campsite	\N	Dry camp. There are a number of campsites atop Brinkley, facing north and south. Recommended camp, weather/wind permitting.
4	20	Stuarts Pass Campsite	\N	Dry camp. A nice spot with trees and shade.
5	21	Fringe Lilly Creek Campsite	\N	Dry camping in or along the river bed.
6	22	Ghost Gum Flat Campsite	\N	Dry camping, peaceful, not much else.
7	15	Mulga Camp	\N	Located just off the trail and atop a rise. Large area with many tent pads.
8	2	Simpson's Gap	\N	One of the best know attractions on the trail which attracts many visitors by road and foot.
9	4	Standley Chasm	\N	Camping fees apply here. Another of the larger attractions.
10	5	Section 4/5 junction	\N	...Section 4/5 junction...
11	6	Hugh Gorge Campsite	\N	...Located at the mouth of Hugh Gorge as it opens onto the Alice Valley....
12	23	Rocky Gully Campsite	\N	Not much to see here. Consider filling up with water and moving on. Ghost Gum Flat is back to the East and lovely but there are no facilities.
13	7	Ellery Creek Campsite	\N	Large, busy campsite after coming of the Alice Valley.
14	8	Serpentine Gorge Campsite	\N	Lovely little oasis.
15	9	Serpentine Chalet Dam Campsite	\N	Last stop before the big dry stretch.
16	24	Waterfall Gorge Campsite	\N	Dry camp. Big zig-zag out to the west! Start early! Another small campsite 10 mins north.
17	10	Ormiston Gorge Campsite	\N	Busy campsite. Food drop location.
18	11	Finke River Campsite	\N	This is where the Finke River begins.
\.


--
-- Data for Name: locations; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.locations (id, coords, elevation) FROM stdin;
1	(-23.670853,133.885027)	\N
2	(-23.680294,133.717604)	\N
3	(-23.664314,133.537723)	\N
4	(-23.724909,133.46922)	\N
5	(-23.719362,133.347333)	\N
6	(-23.701831,133.259303)	\N
7	(-23.779522,133.073059)	\N
8	(-23.759522,132.978983)	\N
9	(-23.727294,132.909986)	\N
10	(-23.632155,132.726588)	\N
11	(-23.659285,132.678387)	\N
12	(-23.577322,132.518506)	\N
13	(-23.668264,133.79529)	\N
14	(-23.680737,133.73043)	\N
15	(-23.66473,133.61289)	\N
16	(-23.6709,133.62999)	\N
17	(-23.69372,133.49314)	\N
18	(-23.71083,133.39201)	1197
19	(-23.7107,133.39205)	1197
20	(-23.7132,133.3771)	712
21	(-23.69102,133.30042)	793
22	(-23.72079,133.2404)	753
23	(-23.75889,133.16809)	757
24	(-23.68719,132.82523)	866
\.


--
-- Data for Name: media_types; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.media_types (id, name) FROM stdin;
\.


--
-- Data for Name: members; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.members (id, profile_name) FROM stdin;
1	Lara
\.


--
-- Data for Name: observation_medias; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.observation_medias (id, observation_id, media_type_id, link) FROM stdin;
\.


--
-- Data for Name: observations; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.observations (id, member_id, note, logged_tstz) FROM stdin;
1	1	Burnt-out dust bowl with little more than placename signage. We passed through.	2019-07-13 12:00:00+10
2	1	Fantastic view of Arenge Bluff (which actually you can see for days behind you when travelling E2W). Small area with tent pads enough for a couple of tents	2019-07-13 12:00:00+10
3	1	The river bed was completely dry. Was a lovely place to stop for a rest in some shade after the steep descent down the west of Brinkley Bluff. The walk into section 4/5 junction was easy, flat and about 2 hours.	2019-07-13 12:00:00+10
4	1	Large area is suitable for group camping. I never found a sign-post so I was glad I had researched the location of this camp before coming! The river bed was completely dry. Was a lovely place to camp after the long zig-zag down Razorback Ridge. We saw a small wallaby. Very peaceful. Shady. Stunning entrance to Linear Valley	2019-07-13 12:00:00+10
5	1	Good working order and toilet paper had been stocked by the ranger. Don't shine your headlamp into the toilet!	2019-07-13 12:00:00+10
6	1	Good size, bench seats around the perimeter.	2019-07-13 12:00:00+10
7	1	1 Tank in good working order, no issue.	2019-07-13 12:00:00+10
8	1	We were suprosed to find the camp so far up a hill but the tent pads were nice. We were right cn the cliff, I think perhaps the toilet drainage went down there because we got some very bad smells all night!	2019-07-13 12:00:00+10
9	1	We passed through. The phone signal amplifier didn't work for me. Had a lovely lunch in the shade on the sandy river bank.	2019-07-13 12:00:00+10
10	1	Peeps on the trail told us that camping here was prefferable to Rocky Gully and they were right. Lovely little spot - oasis. Remember, the cool air settles on the valley floor so be prepared for cold! We had ice on our tent poles! This is a dry camp. Stock up on water on your way through Hugh Gorge from the East or Ricky Gully to the west. There was one peice of camp furniture - a raised timber platform.	2019-07-13 12:00:00+10
\.


--
-- Data for Name: place_observations; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.place_observations (id, place_id, observation_id) FROM stdin;
1	16	2
\.


--
-- Data for Name: places; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.places (id, location_id, trail_id, sovereign_name, sovereign_name_pronounce, name, other_names, description) FROM stdin;
1	1	1	\N	\N	Telegraph Station	\N	The original site of the first European settlement in Alice Springs. It was established in 1871 to relay messages between Darwin and Adelaide along Australia’s Overland Telegraph Line.
2	2	1	Rungutjirpa	\N	Simpson's Gap	\N	...Simpson's Gap...
3	3	1	Iwupataka	\N	Jay Creek	\N	...Jay Creek...
4	4	1	Angkerle Atwatye	\N	Standley Chasm	\N	Standley Chasm - Angkerle Atwatye “the Gap of Water”
5	5	1	\N	\N	Birthday Waterhole	\N	...Birthday Waterhole...
6	6	1	\N	\N	Hugh Gorge Campsite	{"Hugh Gorge"}	...Hugh Gorge Campsite...
7	7	1	Udepata	\N	Ellery Creek	{"Ellery Creek Big Hole"}	...Ellery Creek...
8	8	1	Ulpma	uhlp-Mah	Serpentine Gorge	\N	...Serpentine Gorge...
9	9	1	\N	\N	Serpentine Chalet Dam	\N	...Serpentine Chalet Dam...
10	10	1	Kwartatuma	\N	Ormiston Gorge	\N	...Ormiston Gorge...
11	11	1	Larapinta	\N	Finke River	{"Lara Beinta (Salt River)"}	The Finke River is thought to be the oldest river bed in the world. One of the four main rivers leading to the Eyre Basin, although water flows rarely reach that far.
12	12	1	Yarretyeke	Yuh-ret-CHUCKA	Redbank Gorge	\N	Redbank Gorge sits below Mt Sonder - Rrewtyepme (Rroo-CHOOP-muh).
13	13	1	\N	\N	Wallaby Gap	\N	...Wallaby Gap...
14	14	1	\N	\N	Hat Hill Saddle	\N	Hat Hill Saddle appears just before Simpon's gap when walking the trail E2W.
15	15	1	\N	\N	Mulga Camp	\N	...Mulga Camp...
16	16	1	\N	\N	Arenge View	\N	Viewing of Arenge Bluff which towers above this part of the trail.
17	17	1	\N	\N	Millers Flat	\N	Sits at the junction of the high and low routes, and is the entrance to the rocky gorges leading toward Standley Chasm.
18	18	1	\N	\N	Brinkley Bluff	\N	Third highest peak in the NT and the second highest on the trail. Named by John McDouall Stuart in the 1860's. Views for days. A cairn adorns the apex. Be prepared for a long scramble up the eastern side. Extreme descent to the west, leading down to Stuart's Pass.
19	20	1	\N	\N	Stuarts Pass	\N	Where John McDouall Stuart finally found a way north through the ranges, in the 1860's. Approximatley 2.5KM from the top of Brinkley Bluff. Dry camping in or along the river bed.
20	21	1	\N	\N	Fringe Lilly Creek	\N	Beautiful place at the bottom of the long zig-zag down and off Razorback Ridge, at the entrance to Linear Valley. Stunning. Dry camping in or along the river bed.
21	22	1	\N	\N	Ghost Gum Flat	\N	Bring water with you and stay for the night. You will have to walk here. Lovely little oasis near the middle of the Alice Valley. There's a sign-post, one raised timber platform and that's about it.
\.


--
-- Data for Name: spatial_ref_sys; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.spatial_ref_sys (srid, auth_name, auth_srid, srtext, proj4text) FROM stdin;
\.


--
-- Data for Name: trailheads; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.trailheads (id, location_id, trail_id, sequence, name, other_names, description) FROM stdin;
1	1	1	1	Section 1 Trailhead	\N	Starting point when walking East to West. The trail was constructed for E2W orientation, although many people walk W2E.
2	2	1	2	Section 1/2 Trailhead	\N	...Section 1/2 Trailhead...
3	3	1	3	Section 2/3 Trailhead	\N	...Section 2/3 Trailhead...
4	4	1	4	Section 3/4 Trailhead	\N	...Section 3/4 Trailhead...
5	5	1	5	Section 4/5 Trailhead	\N	...Section 4/5 Trailhead...
6	6	1	6	Section 5/6 Trailhead	\N	...Section 5/6 Trailhead...
7	7	1	7	Section 6/7 Trailhead	\N	...Section 6/7 Trailhead...
8	8	1	8	Section 7/8 Trailhead	\N	...Section 7/8 Trailhead...
9	9	1	9	Section 8/9 Trailhead	\N	...Section 8/9 Trailhead...
10	10	1	10	Section 9/10 Trailhead	\N	...Section 9/10 Trailhead...
11	11	1	11	Section 10/11 Trailhead	\N	...Section 10/11 Trailhead...
12	12	1	12	Section 11/12 Trailhead	\N	...Section 11/12 Trailhead...
\.


--
-- Data for Name: trails; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.trails (id, location_id, name, other_names, description) FROM stdin;
1	1	Larapinta Trail	{}	Australia's greatest walking trail
\.


--
-- Name: campsite_facilities_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.campsite_facilities_id_seq', 3, true);


--
-- Name: campsite_facility_observations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.campsite_facility_observations_id_seq', 3, true);


--
-- Name: campsite_facility_types_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.campsite_facility_types_id_seq', 6, true);


--
-- Name: campsite_observations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.campsite_observations_id_seq', 9, true);


--
-- Name: campsites_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.campsites_id_seq', 18, true);


--
-- Name: locations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.locations_id_seq', 24, true);


--
-- Name: media_types_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.media_types_id_seq', 1, false);


--
-- Name: members_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.members_id_seq', 1, true);


--
-- Name: observation_medias_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.observation_medias_id_seq', 1, false);


--
-- Name: observations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.observations_id_seq', 10, true);


--
-- Name: place_observations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.place_observations_id_seq', 3, true);


--
-- Name: places_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.places_id_seq', 21, true);


--
-- Name: trailheads_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.trailheads_id_seq', 12, true);


--
-- Name: trails_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.trails_id_seq', 1, true);


--
-- Name: campsite_facilities campsite_facilities_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.campsite_facilities
    ADD CONSTRAINT campsite_facilities_pkey PRIMARY KEY (id);


--
-- Name: campsite_facility_observations campsite_facility_observations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.campsite_facility_observations
    ADD CONSTRAINT campsite_facility_observations_pkey PRIMARY KEY (id);


--
-- Name: campsite_facility_types campsite_facility_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.campsite_facility_types
    ADD CONSTRAINT campsite_facility_types_pkey PRIMARY KEY (id);


--
-- Name: campsite_observations campsite_observations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.campsite_observations
    ADD CONSTRAINT campsite_observations_pkey PRIMARY KEY (id);


--
-- Name: campsites campsites_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.campsites
    ADD CONSTRAINT campsites_pkey PRIMARY KEY (id);


--
-- Name: locations locations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.locations
    ADD CONSTRAINT locations_pkey PRIMARY KEY (id);


--
-- Name: media_types media_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.media_types
    ADD CONSTRAINT media_types_pkey PRIMARY KEY (id);


--
-- Name: members members_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.members
    ADD CONSTRAINT members_pkey PRIMARY KEY (id);


--
-- Name: observation_medias observation_medias_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.observation_medias
    ADD CONSTRAINT observation_medias_pkey PRIMARY KEY (id);


--
-- Name: observations observations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.observations
    ADD CONSTRAINT observations_pkey PRIMARY KEY (id);


--
-- Name: place_observations place_observations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.place_observations
    ADD CONSTRAINT place_observations_pkey PRIMARY KEY (id);


--
-- Name: places places_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.places
    ADD CONSTRAINT places_pkey PRIMARY KEY (id);


--
-- Name: trailheads trailheads_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.trailheads
    ADD CONSTRAINT trailheads_pkey PRIMARY KEY (id);


--
-- Name: trails trails_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.trails
    ADD CONSTRAINT trails_pkey PRIMARY KEY (id);


--
-- Name: campsite_facilities campsite_facilities_campsite_facility_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.campsite_facilities
    ADD CONSTRAINT campsite_facilities_campsite_facility_type_id_fkey FOREIGN KEY (campsite_facility_type_id) REFERENCES public.campsite_facility_types(id);


--
-- Name: campsite_facilities campsite_facilities_campsite_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.campsite_facilities
    ADD CONSTRAINT campsite_facilities_campsite_id_fkey FOREIGN KEY (campsite_id) REFERENCES public.campsites(id);


--
-- Name: campsite_facility_observations campsite_facility_observations_campsite_facility_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.campsite_facility_observations
    ADD CONSTRAINT campsite_facility_observations_campsite_facility_id_fkey FOREIGN KEY (campsite_facility_id) REFERENCES public.campsite_facilities(id);


--
-- Name: campsite_facility_observations campsite_facility_observations_observation_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.campsite_facility_observations
    ADD CONSTRAINT campsite_facility_observations_observation_id_fkey FOREIGN KEY (observation_id) REFERENCES public.observations(id);


--
-- Name: campsite_observations campsite_observations_campsite_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.campsite_observations
    ADD CONSTRAINT campsite_observations_campsite_id_fkey FOREIGN KEY (campsite_id) REFERENCES public.campsites(id);


--
-- Name: campsite_observations campsite_observations_observation_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.campsite_observations
    ADD CONSTRAINT campsite_observations_observation_id_fkey FOREIGN KEY (observation_id) REFERENCES public.observations(id);


--
-- Name: campsites campsites_location_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.campsites
    ADD CONSTRAINT campsites_location_id_fkey FOREIGN KEY (location_id) REFERENCES public.locations(id);


--
-- Name: observation_medias observation_medias_media_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.observation_medias
    ADD CONSTRAINT observation_medias_media_type_id_fkey FOREIGN KEY (media_type_id) REFERENCES public.media_types(id);


--
-- Name: observation_medias observation_medias_observation_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.observation_medias
    ADD CONSTRAINT observation_medias_observation_id_fkey FOREIGN KEY (observation_id) REFERENCES public.observations(id);


--
-- Name: observations observations_member_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.observations
    ADD CONSTRAINT observations_member_id_fkey FOREIGN KEY (member_id) REFERENCES public.members(id);


--
-- Name: place_observations place_observations_observation_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.place_observations
    ADD CONSTRAINT place_observations_observation_id_fkey FOREIGN KEY (observation_id) REFERENCES public.observations(id);


--
-- Name: place_observations place_observations_place_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.place_observations
    ADD CONSTRAINT place_observations_place_id_fkey FOREIGN KEY (place_id) REFERENCES public.places(id);


--
-- Name: places places_location_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.places
    ADD CONSTRAINT places_location_id_fkey FOREIGN KEY (location_id) REFERENCES public.locations(id);


--
-- Name: places places_trail_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.places
    ADD CONSTRAINT places_trail_id_fkey FOREIGN KEY (trail_id) REFERENCES public.trails(id);


--
-- Name: trailheads trailheads_location_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.trailheads
    ADD CONSTRAINT trailheads_location_id_fkey FOREIGN KEY (location_id) REFERENCES public.locations(id);


--
-- Name: trailheads trailheads_trail_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.trailheads
    ADD CONSTRAINT trailheads_trail_id_fkey FOREIGN KEY (trail_id) REFERENCES public.trails(id);


--
-- Name: trails trails_location_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.trails
    ADD CONSTRAINT trails_location_id_fkey FOREIGN KEY (location_id) REFERENCES public.locations(id);


--
-- PostgreSQL database dump complete
--


create user hasurauser with password 'password';
grant all privileges on database westmacsappdb to hasurauser;
CREATE EXTENSION IF NOT EXISTS pgcrypto;
CREATE EXTENSION IF NOT EXISTS postgis;
DROP SCHEMA hdb_catalog;
DROP SCHEMA hdb_views;
CREATE SCHEMA IF NOT EXISTS hdb_catalog;
CREATE SCHEMA IF NOT EXISTS hdb_views;
ALTER SCHEMA hdb_catalog OWNER TO hasurauser;
ALTER SCHEMA hdb_views OWNER TO hasurauser;
GRANT SELECT ON ALL TABLES IN SCHEMA information_schema TO hasurauser;
GRANT SELECT ON ALL TABLES IN SCHEMA pg_catalog TO hasurauser;
GRANT USAGE ON SCHEMA public TO hasurauser;
GRANT ALL ON ALL TABLES IN SCHEMA public TO hasurauser;
GRANT ALL ON ALL SEQUENCES IN SCHEMA public TO hasurauser;

