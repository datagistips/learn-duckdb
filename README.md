# Notes

## A voir

- Extensions ?
- Lignes Guides
- https://duckdb.org/docs/guides/file_formats/csv_import.html
- https://duckdb.org/docs/extensions/spatial.html
- hive_partitioning
- parquet ?
- format duckdb ?
- vidéo duckdb
- JSON dans DuckDB
- length
- PostgreSQL https://duckdb.org/docs/guides/database_integration/postgres
- sniff_csv ?
- multiple files https://duckdb.org/docs/data/multiple_files/overview
- partitioning https://duckdb.org/docs/data/partitioning/hive_partitioning
- SQL https://duckdb.org/docs/sql/introduction
- Extensions https://duckdb.org/docs/extensions
- sélection sur les noms de colonnes
- window functions
- friendlier https://duckdb.org/2022/05/04/friendlier-sql.html
- Arrow
- nouveaux formats colonnaires
- vectorized query ?
- DBeaver
- filter push down
- ordre de tri parquet
- parquet compression et codage
- friendly SQL https://duckdb.org/docs/guides/sql_features/friendly_sql 
- Itérations
- arg_max via icem7
- window functions

## REPLACE

```
SELECT * REPLACE (lower(city) AS city) FROM addresses;
```



## A regarder

- Spatial https://x.com/ericMauviere/status/1737066477994324046
- GTFS https://www.icem7.fr/cartographie/3-explorations-bluffantes-avec-duckdb-croiser-les-requetes-spatiales-3-3/
- Parquet sur datagouv https://www.data.gouv.fr/fr/datasets/?format%3Dparquet%2F=
- https://geotribu.fr/articles/2023/2023-12-19_duckdb-donnees-spatiales/
- https://tech.marksblogg.com/global-flight-tracking-adsb.html
- https://tech.marksblogg.com/natural-earth-free-gis-data.html
- API https://www.icem7.fr/pedagogie/3-explorations-bluffantes-avec-duckdb-butiner-des-api-json-2-3/
- POI Overture https://dev.to/savo/spatial-data-analysis-with-duckdb-40j9
- fast https://duckdb.org/why_duckdb.html#duckdbisfast
- Python https://rfsaldanha.github.io/posts/query_remot_parquet_file.html
- GROUP BY ALL
- https://cloudnativegeo.org/blog/2023/09/duckdb-the-indispensable-geospatial-tool-you-didnt-know-you-were-missing/
- google geoparquet https://github.com/cholmes/duckdb-geoparquet-tutorials
- writing data https://duckdb.org/docs/extensions/postgres.html#writing-data-to-postgres
- https://duckdb.org/2023/04/28/spatial.html
- https://duckdb.org/docs/sql/query_syntax/select.html
- DISTINCT ON

## information_schema

https://duckdb.org/docs/sql/information_schema.html

## Spatial

EXCLUDE

```
select * EXCLUDE geometry, ST_GeomFromWKB(geometry) AS geometry from 'CA.parquet'
```



## Live demo (appli web WASM)

https://shell.duckdb.org/

## Extensions

```
SELECT extension_name, installed, description FROM duckdb_extensions();
```

Voir si spatial présent

