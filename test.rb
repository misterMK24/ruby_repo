class CPinfo


  def initialize(filename)
    @filename = filename
  end

  def file_open
    @file_opened = File.open(@filename, "r")
  end

  def topology_cluster
    index = nil
    @file_opened.each_line do |line|
      if line.include? ":ClassName (gateway_cluster)"
        gw_name = line.scan(%r'\(\w+\)')
        puts "#{gw_name[0].gsub(%r'\W', "")}"
        index = true
      elsif index
        if line.include? ":HA_mode"
          break
        elsif line.include? ":name"
          some_str = line.scan(%r'\(\w+\)')
          puts "cluster name is #{some_str[0].gsub(%r'\W', "")}"
        end
      end
    end
    @file_opened.close
  end

    # schema for searching interfaces from topology - cluster and physical i-faces
  end

# //home//asd//ruby_theory//cpinfo_chepucks.info - for Linux
# C:\\_ruby\\cpinfo_chepucks.info - for Windows

instance_1 = CPinfo.new("C:\\_ruby\\cpinfo_chepucks.info")
instance_1.file_open
instance_1.topology_cluster
# instance_1.file_open
# instance_1.topology_cluster
