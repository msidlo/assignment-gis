task import_data: :environment do

  ActiveRecord::Base.transaction do

    # import regions
    connection = ActiveRecord::Base.connection
    @query = "insert into regions(name,way,created_at,updated_at)
              select name,ST_Transform(way,4326),localtimestamp,localtimestamp from planet_osm_polygon
              where admin_level = '4' "
    connection.exec_query(@query)

    # import slovakia
    @query = "insert into regions(name,way,created_at,updated_at)
              select 'Všetky kraje SR',ST_Transform(way,4326),localtimestamp,localtimestamp from planet_osm_polygon
              where admin_level = '2' "
    connection.exec_query(@query)

    # update wrong name
    @query = "insert into districts (name, way,created_at,updated_at)
              select name,ST_Transform(way,4326),localtimestamp,localtimestamp from planet_osm_polygon
              where admin_level = '8'
              and ref like 'SK%'
              and ref is not null"
    connection.exec_query(@query)

    # update wrong name
    @query = "UPDATE districts
              SET name = 'okres Topoľčany'
              WHERE name = 'okres Topolčany'"
    connection.exec_query(@query)

  end

  Datum.import_data(csv(:mzda), :mzda)
  Datum.import_data(csv(:nezamestnanost), :nezamestnanost)
  Datum.import_data(csv(:population_2015), :populacia)
  Datum.import_data(csv(:umrtia), :umrtia)
end

def csv(table)
  File.join(Rails.root, 'app', 'assets', 'files', "#{table}.csv")
end