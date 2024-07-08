-- https://www.data.gouv.fr/fr/datasets/aires-de-livraison-a-antibes-juan-les-pins/

FROM 'https://static.data.gouv.fr/resources/aires-de-livraison-a-antibes-juan-les-pins/20240627-085213/antibes-aires-livraison.csv';

-- Donnée
create or replace table aires as (
with a as (FROM 'https://static.data.gouv.fr/resources/aires-de-livraison-a-antibes-juan-les-pins/20240627-085213/antibes-aires-livraison.csv'),
-- Coordonnées
b as (select row_number() over () as ID, string_split(geom_xy, ';') s from a),
-- Traitement remplacement
c as (select ID, replace(s[1], '[', '')::double as x, replace(s[2], ']', '')::double as y from b),
-- Point
d as (select ID, st_point(x, y) geom from c)
from d);

from aires;

-- places au niveau des aires de livraison
create table places_extent as (
with a as (select list(geom).st_collect() geom from aires),
b as (select st_xmin(geom) xmin, st_xmax(geom) xmax, st_ymin(geom) ymin, st_ymax(geom) ymax from a)
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
   b
WHERE 
--primary_name IS NOT NULL
--AND 
bbox.xmin > b.xmin
AND bbox.xmax < b.xmax
AND bbox.ymin > b.ymin
AND bbox.ymax < b.ymax);

from places_extent;

create or replace table places_in_extent as from places_extent;

from places_in_extent;

select count(*) from main.places_in_extent ;

-- places_first
-- distances
-- places_in_extent.ID => id_1
-- first(COLUMNS(*))
create table places_first as (
with a as (
select 
	
from aires, places_in_extent
order by aires.ID, distance asc),
b as (select first(COLUMNS(*)) from a group by ID),
c as (select * from b left join main.places_in_extent d on b.id_1=d.id)
from c);
from places_first;

-- 5 top places
-- row_number
with a as (
select 
aires.ID, places_in_extent.ID, aires.geom, 
st_distance(aires.geom.st_transform('epsg:4326', 'epsg:2154'), 
places_in_extent.geometry.st_transform('epsg:4326', 'epsg:2154')) distance,
row_number() over (partition by aires.ID order by distance)
from aires, places_in_extent
order by aires.ID, distance asc)
from a;

-- 5 top places
-- QUALIFY, rank()
with a as (
select 
	aires.ID, places_in_extent.ID, aires.geom, 
	st_distance(aires.geom.st_transform('epsg:4326', 'epsg:2154'), 
	places_in_extent.geometry.st_transform('epsg:4326', 'epsg:2154')) distance,
from aires, places_in_extent
-- QUALIFY après from
QUALIFY rank() over (partition by aires.ID order by distance) <= 5
order by aires.ID, distance asc)
from a;