```
┌──────────────────┬───────────┬────────────────────────────────────────────────────────────────────────────────────┐
│  extension_name  │ installed │                                    description                                     │
│     varchar      │  boolean  │                                      varchar                                       │
├──────────────────┼───────────┼────────────────────────────────────────────────────────────────────────────────────┤
│ arrow            │ false     │ A zero-copy data integration between Apache Arrow and DuckDB                       │
│ autocomplete     │ true      │ Adds support for autocomplete in the shell                                         │
│ aws              │ false     │ Provides features that depend on the AWS SDK                                       │
│ azure            │ false     │ Adds a filesystem abstraction for Azure blob storage to DuckDB                     │
│ delta            │ false     │ Adds support for Delta Lake                                                        │
│ excel            │ false     │ Adds support for Excel-like format strings                                         │
│ fts              │ true      │ Adds support for Full-Text Search Indexes                                          │
│ httpfs           │ false     │ Adds support for reading and writing files over a HTTP(S) connection               │
│ iceberg          │ false     │ Adds support for Apache Iceberg                                                    │
│ icu              │ true      │ Adds support for time zones and collations using the ICU library                   │
│ inet             │ true      │ Adds support for IP-related data types and functions                               │
│ jemalloc         │ false     │ Overwrites system allocator with JEMalloc                                          │
│ json             │ true      │ Adds support for JSON operations                                                   │
│ motherduck       │ false     │ Enables motherduck integration with the system                                     │
│ mysql_scanner    │ false     │ Adds support for connecting to a MySQL database                                    │
│ parquet          │ true      │ Adds support for reading and writing parquet files                                 │
│ postgres_scanner │ false     │ Adds support for connecting to a Postgres database                                 │
│ shell            │ true      │                                                                                    │
│ spatial          │ true      │ Geospatial extension that adds support for working with spatial data and functions │
│ sqlite_scanner   │ false     │ Adds support for reading and writing SQLite database files                         │
│ substrait        │ false     │ Adds support for the Substrait integration                                         │
│ tpcds            │ false     │ Adds TPC-DS data generation and query support                                      │
│ tpch             │ true      │ Adds TPC-H data generation and query support                                       │
│ vss              │ false     │ Adds indexing support to accelerate Vector Similarity Search                       │
├──────────────────┴───────────┴────────────────────────────────────────────────────────────────────────────────────┤
│ 24 rows                                                                                                 3 columns │
└───────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
```

- persistent mode or in memory mode (`:memory:`)
- db, duckdb, ddb
- https://duckdb.org/docs/connect/concurrency MVCC, optimistic concurrency control
- https://duckdb.org/docs/connect/concurrency non lu

## Friendly SQL

https://duckdb.org/2022/05/04/friendlier-sql.html

- EXCLUDE

- REPLACE

- GROUP BY ALL

- ORDER BY ALL (left to right)

- alias in SELECT

- Case insensitivity

- ```
  CREATE TABLE mandalorian AS SELECT 1 AS "THIS_IS_THE_WAY";
  SELECT this_is_the_way FROM mandalorian;
  ```

- Did you mean "star_wars"? 

- context specific

- string slicing

- list and struct

- ```
  SELECT
      ['A-Wing', 'B-Wing', 'X-Wing', 'Y-Wing'] AS starfighter_list,
      {name: 'Star Destroyer', common_misconceptions: 'Can''t in fact destroy a star'} AS star_destroyer_facts;
  ```

- list slicing

- dot notation

- function aliases other databases

- auto inc dup. column names

- implicit type casts : int, varchar, bigint

- autres

  - INTERVAL
  - SAMPLE
  - QUALIFY & HAVING (???)
  - DISTINCT ON

  

## Tuto MotherDuck

https://motherduck.com/blog/duckdb-tutorial-for-beginners/

FROM

```
CREATE TABLE ducks AS SELECT 3 AS age, 'mandarin' AS breed;
FROM ducks;
```

```
duckdb.exe mydb.db
```

ATTACH

```
ATTACH DATABASE '/path/to/your/database.db' AS mydb;
```

?? transactional **ACID** compliance and stores data in a compressed columnar format for optimal aggregation performance.

> transactional guarantees (ACID properties) cf https://marclamberti.com/blog/duckdb-getting-started-for-beginners/

Télécharger https://www.kaggle.com/datasets/prasertk/netflix-daily-top-10-in-us

```
SELECT * FROM read_csv_auto('netflix daily top 10.csv');
```

CREATE TABLE

```
CREATE TABLE netflix_top10 AS SELECT * FROM read_csv_auto('netflix daily top 10.csv');
```

```
select * from netflix_top10;
```

COPY

```
COPY 'netflix daily top 10.csv' TO 'netflix.csv' WITH (FORMAT 'CSV', DELIMITER ',');
```

Parquet

```
COPY 'netflix.csv' TO 'netflix.parquet' WITH (FORMAT 'PARQUET');
```

read_parquet

```
SELECT * FROM read_parquet('netflix.parquet');
```

JSON

.mode line

.mode json

```sql
.mode line
select fields[1] from schema.json;
```

.output

```
D .mode markdown
D .output output.md
D select fields[1] from schema.json;
```

Ctrl+C pour quitter

-c

```bat
duckdb -c "SELECT * FROM read_parquet('path/to/your/file.parquet');"
```

automatically convert CSV to parquet

