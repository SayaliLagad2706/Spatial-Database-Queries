/*Database used: Postgres+PostGIS Postgres Version: 12.2*/

/* Create extension for PostGIS */
CREATE EXTENSION postgis;

/* Table containing data about each location */
CREATE TABLE Placemarks (
	Place VARCHAR(50),
	Latitude NUMERIC(12, 6),
	Longitude NUMERIC(12, 6)
);

/* Insertion of locations */
INSERT INTO placemarks (place, latitude, longitude) VALUES ('VKC', 34.021389, -118.284000);
INSERT INTO placemarks (place, latitude, longitude) VALUES ('Leavey', 34.021749, -118.282788);
INSERT INTO placemarks (place, latitude, longitude) VALUES ('Doheny', 34.020164, -118.283765);
INSERT INTO placemarks (place, latitude, longitude) VALUES ('Andrus', 34.020077, -118.290718);
INSERT INTO placemarks (place, latitude, longitude) VALUES ('Seaver', 34.019728, -118.288794);
INSERT INTO placemarks (place, latitude, longitude) VALUES ('Lemonade', 34.020660, -118.286138);
INSERT INTO placemarks (place, latitude, longitude) VALUES ('Moreton', 34.019857, -118.285960);
INSERT INTO placemarks (place, latitude, longitude) VALUES ('Galen', 34.022944, -118.287077);
INSERT INTO placemarks (place, latitude, longitude) VALUES ('LawCafe', 34.018760, -118.284414);
INSERT INTO placemarks (place, latitude, longitude) VALUES ('Starbucks', 34.021779, -118.282194);
INSERT INTO placemarks (place, latitude, longitude) VALUES ('PLotB', 34.022877, -118.282698);
INSERT INTO placemarks (place, latitude, longitude) VALUES ('PLotM', 34.023851, -118.285048);
INSERT INTO placemarks (place, latitude, longitude) VALUES ('PLotV', 34.024407, -118.286057);
INSERT INTO placemarks (place, latitude, longitude) VALUES ('PLotL', 34.025270, -118.288230);
INSERT INTO placemarks (place, latitude, longitude) VALUES ('PLot6', 34.021765, -118.290094);

/* Adding an extra field to create points from the above data */
ALTER TABLE placemarks
ADD COLUMN geom geometry(POINT,4326);
  
/* Updating the new field with appropriate values */
UPDATE placemarks SET geom = ST_SetSRID(ST_MakePoint(longitude,latitude),4326);

/* Extracting points to form a convex hull */
SELECT ST_AsText(ST_ConvexHull(ST_Collect(t.geom))) As the_geom
FROM placemarks as t
  
/* Finding nearest 4 neighbours for the location 'VKC' */
SELECT t1.place, ST_AsText(t1.geom) as coord 
FROM placemarks as t1, placemarks as t2  
WHERE t2.place = 'VKC' AND t1.place <> 'VKC'
ORDER BY ST_Distance(t1.geom,t2.geom)
LIMIT 4;