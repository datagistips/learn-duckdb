-- 2. OvertureMaps

load spatial;

-- https://www.icem7.fr/cartographie/3-explorations-bluffantes-avec-duckdb-croiser-les-requetes-spatiales-3-3/
CREATE OR REPLACE MACRO get_gtfs(f, cache) AS 'https://icem7.fr/data/proxy_unzip.php?clear_cache=' || cache || '&file=' || f
|| '&url=https://data.toulouse-metropole.fr/api/explore/v2.1/catalog/datasets/
tisseo-gtfs/file/fc1dda89077cf37e4f7521760e0ef4e9';


-- get_adresse()
CREATE OR REPLACE MACRO get_adresse(adresse) AS format('https://api-adresse.data.gouv.fr/search/?q={}', replace(adresse, ' ', '+'));

select * from read_json_auto(get_adresse('34 bis avenue philippe solari'));

-- Récupération de l'adresse
create or replace table t1 as (select unnest(features, recursive := true) from read_json_auto(get_adresse('34 bis avenue philippe solari')));
from t1;

-- Visualisation
with t2 as (select coordinates[1] x, coordinates[2] y from t1)
select x, y, st_point(x, y) geom from t2;

create or replace table t3 as (
with t2 as (select coordinates[1] x, coordinates[2] y from t1)
select x, y, st_point(x, y) geom from t2);
from t3;

-- Tampon autour du point de 500m
create or replace table t5 as (
with t2 as (select coordinates[1] x, coordinates[2] y from t1),
t3 as (select st_point(x, y) geom from t2),
t4 as (select st_buffer(st_transform(geom, 'epsg:4326', 'epsg:3857'), 1000) geom from t3)
select st_transform(geom, 'epsg:3857', 'epsg:4326') geom from t4);
from t5;

-- BBOX
create or replace table t6 as (
	select st_xmin(geom) xmin,  
		st_ymin(geom) ymin, 
		st_xmax(geom) xmax, 
		st_ymax(geom) ymax 
	from t5
);
from t6;

-- v (OvertureMaps)
create or replace view v as (
	SELECT
       *
    FROM read_parquet('s3://overturemaps-us-west-2/release/2024-06-13-beta.0/theme=places/type=*/*', filename=true, hive_partitioning=1)
);
describe v;
-- id
-- geometry
-- bbox
-- version
-- update_time
-- sources
-- names
-- categories
-- confidence
-- websites
-- socials
-- emails
-- phones
-- brand
-- addresses
-- filename
-- theme
-- type
select * from v limit 5;

show tables;

-- type
select distinct(theme) theme from v order by theme;
select distinct(type) type from v order by type;
select distinct(categories.main) category from v order by category;

-- t7 (places OvertureMaps sur la BBOX)
-- Utilisation de ST_GeomFromWKB
create table t7 as (
SELECT
	id,
   names.primary as primary_name,
   bbox.xmin as x,
   bbox.ymin as y,
   ST_GeomFromWKB(geometry) as geometry,
   categories.main as main_category,
   sources[1].dataset AS primary_source,
   confidence
   FROM read_parquet('s3://overturemaps-us-west-2/release/2024-06-13-beta.0/theme=places/type=*/*', filename=true, hive_partitioning=1), 
   t6
WHERE 
--primary_name IS NOT NULL
--AND 
bbox.xmin > t6.xmin
AND bbox.xmax < t6.xmax
AND bbox.ymin > t6.ymin
AND bbox.ymax < t6.ymax);
from t7 limit 5;

show tables;

-- Recherche du Cerema
SELECT
	id,
   names.primary as primary_name,
   ST_GeomFromWKB(geometry) as geometry,
   categories.main as main_category,
   FROM read_parquet('s3://overturemaps-us-west-2/release/2024-06-13-beta.0/theme=places/type=*/*', filename=true, hive_partitioning=1), 
   t6
WHERE 
primary_name ilike '%cerema%';

-- Export
COPY t7 TO 'C:\Users\mathieu.rajerison\Desktop\TAFF_MAISON\P_APPRENTISSAGE_MANUELS\2024 06 DuckDB\outputs\t7-places.gpkg';

-- Nombre de catégories sur la zone
select main_category, count(*) nb from t7 group by main_category order by nb desc;

-- Arrêts de transport
-- 'https://prochainement.transport.data.gouv.fr/api/gtfs-stops?south=1&north=2&west=3&east=4'
select format('https://prochainement.transport.data.gouv.fr/api/gtfs-stops?south={}&north={}&west={}&east={}', t6.ymin, t6.ymax, t6.xmin, t6.xmax) from t6;

select * from read_json_auto('https://prochainement.transport.data.gouv.fr/api/gtfs-stops?south=43.52891084715881&north=43.5468771528412&west=5.435501306684347&east=5.45338656028602');

-- st_read (KO)
select * from st_read('https://prochainement.transport.data.gouv.fr/api/gtfs-stops?south=43.52891084715881&north=43.5468771528412&west=5.435501306684347&east=5.45338656028602');

create or replace table t9 as (
with a as (select * from read_json_auto('https://prochainement.transport.data.gouv.fr/api/gtfs-stops?south=43.52891084715881&north=43.5468771528412&west=5.435501306684347&east=5.45338656028602')),
b as (select unnest(features, recursive:=true) from a)
select * from b);

describe t9;

-- t10 (colonne geom)
create or replace table t10 as (select *, st_point(coordinates[1], coordinates[2]) geom from t9);

-- Liste des arrêts (60)
select count(distinct(stop_name)) nb from t9;

-- Calcul de la distance au domicile
select st_distance(t10.geom, t3.geom) distance, t10.stop_name from t10, t3 order by distance;

-- Isochrone de 5 min.
from t3;
-- X = 5.444444
-- Y = 43.537894
create or replace table t12 as (from st_read('https://wxs.ign.fr/calcul/geoportail/isochrone/rest/1.0.0/isochrone?resource=bdtopo-pgr&profile=pedestrian&costType=time&costValue=300&direction=departure&point=5.444444,43.537894&constraints=&geometryFormat=geojson'));
from t12;

-- arrêts dans la zone
from t10;
select stops.*
from t10 stops, t12 zone
where st_within(stops.geom, zone.geom);

-- temps à l'arrêt le plus proche
-- FROM
-- X = 5.444444
-- Y = 43.537894
create table t11 as (from read_json_auto('https://wxs.ign.fr/calcul/geoportail/itineraire/rest/1.0.0/isochrone?start=2.337306%2C48.849319&end=2.337306%2C48.849319&resource=bdtopo-osrm&costValue=300&costType=time&profile=pedestrian&direction=departure&constraints=&geometryFormat=geojson&distanceUnit=meter&timeUnit=second&crs=EPSG%3A4326'));
from t11;

-- places dans la zone
select places.*
from t7 places, t12 zone
where st_within(places.geometry, zone.geom);
