class CPinfo


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

    # schema for searching interfaces from topology - cluster and physical i-faces
  end



instance_1 = CPinfo.new("//home//asd//ruby_theory//cpinfo_chepucks.info")
# instance_1.file_open
instance_1.topology_cluster
# instance_1.file_open
# instance_1.topology_cluster
