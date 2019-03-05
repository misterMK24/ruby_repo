require 'RubyXL'
require 'logger'

class Log_parse
  attr_accessor :dir, :input_filename, :output_filename, :result_filename
# method for getting the whole <migrate rule> lines from check point log file
  def initial_file_parsing
    match_result_array = []
    i = 0
    @input_filename.each do |filename|
      begin
        puts "current filename is: #{filename}"
        File.open(@dir + filename, 'r') do |f|      # /mnt/c/_ruby/log_in_ascii.txt
          f.each do |line|
            check_migrate_rule = line.match(/.*migrate rule.*/)
            if check_migrate_rule
                match_result_array[i] = check_migrate_rule[0]
                i += 1
            end
          end  
        end
        to_file(match_result_array)
        match_result_array.clear
        i = 0
        puts "parsing for #{filename} has ended"
      rescue EOFError
      # finish to read file
      end
    end
#    to_file(match_result_array)
 #  begin
 #    if @input_filename.empty?
 #      return puts "Check :input_filename variable !!!"
 #    else
 #      puts "current filename is: #{@input_filename}"
 #      File.open(@input_filename, 'r') do |f|      # /mnt/c/_ruby/log_in_ascii.txt
 #        count = f.size
 #        f.each do |line|
 #          check_migrate_rule = line.match(/.*migrate rule.*/)
 #          if check_migrate_rule
 #              match_result_array[i] = check_migrate_rule[0]
 #              i += 1
 #          end
 #        end  
 #      end
 #      puts "initial parsing has ended"
 #    end
 #  rescue EOFError
 #    # finish to read file
 #  end
 #   to_file(match_result_array) # save result to the file 
  end

# method to parse each line to get source_ip, dst_ip, proto and service.
  def get_src_dst_proto_port
    src_ip = []
    dst_ip = []
    proto = []
    service_port = []
    final_array = []
    y = 0

    File.open(@output_filename, 'r') do |f|
      f.each_with_index do |line, i|
        test_array = line.split(",")                           # line.split(";")
        src_ip[i] = test_array[2]
        dst_ip[i] = test_array[3]
        proto[i] = test_array[4]
        if test_array[5].eql?("\n")
          next
        else
          service_port[y] = test_array[5]
          y += 1
        end
      end
    end
    puts "Done parse operation"
    src_ip.uniq!.sort!
    dst_ip.uniq!.sort!
    proto.uniq!.sort!
    service_port_sorted = service_port.uniq!.sort_by {|element| element.to_i}
    puts "Done uniq! operation"
    to_excel_file(src_ip, dst_ip, proto, service_port_sorted)
  end

  def to_file(match_result_array)
    if @output_filename.empty?
      return puts "Check :output_filename variable !!!"
    else
      File.open(@output_filename, 'a+') do |file|                # /mnt/c/_ruby/results.txt
        match_result_array.each do |line|
          file.write(line)
          file.write("\n")
        end
      end
    end
  end

  def to_excel_file(src_ip, dst_ip, proto, service_port)
    workbook = RubyXL::Parser.parse(@result_filename)
    worksheet = workbook.add_worksheet()
    src_ip.each_with_index do |ip, row|
      worksheet.add_cell(row, 0, ip)
    end
    
    dst_ip.each_with_index do |ip, row|
      worksheet.add_cell(row, 1, ip)
    end

    proto.each_with_index do |proto, row|
      worksheet.add_cell(row, 2, proto)
    end

    service_port.each_with_index do |port, row|
      worksheet.add_cell(row, 3, port)
    end
    workbook.save
    puts "Done xlsx operation"
  end



end

ins_log_parse = Log_parse.new
ins_log_parse.dir = "C:\\_old_PC\\ГП ТГ Казань\\2019\\kszi_logs\\"
ins_log_parse.input_filename = 
[
  '01_02_2019.txt', '05_02_2019.txt', 
  '07_02_2019.txt', '09_02_2019.txt', 
  '11_02_2019.txt', '13_02_2019.txt',
  '15_02_2019.txt', '18_02_2019.txt', 
  '20_02_2019.txt', '21_02_2019.txt', 
  '24_02_2019.txt', '26_02_2019.txt',
  '28_02_2019.txt'
]
ins_log_parse.output_filename = 'C:\_old_PC\ГП ТГ Казань\2019\kszi_logs\output_02_2019.txt'
ins_log_parse.result_filename = 'C:\_old_PC\ГП ТГ Казань\2019\kszi_logs\results.xlsx'
ins_log_parse.initial_file_parsing
# ins_log_parse.get_src_dst_proto_port