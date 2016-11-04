class AddGeoToRegionsDistricts < ActiveRecord::Migration[5.0]
  def change
    add_column :regions, :way, "geometry(Geometry,4326)"
    add_column :districts, :way, "geometry(Geometry,4326)"
  end
end
