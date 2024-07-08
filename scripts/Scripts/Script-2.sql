SELECT st.* FROM (SELECT {'x': 1, 'y': 2, 'z': 3} AS st);

SELECT * FROM (SELECT 'http://api/'||unnest([1,2]) AS st);

SELECT * FROM (SELECT 'https://wxs.ign.fr/calcul/geoportail/itineraire/rest/1.0.0/isochrone?start=2.337306%2C48.849319&end=2.337306%2C48.849319&resource=bdtopo-osrm&costValue=300&costType=time&profile=pedestrian&direction=departure&constraints=&geometryFormat=geojson&distanceUnit=meter&timeUnit=second&crs=EPSG%3A4326&toto='||unnest([1,2]) AS st);

SELECT list(url) urls
FROM (SELECT 'https://wxs.ign.fr/calcul/geoportail/itineraire/rest/1.0.0/isochrone?start=2.337306%2C48.849319&end=2.337306%2C48.849319&resource=bdtopo-osrm&costValue=300&costType=time&profile=pedestrian&direction=departure&constraints=&geometryFormat=geojson&distanceUnit=meter&timeUnit=second&crs=EPSG%3A4326&toto='||unnest([1,2]) as url) as a

select * from read_json_auto(
	SELECT list(url) urls
	FROM (SELECT 'https://wxs.ign.fr/calcul/geoportail/itineraire/rest/1.0.0/isochrone?start=2.337306%2C48.849319&end=2.337306%2C48.849319&resource=bdtopo-osrm&costValue=300&costType=time&profile=pedestrian&direction=departure&constraints=&geometryFormat=geojson&distanceUnit=meter&timeUnit=second&crs=EPSG%3A4326&toto='||unnest([1,2]) as url) as a
);

select * from read_json_auto(
['https://wxs.ign.fr/calcul/geoportail/itineraire/rest/1.0.0/isochrone?start=2.337306%2C48.849319&end=2.337306%2C48.849319&resource=bdtopo-osrm&costValue=300&costType=time&profile=pedestrian&direction=departure&constraints=&geometryFormat=geojson&distanceUnit=meter&timeUnit=second&crs=EPSG%3A4326',
'https://wxs.ign.fr/calcul/geoportail/itineraire/rest/1.0.0/isochrone?start=2.337306%2C48.849319&end=2.337306%2C48.849319&resource=bdtopo-osrm&costValue=300&costType=time&profile=pedestrian&direction=departure&constraints=&geometryFormat=geojson&distanceUnit=meter&timeUnit=second&crs=EPSG%3A4326']
);