Config

https://duckdb.org/docs/configuration/overview.html

Threads

memory limit

```
SELECT *
FROM duckdb_settings()
```

```
RESET memory_limit;
```

A voir le reste

unsigned

>  allow_unsigned_extensions` flag to `True`, or use the `-unsigned

```
$ duckdb -unsigned
```

httpfs

```
LOAD httpfs;
-- Minimum configuration for loading S3 dataset if the bucket is public
SET s3_region='us-east-1';
```

```
CREATE TABLE netflix AS SELECT * FROM read_parquet('s3://duckdb-md-dataset-121/netflix_daily_top_10.parquet');
FROM netflix;
```

Les meilleurs scores :

- GROUP BY
- ORDER BY desc

```
D SELECT Title, max("Days In Top 10") from netflix
┬À where Type='Movie'
┬À GROUP BY Title
┬À ORDER BY max("Days In Top 10") desc
┬À limit 5;
```

COPY

```
D COPY (
┬À SELECT Title, max("Days In Top 10") from netflix
┬À where Type='TV Show'
┬À GROUP BY Title
┬À ORDER BY max("Days In Top 10") desc
┬À limit 5
┬À ) TO 'output.csv' (HEADER, DELIMITER ',');
```

Guillemets importantes

## Tuto marclamberti

https://marclamberti.com/blog/duckdb-getting-started-for-beginners/

- ***OLAP DBMS*** 
-  instead of using a relational database management system (RDBMS), you use Pandas and Numpy.
- **Setting up** a database and loading data in it can be a painful, slow, and frustrating experience
- DuckDB is highly optimized for analytical query workloads (OLAP). Because it is **columnar**-oriented DB (along with other optimizations), complex-long-running queries to aggregate, join or read data become blazingly fast
- **Pandas** cannot leverage CPU cores to parallelize computations, making them slow to complete. It operates entirely in memory leading to out-of-memory errors if the dataset is too big.
- Postgres API
- DuckDB has a Python Client and shines when mixed with Arrow and Parquet.
- Terabytes : By looking at AWS offerings, you can have an instance with up to 1,952GB of memory and 128 vCPUs.
- not a multi-tenant database multiple teams : difficult
- Airflow, S3, Parquet, and dbt
- While SQLite is a general-purpose database engine, it is primarily designed for fast online transaction processing (**OLTP**).
  - **columnar** storage, **vectorized query** processing, and multi-version concurrency control optimized for ETL operations
  - SQL queries act on individual **rows** rather than **batches** of rows, as in vectorized query processing, giving poorer performances for OLAP queries.
  - Différences
    - DuckDB is optimized for queries that apply aggregate calculations across large numbers of rows
    - whereas SQLite is optimized for fast scanning and lookup for individual rows of data. If you need to perform analytical queries, go with DuckDB; otherwise, use SQLite.

## Tuto Geotribu

https://geotribu.fr/articles/2023/2023-12-19_duckdb-donnees-spatiales/#importer-les-donnees-dans-la-base

```
con.sql("CREATE TABLE airports AS FROM read_csv_auto('https://davidmegginson.github.io/ourairports-data/airports.csv', HEADER=True, DELIM=',') ;")
con.sql("ALTER TABLE airports ADD COLUMN the_geom GEOMETRY ;")
con.sql("UPDATE airports SET the_geom = ST_POINT(longitude_deg, latitude_deg) ;")
```

QDuckDB

## Tutos Icem7

https://www.icem7.fr/pedagogie/3-explorations-bluffantes-avec-duckdb-butiner-des-api-json-2-3/

## Parquet

compression et codage

https://geotribu.fr/articles/2023/2023-12-19_duckdb-donnees-spatiales/#les-colonnes-de-geometries-et-la-non-prise-en-charge-des-projections

## Python

https://marclamberti.com/blog/duckdb-getting-started-for-beginners/

## Test création de base de données

FROM

Création de la base de données

```
duckdb.exe mydb.db
```

insertion

```
CREATE TABLE ducks AS SELECT 3 AS age, 'mandarin' AS breed;
```

```
FROM ducks;
```

Quitter (Ctrl + C)

```
duckdb.exe
```

```
ATTACH DATABASE 'mydb.db' AS mydb;
```

quotes importantes

```
from db.ducks
```

