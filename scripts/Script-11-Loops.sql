-- OK
SELECT st.* FROM (SELECT {'x': 1, 'y': 2, 'z': 3} AS st);

-- OK
SELECT * FROM (SELECT 'http://api/'||unnest([1,2]) AS st);

-- OK
SELECT * FROM (
SELECT 'https://wxs.ign.fr/calcul/geoportail/itineraire/rest/1.0.0/isochrone?start=2.337306%2C48.849319&end=2.337306%2C48.849319&resource=bdtopo-osrm&costValue=300&costType=time&profile=pedestrian&direction=departure&constraints=&geometryFormat=geojson&distanceUnit=meter&timeUnit=second&crs=EPSG%3A4326&toto='||unnest([1,2]) AS st);

-- OK
SELECT list(url) urls
FROM (SELECT 'https://wxs.ign.fr/calcul/geoportail/itineraire/rest/1.0.0/isochrone?start=2.337306%2C48.849319&end=2.337306%2C48.849319&resource=bdtopo-osrm&costValue=300&costType=time&profile=pedestrian&direction=departure&constraints=&geometryFormat=geojson&distanceUnit=meter&timeUnit=second&crs=EPSG%3A4326&toto='||unnest([1,2]) as url) as a

-- KO
-- SQL Error: java.sql.SQLException: Parser Error: syntax error at or near "SELECT"
select * from read_json_auto(
	SELECT list(url) urls
	FROM (SELECT 'https://wxs.ign.fr/calcul/geoportail/itineraire/rest/1.0.0/isochrone?start=2.337306%2C48.849319&end=2.337306%2C48.849319&resource=bdtopo-osrm&costValue=300&costType=time&profile=pedestrian&direction=departure&constraints=&geometryFormat=geojson&distanceUnit=meter&timeUnit=second&crs=EPSG%3A4326&toto='||unnest([1,2]) as url) as a
);

-- OK
select * from read_json_auto(
['https://wxs.ign.fr/calcul/geoportail/itineraire/rest/1.0.0/isochrone?start=2.337306%2C48.849319&end=2.337306%2C48.849319&resource=bdtopo-osrm&costValue=300&costType=time&profile=pedestrian&direction=departure&constraints=&geometryFormat=geojson&distanceUnit=meter&timeUnit=second&crs=EPSG%3A4326',
'https://wxs.ign.fr/calcul/geoportail/itineraire/rest/1.0.0/isochrone?start=2.337306%2C48.849319&end=2.337306%2C48.849319&resource=bdtopo-osrm&costValue=300&costType=time&profile=pedestrian&direction=departure&constraints=&geometryFormat=geojson&distanceUnit=meter&timeUnit=second&crs=EPSG%3A4326']
);

-- OK
select 
list_transform(generate_series(1, 4),
n -> 'https://recherche-entreprises.api.gouv.fr/near_point?lat=43.69875&long=1.46158&radius=0.3&per_page=25&page=' || n)

-- OK
PREPARE query_person AS
    SELECT *
    FROM (select generate_series(?, ?));
    
execute query_person(1, 4);

-- SCALAR
CREATE MACRO one() AS (SELECT 1);

select one();

-- TABLE
CREATE MACRO static_table() AS TABLE
    SELECT 'Hello' AS column1, 'World' AS column2;
   
select * from static_table();

select [
'https://wxs.ign.fr/calcul/geoportail/itineraire/rest/1.0.0/isochrone?start=2.337306%2C48.849319&end=2.337306%2C48.849319&resource=bdtopo-osrm&costValue=300&costType=time&profile=pedestrian&direction=departure&constraints=&geometryFormat=geojson&distanceUnit=meter&timeUnit=second&crs=EPSG%3A4326',
'https://wxs.ign.fr/calcul/geoportail/itineraire/rest/1.0.0/isochrone?start=2.337306%2C48.849319&end=2.337306%2C48.849319&resource=bdtopo-osrm&costValue=300&costType=time&profile=pedestrian&direction=departure&constraints=&geometryFormat=geojson&distanceUnit=meter&timeUnit=second&crs=EPSG%3A4326'
] as liste;

