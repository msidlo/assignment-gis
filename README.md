# PDT
School project for database class, which display population, unemployment and average wage, deaths rate and hospitals in districts in Slovak republic (2011-2015).

![Preview](/public/preview.png)

<sub><sub>(each option can be executed within regions or whole country, years 2011-2015, population is only 2015)<sub>:<sub>

3 options:

1. show districts with population higher then set by the user
2. show districts with unemployment less then set by the user and average wage higher then set by the user or at least region next to it has higher average wage
3. show districts with number of deaths in range set by the user and on click, show maximum air distance from hospitals to the edge of district
 
#Data source and how to import it
  * download and import geo data about [Slovakia](http://download.geofabrik.de/europe/slovakia-latest.osm.pbf) to database
      * `osm2pgsql --create --database pdt_project_development slovakia-latest.osm.pbf`
  * run `rails import_data` to import statistic data about regions and districts in Slovakia - data source [STATdat.](http://statdat.statistics.sk/)

#Technology
* Rails version: 5.0.0.1
* ruby version: 2.3.1
* PostgreSQL 9.3.15
* PostGis 2.2

GIS functions used:
  * [ST_Contains](http://postgis.net/docs/manual-1.4/ST_Contains.html)
  * [ST_Union](http://postgis.net/docs/ST_Union.html)
  * [ST_Touches](http://postgis.net/docs/ST_Touches.html)
  * [ST_ExteriorRing](http://postgis.net/docs/ST_ExteriorRing.html)
  * [ST_MaxDistance](http://postgis.net/docs/ST_MaxDistance.html)
  * [ST_AsGeoJSON](http://postgis.net/docs/manual-dev/ST_AsGeoJSON.html)
  * [ST_Transform](http://postgis.net/docs/ST_Transform.html)


<sub><sub>Note:
Model for this project can be done better (in order to use more GIS function, it's done like it is)<sub><sub>
