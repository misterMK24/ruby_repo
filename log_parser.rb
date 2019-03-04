require 'RubyXL'

class Log_parse
  attr_accessor :input_filename, :output_filename, :result_filename
# method for getting the whole <migrate rule> lines from check point log file
  def initial_file_parsing
    match_result_array = []
    i = 0
    begin
      if @input_filename.empty?
        return puts "Check :input_filename variable !!!"
      else
        puts "current filename is: #{@input_filename}"
        File.open(@input_filename, 'r') do |f|      # /mnt/c/_ruby/log_in_ascii.txt
          count = f.size
          f.each do |line|
            check_migrate_rule = line.match(/.*migrate rule.*/)
            if check_migrate_rule
                match_result_array[i] = check_migrate_rule[0]
                i += 1
            end
          end  
        end
        puts "initial parsing has ended"
      end
    rescue EOFError
      # finish to read file
    end
    to_file(match_result_array) # save result to the file 
  end

# method to parse each line to get source_ip, dst_ip, proto and service.
  def get_src_dst_proto_port
    src_ip = []
    dst_ip = []
    proto = []
    service_port = []
    final_array = []

    File.open(@output_filename, 'r') do |f|
      f.each_with_index do |line, i|
        test_array = line.split(";")
        src_ip[i] = test_array[16]
        dst_ip[i] = test_array[17]
        proto[i] = test_array[18]
        service_port[i] = test_array[19]
      end
    end
    puts "Done parse operation"
    src_ip.uniq!
    dst_ip.uniq!
    proto.uniq!
    service_port.uniq!.sort!
    puts "Done uniq! operation"
    to_excel_file(src_ip, dst_ip, proto, service_port)
  end

  def to_file(match_result_array)
    if @output_filename.empty?
      return puts "Check :output_filename variable !!!"
    else
      File.open(@output_filename, 'w') do |file|                # /mnt/c/_ruby/results.txt
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
ins_log_parse.input_filename = 'C:\_old_PC\ГП ТГ Казань\2019\kszi_logs\01_02_2019.txt'
ins_log_parse.output_filename = 'C:\_old_PC\ГП ТГ Казань\2019\kszi_logs\output_01_02_2019.txt'
ins_log_parse.result_filename = 'C:\_old_PC\ГП ТГ Казань\2019\kszi_logs\results.xlsx'
ins_log_parse.initial_file_parsing
ins_log_parse.get_src_dst_proto_port