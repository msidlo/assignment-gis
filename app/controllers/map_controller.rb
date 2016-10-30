class MapController < ApplicationController

  def index

  end

  def tn

    connection = ActiveRecord::Base.connection
    @query = "select ST_AsGeoJSON(ST_Transform(way,4326)) as region from planet_osm_polygon
              where name = 'Trenčiansky kraj'"
    @res = connection.exec_query(@query)

    respond_to do |format|
      format.json { render json: @res[0]["region"] }
    end

  end

end