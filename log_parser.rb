class Log_parse

# method for getting the whole <migrate rule> lines from check point log file
  def file_open
    match_result_array = []
    i = 0
    begin
      File.open('C:\_ruby\log_in_ascii.txt', 'r') do |f|      # /mnt/c/_ruby/log_in_ascii.txt
        count = f.size
        f.each do |line|
          check_migrate_rule = line.match(/.*migrate rule.*/)
          if check_migrate_rule
              match_result_array[i] = check_migrate_rule[0]
              i += 1
          end
        end  
      end
    rescue EOFError
      # finish to read file
    end
    to_file(match_result_array) # save result to the file 
  end

  def to_file(match_result_array)
    File.open('C:\_ruby\results_s.txt', 'w') do |file|                # /mnt/c/_ruby/results.txt
      match_result_array.each do |line|
        file.write(line)
        file.write("\n")
      end
    end
  end

# method to parse each line to get source_ip, dst_ip, proto and service.
  def migrate_rule
    test_array = []
    final_array = []
    File.open('C:\_ruby\results.txt', 'r') do |f|
      f.each_with_index do |line, i|
        test_array[0] = line.split(";")
        final_array[i] = test_array[0][16] + "\s"
        final_array[i] << test_array[0][17] + "\s"
        final_array[i] << "#{test_array[0][18]} #{test_array[0][19]}"
      end
    end
    puts "end"
    to_file(final_array)
  end

  def save_to_db
    
    
    
  end

end

ins_log_parse = Log_parse.new
# ins_log_parse.file_open
ins_log_parse.migrate_rule          # file_open