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
    File.open("C:\\_ruby\\24Sep2018_091148_918_Rule_Base_Analysis\\index.htm", "r") do |f|
      doc = Nokogiri::HTML(f.read)
      File.open('C:\_ruby\results.txt', 'a+') do |file|
        puts doc.css('table.g6 > tbody')[1].text
#        doc.css('table.g6 > tbody > tr').each do |th|
#          print th.at_css('th').text + "\s\s"
#          some_str_1 = th.at_css('td.v')
#          some_str_2 = th.at_xpath('//td[@class="v r"]')

#          unless some_str_1.nil?
#            print some_str_1.text + "\s\s"
#            puts some_str_2.text
#          else
#            print th.at_xpath('//th[@class="h c v"]').text + "\s\s"
#            puts th.at_xpath('//th[@class="h c v r"]').text
#          end
#        end
#       doc.css('table.g6 > tbody > tr').each do |pos|
#         p pos.text
#         puts "ASDASDA \n\n"
#        puts pos.css('th.g7').text 
#        puts pos.css('td.v').text
#        puts pos.xpath('//td[@class="v r"]').text
#       end# doc.xpath('//table[@class="g6"]/tbody/tr')[0]
      end
    end
  

  end

end

parse = ParseHTML.new.get_html