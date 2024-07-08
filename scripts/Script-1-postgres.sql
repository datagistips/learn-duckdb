-- 3. Postgres

LOAD postgres;
LOAD spatial;
ATTACH 'dbname=sig user=agil password=agil host=172.23.210.16' AS db (TYPE POSTGRES, READ_ONLY);
create table c as (select code_insee, code_siren, pk, ST_GeomFromHEXWKB(geom) from db.adm.commune limit 10);
select * from c;
alter table c rename 'ST_GeomFromHEXWKB(geom)' to 'geom';
select * from c;
select st_transform(geom, 'epsg:2154', 'epsg:4326') as geom_4326 from c;
select st_transform(geom, 'epsg:2154', 'epsg:3857') as geom_3857 from c;