class CPinfo


  def initialize(filename)
    @filename = filename
  end

  def file_open
    @file_opened = File.open(@filename, "r")
  end

  def topology_cluster
    @file_opened.each_line.with_index do |line, index|
      if line.include? "gw_cluster" or index
        index = true
        if line.include? ":HA_mode"
          break
        elsif line.include? ":ClassName"
          puts "cluster name is #{line.scan(/(\w+)/)}"
        end
      end
    end
    @file_opened.close
  end

    # schema for searching interfaces from topology - cluster and physical i-faces
  end



instance_1 = CPinfo.new("//home//asd//ruby_theory//cpinfo_chepucks.info")
instance_1.file_open
instance_1.topology_cluster
# instance_1.file_open
# instance_1.topology_cluster