CREATE or replace MACRO static_table() AS TABLE
    select [
'https://wxs.ign.fr/calcul/geoportail/itineraire/rest/1.0.0/isochrone?start=2.337306%2C48.849319&end=2.337306%2C48.849319&resource=bdtopo-osrm&costValue=300&costType=time&profile=pedestrian&direction=departure&constraints=&geometryFormat=geojson&distanceUnit=meter&timeUnit=second&crs=EPSG%3A4326',
'https://wxs.ign.fr/calcul/geoportail/itineraire/rest/1.0.0/isochrone?start=2.337306%2C48.849319&end=2.337306%2C48.849319&resource=bdtopo-osrm&costValue=300&costType=time&profile=pedestrian&direction=departure&constraints=&geometryFormat=geojson&distanceUnit=meter&timeUnit=second&crs=EPSG%3A4326'
] as liste;

select * from static_table();

-- KO
select * from read_json_auto(
static_table()
);

-- SCALAR
CREATE or replace MACRO one() AS (select [
'https://wxs.ign.fr/calcul/geoportail/itineraire/rest/1.0.0/isochrone?start=2.337306%2C48.849319&end=2.337306%2C48.849319&resource=bdtopo-osrm&costValue=300&costType=time&profile=pedestrian&direction=departure&constraints=&geometryFormat=geojson&distanceUnit=meter&timeUnit=second&crs=EPSG%3A4326',
'https://wxs.ign.fr/calcul/geoportail/itineraire/rest/1.0.0/isochrone?start=2.337306%2C48.849319&end=2.337306%2C48.849319&resource=bdtopo-osrm&costValue=300&costType=time&profile=pedestrian&direction=departure&constraints=&geometryFormat=geojson&distanceUnit=meter&timeUnit=second&crs=EPSG%3A4326'
] as liste);

select one() as liste;

-- KO
select * from read_json_auto(
one()
);

select 
list_transform(generate_series(1, 4),
n -> 'https://recherche-entreprises.api.gouv.fr/near_point?lat=43.69875&long=1.46158&radius=0.3&per_page=25&page=' || n)


CREATE or replace MACRO one() AS table (
select generate_series(1, 4)
);

select * from one();

-- OK
select 
list_transform(one(),
n -> 'https://recherche-entreprises.api.gouv.fr/near_point?lat=43.69875&long=1.46158&radius=0.3&per_page=25&page=' || n)

SELECT unnest(results, recursive := true)
FROM read_json_auto(
	list_transform(one(),
    n -> 'https://recherche-entreprises.api.gouv.fr/near_point?lat=43.69875&long=1.46158&radius=0.3&per_page=25&page=' || n)
) ;

SELECT unnest(results, recursive := true)
FROM read_json_auto(
	'https://recherche-entreprises.api.gouv.fr/near_point?lat=43.69875&long=1.46158&radius=0.3&per_page=25&page=1'
) ;


-- TEST ADRESSES
select * from read_json_auto(
["https://api-adresse.data.gouv.fr/search/?q=34+avenue+philippe+solari", 
"https://api-adresse.data.gouv.fr/search/?q=8+bd+du+port"]);

CREATE OR REPLACE MACRO get_adresse() AS (
['https://api-adresse.data.gouv.fr/search/?q=34+avenue+philippe+solari',
'https://api-adresse.data.gouv.fr/search/?q=8+bd+du+port']);

SELECT *
FROM read_json_auto(
	get_adresse()
) ;

CREATE OR REPLACE MACRO get_adresse() AS (
select ['https://api-adresse.data.gouv.fr/search/?q=34+avenue+philippe+solari',
'https://api-adresse.data.gouv.fr/search/?q=8+bd+du+port']);

-- KO
-- SQL Error: java.sql.SQLException: Binder Error: Table function cannot contain subqueries
-- Voir https://duckdb.org/docs/sql/statements/create_macro.html#using-subquery-macros
SELECT *
FROM read_json_auto(
	get_adresse()
) ;

-- Default
CREATE OR replace MACRO add(a, b:=10) AS a + b;
SELECT add(32, 52); -- KO
SELECT add(32, b:=52); -- OK