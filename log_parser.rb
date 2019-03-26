require 'RubyXL'
require 'logger'

class Log_parse
  attr_accessor :dir, :input_filename, :output_filename, :result_filename,
                  :src_ip_final_table, :dst_ip_final_table, 
                  :proto_final_table, :service_port_final_table
# method for getting the whole <migrate rule> lines from check point log file
  def initialize
    self.dir = "C:\\_old_PC\\ГП ТГ Казань\\2019\\kszi_logs\\"
    self.output_filename = []
    self.input_filename = 
  [
    '01_02_2019.txt', '05_02_2019.txt', 
    '07_02_2019.txt', '09_02_2019.txt', 
    '11_02_2019.txt', '13_02_2019.txt',
    '15_02_2019.txt', '18_02_2019.txt', 
    '20_02_2019.txt', '21_02_2019.txt', 
    '24_02_2019.txt', '26_02_2019.txt',
    '28_02_2019.txt'
  ]
    self.src_ip_final_table = []
    self.dst_ip_final_table = []
    self.proto_final_table = []
    self.service_port_final_table = []
    @input_filename.each_with_index do |filename, iterator|
      puts @dir
      self.output_filename[iterator] = @dir + 'output_' + filename
    end
  end

  def initial_file_parsing
    match_result_array = []
    @input_filename.each_with_index do |filename, iterator|
      begin
        puts "current filename is: #{filename}"
        File.open(@dir + filename, 'r') do |f|      # /mnt/c/_ruby/log_in_ascii.txt
          i = 0
          f.each do |line|
            check_migrate_rule = line.match(/.*migrate rule.*/)
            if check_migrate_rule
                match_result_array[i] = check_migrate_rule[0]
                i += 1
            end
          end  
        end
        # get_src_dst_proto_port(match_result_array)
        # to_file(match_result_array, iterator)
        match_result_array.clear
        puts "parsing for #{filename} has ended"
      rescue EOFError
      # finish to read file
      end
    end
  end

  def get_src_dst_proto_port
    y = 0
    File.open(@output_filename[0], 'r') do |file|
      file.each_with_index do |each_log, i|
        test_array = each_log.split(",")
        self.src_ip_final_table[i] = test_array[2]
        self.dst_ip_final_table[i] = test_array[3]
        self.proto_final_table[i] = test_array[4]
        if test_array[5].eql?("\n")
          next
        else
          self.service_port_final_table[i] = test_array[5]
          y += 1
        end
      end
    end
    puts @src_ip_final_table.uniq!.sort!
  end
    
  def to_file(match_result_array, iterator)
    if @output_filename[iterator].empty?
      return puts "Check :output_filename variable !!!"
    else
      File.open(@output_filename[iterator], 'a+') do |file|                # /mnt/c/_ruby/results.txt
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

instance_log_parse = Log_parse.new
instance_log_parse.result_filename = 'C:\_old_PC\ГП ТГ Казань\2019\kszi_logs\results.xlsx'
# ins_log_parse.initial_file_parsing
instance_log_parse.get_src_dst_proto_port
