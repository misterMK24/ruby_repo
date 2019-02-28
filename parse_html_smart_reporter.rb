require 'open-uri'
require 'Nokogiri'
require 'ExcelParse'

class ParseHTML

  def get_html
    some_array = []
    summary_array = []
    table_from_excel = ExcelParse.parse_excel_file.invert        # Hash  Rule_UID -> Rule_Number
    # p table_from_excel["{EE8F36AD-C39F-4F9C-B536-E58BA9BFF4BA}"]
    File.open("C:\\_ruby\\24Sep2018_091148_918_Rule_Base_Analysis\\index.htm", "r") do |f|
      doc = Nokogiri::HTML(f.read)
      doc.css('table.g6').each_with_index do |each_table, i|
# <thead>
        header = each_table.css('thead > tr > td.a2').text
# go through each table
        each_table.css('tbody > tr').each_with_index do |tr, y|
          temp_str = get_RuleID(tr)
          if table_from_excel.has_key?(temp_str)
            some_array[y] = table_from_excel[temp_str].dup + "\s"
          else
            some_array[y] = get_RuleID(tr) + "\s"
          end
          # puts some_array[y].class
          some_array[y] << get_Hits(tr) + "\s"
          some_array[y] << get_Percentage(tr)
        end
        some_array.each_with_index do |position, i|
          summary_array[i] = position.split
        end
        ExcelParse.save_to_excel(header, summary_array)
      end
    end
  end

# get RuleID column from web table
  def get_RuleID(tr)
    # templates
    some_str_1 = tr.at_css('th[@class="g7"]')
    some_str_2 = tr.at_css('th[@class="h c"]')
    some_str_3 = tr.at_css('th[@class="j e"]')
    some_str_4 = tr.at_css('th[@class="l a3"]')
    some_str_5 = tr.at_css('th')
# search for true
    case false
    when some_str_1.nil?
      return some_str_1.text
    when some_str_2.nil?
      return some_str_2.text.sub!(" ", "")   # return Other (xxx) - necessary to strip
    when some_str_3.nil?
      return some_str_3.text.sub!(" ", "")    # return Total (xxx) - necessary to strip 
    when some_str_4.nil? 
      return some_str_4.text
    else
      return some_str_5.text
    end
  end
# get Hits from web table
  def get_Hits(tr)
# templates
    some_str_1 = tr.at_css('td[@class="g7 v"]')
    some_str_2 = tr.at_css('td[@class="g7"]')
    some_str_3 = tr.at_css('td[@class="v"]')
    some_str_4 = tr.at_css('th[@class="h c v"]')
    some_str_5 = tr.at_css('th[@class="j e v"]')
    some_str_6 = tr.at_css('th[@class="l a3 v"]')
# search for true
    case false
    when some_str_1.nil?
      return some_str_1.text
    when some_str_2.nil?
      return some_str_2.text
    when some_str_3.nil?
      return some_str_3.text 
    when some_str_4.nil? 
      return some_str_4.text
    when some_str_5.nil? 
      return some_str_5.text
    else
      return some_str_6.text
    end
  end
# get percentage column from web table
  def get_Percentage(tr)
# templates
    some_str_1 = tr.at_css('td[@class="g7 v r"]')
    some_str_2 = tr.at_css('td[@class="v r"]')
    some_str_3 = tr.at_css('th[@class="h c v r"]')
    some_str_4 = tr.at_css('th[@class="j e v r"]')
    some_str_5 = tr.at_css('th[@class="l a3 v r"]')
# search for true
    case false
    when some_str_1.nil?
      return some_str_1.text
    when some_str_2.nil?
      return some_str_2.text
    when some_str_3.nil?
      return some_str_3.text 
    when some_str_4.nil? 
      return some_str_4.text
    else
      return some_str_5.text
    end
  end
end
# =>   def to_excel_file(header, final_array)
# =>     workbook = RubyXL::Parser.parse('C:\_ruby\some_file.xlsx')
# =>     worksheet = workbook.add_worksheet
# =>     worksheet.add_cell(0, 0, header)
# =>     final_array.each_with_index do |pos, i|
# =>       pos.each_with_index do |pos2, y|
# =>         worksheet.add_cell(i+1, y, pos2)
# =>       end
# =>     end
# =>     workbook.save
# =>   end
# =>   puts "Done"
# => end

parse = ParseHTML.new
parse.get_html
