class CPinfo

  Cluster = Struct.new("Cluster", :ClassName, :name, :cluster_members, :Name, :interfaces)
  # cluster_1 = Cluster.new

  def initialize(filename)
    @filename = filename
  end

  def file_open
    @file_opened = File.open(@filename, "r")
  end

  def find_cluster_names
    index = nil
    some_str = ""
    @file_opened.each_line do |line|
      if line.index(/:cluster_members/)
        some_str << line
        index = true
      elsif index
        unless line.index(":interfaces")
          some_str << line
        else
          break
        end
      end
    end
    puts "#{some_str}"
    @file_opened.close

    gwname = some_str.match(%r'#_/w+')


  end

end


# //home//asd//ruby_theory//cpinfo_chepucks.info - for Linux
# C:\\_ruby\\cpinfo_chepucks.info - for Windows

instance_1 = CPinfo.new("C:\\_ruby\\cpinfo.txt")
instance_1.file_open
instance_1.find_cluster_names
# instance_1.file_open
# instance_1.topology_cluster
