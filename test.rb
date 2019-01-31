class CPinfo
  def initialize(filename)
    @filename = filename
  end

  def file_open
    @file_opened = File.new(@filename, "r")
  end

  def topology_cluster
    @file_opened.each_line do |line|
      File.open("C:\\_ruby\\file_output", "a+") do |newfile|
        newfile.write(line)
      end
    end

    @file_opened.close
    # schema for searching interfaces from topology - cluster and physical i-faces
  end
end


instance_1 = CPinfo.new("C:\\_ruby\\cpinfo_chepucks.info")
instance_1.file_open
instance_1.topology_cluster
