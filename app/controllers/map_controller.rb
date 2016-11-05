class MapController < ApplicationController
  # data source http://statdat.statistics.sk/
  def index

  end

  def population_in_districts

    connection = ActiveRecord::Base.connection
    if params[:regions].eql? 'Všetky kraje SR'
      @res = District.select("ST_AsGeoJSON(ST_Union(way)) as result")
               .joins(:data)
               .where("data.description = 'populacia' AND value > ?", params[:population])
    else
      @query = "with region as(
                  SELECT way from regions
                  WHERE name = '#{params[:regions]}'
                )
              select ST_AsGeoJSON(ST_Union(way)) as result from districts dis
              JOIN data dat ON dat.imageable_id = dis.id AND dat.imageable_type = 'District'
              where dat.description = 'populacia' AND value >  '#{params[:population]}'
              AND ST_Contains((select * from region),dis.way)"
      @res = connection.exec_query(@query)
    end
    respond_to do |format|
      format.json { render json: @res[0]["result"] }
    end

  end


  def wage_in_districts

    connection = ActiveRecord::Base.connection
    @query = "with area as(
                  select way from regions where name = '#{params[:regions]}'
              ), wage as (
                    select d.way, d.name from data
                    join districts d on d.id = data.imageable_id
                    where description = 'mzda' and value >= '#{params[:wage]}' and year = '#{params[:year]}'
                    and ST_Contains((select * from area),d.way)
              ), unemployment as (
                    select d.way, d.name from data
                    join districts d on d.id = data.imageable_id
                    where description = 'nezamestnanost' and value < '#{params[:unemployment]}' and year = '#{params[:year]}'
                    and ST_Contains((select * from area),d.way)
              )
              select ST_AsGeoJSON(ST_Union(u.way)) as result from unemployment u, wage w
              where (w.name = u.name) or ST_Touches(u.way,w.way)"
    @res = connection.exec_query(@query)
    respond_to do |format|
      format.json { render json: @res[0]["result"] }
    end

  end


  def deaths_hospitals

    connection = ActiveRecord::Base.connection
    @query = "with region as(
                SELECT way from regions
                WHERE name = '#{params[:regions]}'
              ), areas as (
                select d.name, d.way, dat.value from districts d
                join data dat on dat.imageable_id = d.id
                where dat.description = 'umrtia'
                and dat.value <= '#{params[:deaths_rate]}'
                and year = '#{params[:year]}'
                and ST_Contains((select * from region),d.way)
              ), hospitals as(
                select name, ST_Transform(way,4326) as way from planet_osm_point
                where amenity = 'hospital'
              )
              select ST_AsGeoJSON(a.way) as geom, a.value, round((max(ST_MaxDistance(ST_ExteriorRing(a.way),h.way)*111.195))::numeric,2) as max
              from areas a
              join hospitals h on ST_Contains(a.way,h.way)
              group by geom, a.value"
    @res = connection.exec_query(@query)

    respond_to do |format|
      format.json { render json: @res.to_a }
    end

  end

end