SHOW

```
show tables;
show all tables;
```

DESCRIBE

```
describe ducks;
DESCRIBE SELECT * FROM tbl;
CREATE TABLE tbl_description AS SELECT * FROM (DESCRIBE tbl);
DESCRIBE TABLE 'https://blobs.duckdb.org/data/Star_Trek-Season_1.csv';
```

## CSV

```
SELECT * FROM 'test.csv';
SELECT * FROM read_csv('test.csv', header = false);
COPY tbl FROM 'test.csv' (HEADER false);
```

Compressed

```
SELECT * FROM 'test.csv.gz';
```

Types de colonnes

```
SELECT * FROM read_csv('flights.csv',
    delim = '|',
    header = true,
    columns = {
        'FlightDate': 'DATE',
        'UniqueCarrier': 'VARCHAR',
        'OriginCityName': 'VARCHAR',
        'DestCityName': 'VARCHAR'
    });
```



## Questions

#### 1

```
create view v as (
	SELECT
       *
    FROM read_parquet('s3://overturemaps-us-west-2/release/2024-06-13-beta.0/theme=places/type=*/*', filename=true, hive_partitioning=1)
);

select websites from v where websites is not null limit 5;
```

Comment avoir la longueur ?

## Vidéos

### Mauvière

https://www.youtube.com/watch?v=ajo0VBXT6ho

```
FROM http://xxx LIMIT 10

FROM http://xxx where xxx

sum()

DBeaver

GROUP BY GROUPING SETS https://youtu.be/ajo0VBXT6ho?si=ntAh1gQWYqq4pGRO&t=775

FROM read_json_auto(http//apijson)

LEFT JOIN

replace(ifnull())

SIRENE

st_geomfromwkb

count(*)

st_distance

CREATE TABLE meteo31 as 
FROM 'https://...'

strptime(xxx, xxx)

current_date

210 Mo

37:14 : points forts

GROUP BY ALL (devine tout seul)

select * from exclude

select columns(c -> ILIKE '%pop%')
select REG, sump(columns(c -> ILIKE '%pop%')) GROUP BY REG

suite de MonetDB

https://youtu.be/ajo0VBXT6ho?si=gqfDuPJSzFjN7fKt&t=3029
compression des colonnes

que la partie pertinente

data_partition > REGION=76

filter push down

row groups

tri
ordre de tri
range requests
streaming

optimisation pour lecture seule
```

## Requêtes

### 1 (overturemaps)

```
SELECT 
names,
JSON(names) as names,
sources,
JSON(sources) as sources,
ST_GeomFromWKB(geometry) as geometry
FROM
read_parquet('s3://overturemaps-us-west-2/release/2024-04-16-beta.0/theme=buildings/type=*/*', hive_partitioning=1)
LIMIT 5;
```

struct et json type

```
┌──────────────────────┬──────────────────────┬──────────────────────┬──────────────────────┬──────────────────────────────────────────────────────────────────────────────┐
│        names         │        names         │       sources        │       sources        │                                   geometry                                   │
│ struct("primary" v.  │         json         │ struct(property va.  │         json         │                                   geometry                                   │
├──────────────────────┼──────────────────────┼──────────────────────┼──────────────────────┼──────────────────────────────────────────────────────────────────────────────┤
│ {'primary': Marlen.  │ {"primary":"Marlen.  │ [{'property': , 'd.  │ [{"property":"","d.  │ POLYGON ((-167.3999539 -83.6500135, -167.3999133 -83.6500116, -167.3998804.  │
│                      │                      │ [{'property': , 'd.  │ [{"property":"","d.  │ POLYGON ((-136.8028948 -74.7669439, -136.8030749 -74.7670273, -136.8020661.  │
│                      │                      │ [{'property': , 'd.  │ [{"property":"","d.  │ POLYGON ((-136.8033409 -74.7667304, -136.802516 -74.7668605, -136.8023483 .  │
│                      │                      │ [{'property': , 'd.  │ [{"property":"","d.  │ POLYGON ((-136.8030898 -74.7660076, -136.8025614 -74.7659821, -136.8026186.  │
│                      │                      │ [{'property': , 'd.  │ [{"property":"","d.  │ POLYGON ((-136.8020881 -74.7661436, -136.8014847 -74.7660121, -136.8017343.  │
└──────────────────────┴──────────────────────┴──────────────────────┴──────────────────────┴──────────────────────────────────────────────────────────────────────────────┘
```

