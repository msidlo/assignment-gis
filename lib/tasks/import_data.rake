task import_data: :environment do
  Datum.import_data(csv(:mzda),:mzda)
  Datum.import_data(csv(:nezamestnanost),:nezamestnanost)
  Datum.import_data(csv(:population_2015),:populacia)
  Datum.import_data(csv(:umrtia),:umrtia)
end

def csv(table)
  File.join(Rails.root, 'app', 'assets', 'files', "#{table}.csv")
end