class Log_parse

# method for getting the whole <migrate rule> lines from check point log file
  def file_open
    match_result_array = []
    i = 0
    begin
      File.open('/mnt/c/_ruby/log_in_ascii.txt', 'r') do |f|      # C:\_ruby\log_in_ascii.txt
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
    File.open('/mnt/c/_ruby/results.txt', 'w') do |file|                # C:\_ruby\results.txt
      match_result_array.each do |line|
        file.puts(line)
      end
    end
  end

# method to parse each line to get source_ip, dst_ip and service.
  def migrate_rule
    test_array = []
    source_ip_array = []
    dst_ip_array = []
    service_array = []

    File.open('/mnt/c/_ruby/results.txt', 'r') do |file|
      file.each_with_index do |line, i|
        test_array[i] = line.split(";")
        source_ip_array[i] = test_array[i][16]
        dst_ip_array[i] = test_array[i][17]
        service_array[i] = "#{test_array[i][18]} #{test_array[i][19]}"
        puts i
      end
    end

  end



end


ins_log_parse = Log_parse.new.migrate_rule          # file_open