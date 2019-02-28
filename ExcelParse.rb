module ExcelParse
  require 'roo'
  require 'RubyXL'
# parse excel file to get table "Rule number -> Rule ID"
  def self.parse_excel_file
    # open file from Marat script and parse it
    workbook = Roo::Spreadsheet.open('C:\_ruby\cpinfo_srv-rspd-mgmt-1_policies.xlsx')
    workbook.default_sheet = workbook.sheets.first
    temp_array = []
    final_array = []
    # go through each row
    0.upto(workbook.last_row-1) do |i|
      temp_str = workbook.cell(i, 1)
      # if current cell is Integer (rule number, not string) - save rule number and rule ID (cell(i, 3), column 1(rule number) and 3(rule id))
      if temp_str.is_a?(Integer)
        temp_array[i] = temp_str.to_s + "\s"
        temp_array[i] << workbook.cell(i, 3)
      end
    end
    # delete all 'nil' membres from array
    temp_array.compact!
    # save temp array into two-dimensional massive
    temp_array.each_with_index do |data, i|
      final_array[i] = data.split
    end
    # return final two-dimensional array
    # puts final_array.to_h["1"]
    return final_array.to_h
  end 

  def self.save_to_excel(header, summary_array)
    workbook = RubyXL::Parser.parse('C:\_ruby\some_excel.xlsx')
    worksheet = workbook.add_worksheet()
    worksheet.add_cell(0, 0, header)
    summary_array.each_with_index do |line, i|
      line.each_with_index do |str, y|
        worksheet.add_cell(i+1, y, str)
      end
    end
    workbook.save
  end
end

