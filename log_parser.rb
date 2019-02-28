class Log_parse

  def file_open
    match_result_array = []
    i = 0
    begin
      File.open('C:\_ruby\log_in_ascii.txt', 'r') do |f|
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
    to_file(match_result_array)
  end

  def to_file(match_result_array)
    File.open('C:\_ruby\results.txt', 'w') do |file|
      match_result_array.each do |line|
        file.write(line)
      end
    end
  end

end


ins_log_parse = Log_parse.new.file_open