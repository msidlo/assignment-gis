require 'csv'

module Importable
  extend ActiveSupport::Concern

  module ClassMethods
    def import_data(file,data_type)
      ActiveRecord::Base.transaction do
        puts "Starting import of the file #{file}"
        begin
          csv_text = File.read(file)
          csv = CSV.parse(csv_text, :headers => false)
          head = csv.first
          csv.drop(1).each do |row|

            if head[0].eql? "Region"
              parent = Region.where(:name => row[0]).first
            else
              parent = District.where(:name => row[0]).first
            end

            head.drop(1).each.with_index do |year,i|
              data = Datum.new
              data.description = data_type
              data.year = year
              data.value = row[i+1].to_f
              data.imageable_id = parent.id
              data.imageable_type = head[0]
              data.save!
            end
          end
          puts "File #{file} was successfuly imported!"
        rescue Exception => e
          puts "Error has occured."
          puts e.message
          puts e.backtrace.inspect
        end
      end
    end
  end

end