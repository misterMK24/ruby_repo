require 'open-uri'
require 'nokogiri'

class ParseHTML

  def initialize #filename)
#    file = ""
#    File.open(filename, "r") do |f|
#      file = f.read
#    end
#    puts file.class
  end

  def get_html
    url = 'https://nicothin.pro/sublime-text/sublime-text-3-hotkeys.html'
    html = open(url)
    doc = Nokogiri::HTML(html)
    puts doc.at_css('.keys-block__list')

  end

end

parse = ParseHTML.new.get_html