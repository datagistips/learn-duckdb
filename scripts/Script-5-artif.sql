-- https://www.data.gouv.fr/fr/datasets/consommation-despaces-naturels-agricoles-et-forestiers-du-1er-janvier-2009-au-1er-janvier-2023/

create or replace table t as (from 'https://static.data.gouv.fr/resources/consommation-despaces-naturels-agricoles-et-forestiers-du-1er-janvier-2009-au-1er-janvier-2023/20240425-073814/conso2009-2023-resultats-com.csv');

from t;

describe t;

select * from (describe t);

select art09act10 from t;

create or replace view v as (SELECT idcom, idcomtxt, surfcom2023, COLUMNS('art\d+hab\d+') FROM t);

from v;

-- UNPIVOT
create or replace table t2 as (
UNPIVOT v
ON COLUMNS(* EXCLUDE (idcom, idcomtxt, surfcom2023))
INTO
    NAME annees
    VALUE surface);
   
 -- APERCU
from t2 order by surface desc;

-- TRAITEMENT DES ANNEES
select annees from t2;
select regexp_extract_all('hello_world', '([a-z ]+)_?', 1);
select regexp_extract('2023-04-15', '(\d+)-(\d+)-(\d+)', ['y', 'm', 'd']);

-- SUITE
with a as (
select idcom, idcomtxt, surfcom2023,
regexp_extract(annees, 'art(\d+)hab(\d+)', ['annee1', 'annee2']) as annees ,
surface
from t2),
b as (select * exclude(annees), (20||annees.annee1)::integer annee1, (20||annees.annee2)::integer annee2, annee2-annee1 diff from a),
c as (select * from b where diff = 1 order by surface desc),
d as (select *, round(surface / surfcom2023 * 100, 1) as pc from c)
from d order by pc desc;

-- EXEMPLES UNPIVOT
CREATE OR REPLACE TABLE monthly_sales
    (empid INTEGER, dept TEXT, Jan INTEGER, Feb INTEGER, Mar INTEGER, Apr INTEGER, May INTEGER, Jun INTEGER);
INSERT INTO monthly_sales VALUES
    (1, 'electronics', 1, 2, 3, 4, 5, 6),
    (2, 'clothes', 10, 20, 30, 40, 50, 60),
    (3, 'cars', 100, 200, 300, 400, 500, 600);
   
FROM monthly_sales;

UNPIVOT monthly_sales
ON jan, feb, mar, apr, may, jun
INTO
    NAME month
    VALUE sales;
   
UNPIVOT monthly_sales
ON COLUMNS(* EXCLUDE (empid, dept))
INTO
    NAME month
    VALUE sales;



