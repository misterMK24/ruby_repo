class HealthCheck_Import

  def initialize
    @@tgk_dir = 'C:\\Трансгаз Казань\\Аудит_2018\\ЗСПД'
    @@result_dir = 'C:\\_ruby'
    print "Enter necessary command: "
    @@need_command = gets.chomp
  end

  def get_dir
    Dir.chdir(@@tgk_dir)
    dirs = Dir.glob("[Ff]w*")
    return dirs
  end

  def to_file(str, uname, filename)
    File.open(filename.to_s, "a+") do |result|
      result.syswrite(uname + "\n")
      str.each do |str_do|
        result.syswrite(str_do)
      end
    end
    return
  end

  def dir_working()               #переходим в директорию каждого шлюза и проверяем наличие файла HealthCheck
    dirs_gw = self.get_dir
    dirs_gw.each do |gw_dir|
      Dir.chdir(@@tgk_dir + '\\' + gw_dir)
      current_dir = Dir.pwd
      is_cluster = Dir.glob("[Ff]w[-_]*[^tar]")
      case true
      when not(Dir.glob("CPaudit_HealthCheck.txt").empty?)
        parsing_file(gw_dir)
      when not(is_cluster.empty?)
        is_cluster.each do |node|
          Dir.chdir(@@tgk_dir + '\\' + gw_dir + '\\' + node)
          self.parsing_file(gw_dir)
        end
      end
    end
  end

  def parsing_file(name_gw)
    name_file = "#{@@result_dir}\\#{@@need_command}.txt"
    f = File.new("CPaudit_HealthCheck.txt", "r")
    index = 0
    res_str_file = Array.new

    f.each do |str_file|
      if (/={3}\s#{@@need_command}/ === str_file) or (index == 1)
        index = 1
        if (/={3}\s.*\s={3}/ === str_file) && !(/#{@@need_command}/ =~ str_file)
          break
        end
        res_str_file.push(str_file)
      end
    end
    self.to_file(res_str_file, name_gw, name_file)
    return res_str_file
  end

end

neww = HealthCheck_Import.new
neww.dir_working
