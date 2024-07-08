load spatial;

create or replace table t as (
SELECT *
FROM read_parquet('C:\Users\mathieu.rajerison\Desktop\TAFF_MAISON\P_APPRENTISSAGE_MANUELS\2024 06 DuckDB\data\hive\*\*.parquet', hive_partitioning = true, filename = true));

describe t;

from t;

-- KO ST_GeomFromWKB
select ST_GeomFromWKB(geometry) from t;
select ST_GeomFromWKB(geometry) FROM read_parquet('C:\Users\mathieu.rajerison\Desktop\TAFF_MAISON\P_APPRENTISSAGE_MANUELS\2024 06 DuckDB\data\Marseille\1.parquet') 