## Masterclass GIDI

### Sommaire

- [x] domicile travail x API DV3F
- [ ] artificialisation et colonnes (OFF)
- [x] overturemaps : places
- [ ] cartofriches (OFF)
- [ ] carroyage (OFF)
- [x] isochrones IGN (OFF)
- [ ] BANO x isochrones
- [ ] Arrêts https://prochainement.transport.data.gouv.fr/swaggerui#/gtfs/API.GTFSStopsController.index

### Plan de la session

Scripts associés dans dossier scripts

1. Installation DuckDB
2. Domicile travail 1
3. Installation DuckDB
4. Domicile travail 1
5. OvertureMaps et API
6. Parkings et partitioning
7. Artificialisation (PIVOT)

### Parquet de 1Go

```
duckdb
```

On installe la cartouche spatiale

```
INSTALL spatial;
LOAD spatial;
```

Exploration

```
create view h as (from 'hydrographie-cours-deau.parquet');
select st_x(geo_point_2d) from h limit 10; # ERREUR
select ST_GeomFromWKB(geo_point_2d) from h limit 10;
select st_x(ST_GeomFromWKB(geo_point_2d)) as x from h limit 10;
select st_x(ST_GeomFromWKB(geo_point_2d)) as x from h where x >= 5 limit 10;

with h2 as (select * from h limit 10)
select * from h2;
```

Export

```
COPY h2 TO 'test.geojson';
COPY h2 TO 'test.gpkg';
```

### Cartofriches

```
from 'https://static.data.gouv.fr/resources/sites-references-dans-cartofriches/20240405-113845/friches-standard2024.csv';
from 'https://github.com/CEREMA/cartofriches/raw/main/shinyapp/data/friches/friches_surfaces2024_04_05.gpkg';
```

### PG

Se connecter

```
INSTALL postgres;
LOAD postgres;
LOAD spatial;
ATTACH 'dbname=sig user=agil password=agil host=172.23.210.16' AS db (TYPE POSTGRES, READ_ONLY);
```

Lister les tables

```
create table t as (select * from (show all tables));
describe t;
```

On liste les tables des fichiers fonciers

```
select distinct schema from t where schema like 'ff%';
select name from t where schema='ff2023_dep';
```

Accéder à la couche carroyage

```
create table carr as (select * from db.ff2023_dep.d01_ffta_2023_carroyage_etrs89_laea_100m);
describe carr;
```

Accéder à la couche communes PG

```
create table c as (select code_insee, code_siren, pk, ST_GeomFromHEXWKB(geom) from db.adm.commune limit 10);
select * from c;
alter table c rename 'ST_GeomFromHEXWKB(geom)' to 'geom';
select * from c;
```

### API DVF

```
with a as (select JSON(results) r from read_json_auto('https://apidf-preprod.cerema.fr/indicateurs/dv3f/communes/annuel/13100/?annee=2020'))
```

### Entreprises

```
FROM read_json_auto('https://recherche-entreprises.api.gouv.fr/near_point?lat=43.69875&long=1.46158&radius=0.3');
```

### DBeaver

- Installer DBeaver
- Ouvrir DBeaver
- Base de données > Nouvelle connexion > DuckDB
- `:memory:`
- Clic droit memory > Editeur SQL
- Taper les commandes
- Ctrl + Enter

### Parkings

CSV

```
from read_csv('data/marseille/*.csv', filename = True, union_by_name = True);
```

Conversion en masse

```
copy (from 'data/marseille/1.gpkg') to 'data/marseille/1.parquet';
copy (from 'data/marseille/2.gpkg') to 'data/marseille/2.parquet';
```

```
from 'data/marseille/*.parquet';
create table agg as (from 'data/marseille/*.parquet');
```

## Vu

```
COPY tbl FROM 'test.json'; -- table existante
```

- format
- least
- greatest
- substring
- case when
- `cond ? a : b`
- dot commands
- select * EXCLUDE
- UNPIVOT

## Lectures

.read select_example.sql

 

==

3 explorations bluffantes

friendly sql

even friendlier sql

 

==

https://duckdb.org/2023/08/23/even-friendlier-sql.html

