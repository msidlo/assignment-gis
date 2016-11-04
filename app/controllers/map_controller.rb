class MapController < ApplicationController

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

  def region

    connection = ActiveRecord::Base.connection
    @query = "select ST_AsGeoJSON(ST_Transform(way,4326)) as region from planet_osm_polygon
              where name = 'Trenčiansky kraj'"
    @res = connection.exec_query(@query)

    respond_to do |format|
      format.json { render json: @res[0]["region"] }
    end

  end

end