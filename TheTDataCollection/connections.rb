require 'nokogiri'
require 'csv'
require 'pry'

doc = Nokogiri::HTML(open('data.html'))
elements = doc.css('table').last.css('tbody').children
output_file = 'connections.csv'
File.delete(output_file) if CSV.read(output_file) != nil
CSV.open(output_file, 'w') do |csv|
  csv << ["From", "To", "Color", "Minutes"]
  elements.each do |element|
    if element.name == 'tr'
      row = element.children.to_a
      clean_row = row.select { |cell| cell.class == Nokogiri::XML::Element }
      clean_row.shift
      data = clean_row.map { |cell| cell.children.text }
      csv << [data[0], data[1], data[2], data[3]]
    end
  end
end