SELECT 

   ('Make it so')

​     .upper()

​     .string_split(' ')

​     .list_aggr('string_agg','.')

​     .concat('.') AS im_not_messing_around_number_one;

 

==

COLUMNS Lambda

SELECT

  episode_num,

  COLUMNS(col -> col LIKE '%warp%')

FROM trek_facts

WHERE

  COLUMNS(col -> col LIKE '%warp%') >= 2;

==

REPLACE

SELECT

  max(COLUMNS(* REPLACE aired_date::timestamp AS aired_date))

FROM trek_facts;

==

COLUMNS dans WHERE

SELECT

  episode_num,

  COLUMNS('.*warp.*')

FROM trek_facts

WHERE

  COLUMNS('.*warp.*') >= 2;

==

ALIASES

SELECT 

   'These are the voyages of the starship Enterprise...' AS intro,

   instr(intro, 'starship') AS starship_loc,

   substr(intro, starship_loc + len('starship') + 1) AS trimmed_intro;

==

LIST LAMBDA

SELECT 

   (['Enterprise NCC-1701', 'Voyager NCC-74656', 'Discovery NCC-1031'])

​     .list_transform(x -> x.string_split(' ')[1]) AS short_name;

==

LIST COMPREHENSIONS (FOR)

SELECT 

   [x.string_split(' ')[1] 

   FOR x IN ['Enterprise NCC-1701', 'Voyager NCC-74656', 'Discovery NCC-1031'] 

   IF x.contains('1701')] AS ready_to_boldly_go;

==

EXPLODING STRUCT

WITH damage_report AS (

   SELECT {'gold_casualties':5, 'blue_casualties':15, 'red_casualties': 10000} AS casualties

) 

FROM damage_report

SELECT 

   casualties.*;

==

SINGLE COLUMN STRUCT

WITH officers AS (

   SELECT 'Captain' AS rank, 'Jean-Luc Picard' AS name 

   UNION ALL 

   SELECT 'Lieutenant Commander', 'Data'

) 

FROM officers 

SELECT officers;

==

voir SUMMARIZE

==

https://duckdb.org/2022/05/04/friendlier-sql.html

REPLACE

SELECT 

  \* REPLACE (movie_count+3 AS movie_count, show_count*1000 AS show_count)

FROM star_wars_owned_by_disney;

 

GROUP BY ALL, ORDER BY ALL

 

case insensitivity

 

friendly error messages

 

string slicing, struct creation

struct dot notation

 

trailing commas

 

sqlite and pg function aliases

SELECT

  'Use the Force, Luke'[:13] AS sliced_quote_1,

  substr('I am your father', 1, 4) AS sliced_quote_2,

  substring('Obi-Wan Kenobi, you''re my only hope', 17, 100) AS sliced_quote_3;

 

auto dup column names

 

==

Voir QUALIFY

OVER

GROUPING SETS

==

datawrapper

==

## SELECT

Par index

```
SELECT #1, #3 FROM tbl;
```



## Metadata

https://news.ycombinator.com/item?id=38271082

```
SELECT 
        * 
    FROM 
        parquet_metadata('https://huggingface.co/datasets/vivym/midjourney-messages/resolve/main/data/000000.parquet');
```

## Requêtes IGN

https://wxs.ign.fr/calcul/geoportail/isochrone/rest/1.0.0/isochrone?resource=bdtopo-pgr&profile=car&costType=time&costValue=100&direction=departure&point=2.4297637939453125,48.81427938511683&constraints=&geometryFormat=geojson

https://wxs.ign.fr/calcul/geoportail/itineraire/rest/1.0.0/route?resource=bdtopo-pgr&profile=pedestrian&optimization=fastest&start=2.3017215728759766,48.81876120037664&end=2.324380874633789,48.8287067867079&intermediates=&constraints=&geometryFormat=geojson&getSteps=false&getBbox=true&waysAttributes=cleabs

http://wx.ign.fr/calcul/geoportail/isochrone/rest/1.0.0/isochrone?resource=bdtopo-pgr&profile=car&costType=time&costValue=100&direction=departure&point=2.4297637939453125,48.81427938511683&constraints=&geometryFormat=geojson

## .read

```
.read select_example.sql
```

## Requêtes Shell

