-- 1. Déplacements domicile travail en PACA

select * from 'https://www.insee.fr/fr/statistiques/fichier/7630376/base-flux-mobilite-domicile-lieu-travail-2020-csv.zip';

-- t1 (flux)
create or replace table t1 as (from 'C:\Users\mathieu.rajerison\Desktop\TAFF_MAISON\H_APPUI\2024-Gossmann-FluxDomTrav\base-flux-mobilite-domicile-lieu-travail-2020.csv');
from t1;

-- grouping setd
select codgeo, substring(codgeo, 1, 2) dep, sum(NBFLUX_C20_ACTOCC15P) as flux
from t1
group by grouping sets((codgeo), (dep));

-- flux (PACA)
create or replace table flux as (
-- PACA
with a as (
select * from t1 
where SUBSTRING(CODGEO, 1, 2) IN ('04', '05', '06', '13', '83', '84')
OR SUBSTRING(DCLT, 1, 2) IN ('04', '05', '06', '13', '83', '84')),
-- from_to
b as (
select 
CODGEO, DCLT,
format('{}<=>{}', least(CODGEO, DCLT), greatest(CODGEO, DCLT)) as from_to,
CASE WHEN CODGEO = DCLT THEN 0 ELSE 1 END AS external,
NBFLUX_C20_ACTOCC15P as flux from a),
-- somme par commune
c as (
select from_to, first(CODGEO) as codgeo, first(DCLT) as dclt, sum(flux) flux 
from b 
where external = 1 
group by from_to, flux order by flux desc)
from c);

from flux;

-- Monaco
from t1 where DCLT = 'MO001'; -- Monaco

-- Communes
create table comm as (from 'C:\Users\mathieu.rajerison\Desktop\TAFF_MAISON\P_APPRENTISSAGE_MANUELS\2024 06 DuckDB\data\COMMUNE.shp');
create or replace table pts as (select INSEE_COM, geom.st_centroid().st_transform('epsg:2154', 'epsg:4326', true) geom from comm);
from pts;

-- lines
create or replace table lines as (
-- from
with a as (
select flux.*, 
st_x(pts.geom) as from_x, st_y(pts.geom) as from_y
from flux, pts
where flux.CODGEO = pts.INSEE_COM),
-- to
b as (select a.*, st_x(pts.geom) as to_x, st_y(pts.geom) as to_y
from a, pts
where a.DCLT = pts.INSEE_COM),
-- from + to
c as (select * exclude (from_x, from_y, to_x, to_y), st_point(from_x, from_y) as from_pt, 
st_point(to_x, to_y) to_pt
from b),
-- make_line()
d as (select * exclude(from_pt, to_pt), st_makeline(from_pt, to_pt) geom from c)
from d);
from lines;

from lines;

-- Analyses
with a as (
select substring(codgeo, 1, 2)::varchar as dep1, substring(dclt, 1, 2)::varchar as dep2, NBFLUX_C20_ACTOCC15P as flux 
from t1
where dep1 != dep2),
--
b as (
select dep1, dep2, sum(flux) flux,
from a group by(dep1, dep2) 
order by flux desc),
-- 
c as (
select dep1, dep2, flux, 
sum(flux) OVER (PARTITION BY dep2) AS flux_tot_vers_dep2,
round(flux / flux_tot_vers_dep2 * 100) as pc_tot_vers_dep2,
count(*) OVER (PARTITION BY dep2) AS nb_vers_dep2 
from b)
from c order by flux desc;

-- Test columns
select COLUMNS('from.*') from lines;
SELECT COLUMNS(c -> c LIKE '%from%') from lines;
SELECT COLUMNS(* EXCLUDE (from_to)) from lines;

-- Export lines
load spatial;
COPY lines to 'C:\Users\mathieu.rajerison\Desktop\TAFF_MAISON\P_APPRENTISSAGE_MANUELS\2024 06 DuckDB\data\flux.gpkg'
WITH (FORMAT GDAL, DRIVER 'GPKG', LAYER_CREATION_OPTIONS 'WRITE_BBOX=YES');