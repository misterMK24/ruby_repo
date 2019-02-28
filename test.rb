class CPinfo

  Cluster = Struct.new("Cluster", :ClassName, :name, :cluster_members, :Name, :interfaces)
  # cluster_1 = Cluster.new

  def initialize(filename)
    @filename = filename
  end
=begin
  def file_open
    File.open(@filename, "r") do |file|
      file_cpinfo = file.read
    end
  end
=end

<<<<<<< HEAD
  def topology_cluster
    File.open(@filename, "r") do |file|
      index = nil

      file.each_line do |line|
        if line.include? ":ClassName (gateway_cluster)"
          index = true
        elsif index
          while line.include? ":manual_encdomain"
            if line.include? "ipaddr"
              puts "#{line}"
            else
              next
            end
          end
        else
          next
        end
      end
    end
  end
=======
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
>>>>>>> c5a16da3a5b090c18c8b15f02eb8169bff7445da

    gwname = some_str.match(%r'#_/w+')


  end

end


# //home//asd//ruby_theory//cpinfo_chepucks.info - for Linux
# C:\\_ruby\\cpinfo_chepucks.info - for Windows

<<<<<<< HEAD
instance_1 = CPinfo.new("//home//asd//ruby_theory//cpinfo_chepucks.info")
# instance_1.file_open
instance_1.topology_cluster
=======
instance_1 = CPinfo.new("C:\\_ruby\\cpinfo.txt")
instance_1.file_open
instance_1.find_cluster_names
>>>>>>> c5a16da3a5b090c18c8b15f02eb8169bff7445da
# instance_1.file_open
# instance_1.topology_cluster