https://shell.duckdb.org/#queries=v0,%20%20-READ%0D%0Aload-spatial~%0D%0Acreate-or-replace-table-a-as-(from-st_read('https%3A%2F%2Fstatic.data.gouv.fr%2Fresources%2Felections%20legislatives%20des%2030%20juin%20et%207%20juillet%202024%20liste%20des%20candidats%20du%202nd%20tour%2F20240703%20133918%2Flegislatives%202024%20candidatures%20france%20entiere%20tour%202%202024%2007%2003%2012h18.xlsx'))~%0D%0Afrom-a-limit-5~,%20%20-PROFESSIONS-DES-CANDIDATS-POUR-RN%2C-UG-et-ENS%0D%0Awith-b-as-(%0D%0A%09select-%0D%0A%09%09%22Profession%22%2C-%0D%0A%09%09%22Code-nuance%22-as-parti%2C-%0D%0A%09%09count(*)-nb-%0D%0A%09from-a-%0D%0A%09where-parti-IN-('RN'%2C-'UG'%2C-'ENS')-%0D%0A%09group-by-(%22Profession%22%2C-parti)-%0D%0A%09order-by-parti%2C-nb-desc%0D%0A)%2C%0D%0Ac-as-(PIVOT-b-ON-parti-USING-first(nb))%0D%0Aselect-%0D%0A%09*-replace-(%0D%0A%09%09regexp_replace(%22Profession%22%2C-'%5C(%5B0%209%5D%7B2%7D%5C)-%20-'%2C-'')-as-%22Profession%22%2C-%0D%0A%09%09ifnull(ENS%2C-0)-as-ENS%2C-%0D%0A%09%09ifnull(RN%2C-0)-as-RN%2C-%0D%0A%09%09ifnull(UG%2C-0)-as-UG%0D%0A%09)-%0D%0Afrom-c-order-by-%22Profession%22~



https://shell.duckdb.org/#queries=v0,%20%20-READ%0D%0Aload-spatial~%0D%0Acreate-or-replace-table-a-as-(from-st_read('https%3A%2F%2Fstatic.data.gouv.fr%2Fresources%2Felections%20legislatives%20des%2030%20juin%20et%207%20juillet%202024%20liste%20des%20candidats%20du%202nd%20tour%2F20240703%20133918%2Flegislatives%202024%20candidatures%20france%20entiere%20tour%202%202024%2007%2003%2012h18.xlsx'))~%0D%0Afrom-a-limit-5~%0D%0A,%20%20-NB-ET-PROPORTION-DE-CANDIDATES-FEMMES-PAR-PARTIS-TRIES-PAR-PROPORTION%0D%0Awith-b-as-(%0D%0Aselect-%0D%0A%09%22Sexe-du-candidat%22%2C-%0D%0A%09%22Code-nuance%22%2C-%0D%0A%09count(*)-as-nb_f-%2C%0D%0A%09sum(nb_f)-over-(partition-by-%22Code-nuance%22)-as-nb_parti%2C%0D%0A%09round(nb_f-%2F-nb_parti-*-100)-as-pc%0D%0Afrom-a-%0D%0Agroup-by-(%22Sexe-du-candidat%22%2C-%22Code-nuance%22)-%0D%0Aorder-by-(%22Code-nuance%22%2C-%22Sexe-du-candidat%22)-desc)%0D%0Aselect-%0D%0A%09*%2C%0D%0A%09mean(pc)-OVER()-as-pc_moyen%0D%0Afrom-b%0D%0Awhere-%22Sexe-du-candidat%22%3D'F'-%0D%0Aorder-by-pc-desc~



## APIs

https://wxs.ign.fr/calcul/geoportail/isochrone/rest/1.0.0/isochrone?resource=bdtopo-pgr&profile=car&costType=time&costValue=100&direction=departure&point=2.4297637939453125,48.81427938511683&constraints=&geometryFormat=geojson



https://wxs.ign.fr/calcul/geoportail/itineraire/rest/1.0.0/isochrone?start=2.337306%2C48.849319&end=2.337306%2C48.849319&resource=bdtopo-osrm&costValue=300&costType=time&profile=pedestrian&direction=departure&constraints=&geometryFormat=geojson&distanceUnit=meter&timeUnit=second&crs=EPSG%3A4326
