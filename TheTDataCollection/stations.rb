require 'nokogiri'
require 'csv'
require 'pry'

doc = Nokogiri::HTML(open('data.html'))
elements = doc.css('table').first.css('tbody').children
output_file = 'stations.csv'
File.delete(output_file) if CSV.read(output_file) != nil
CSV.open(output_file, 'w') do |csv|
  elements.each do |element|
    if element.name == 'tr'
      row = element.children.to_a
      station_name = row[-2].children.text
      csv << [station_name]
    end
  end
end

