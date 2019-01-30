class CPinfo
  def initialize(filename)
    @filename = filename
  end

  def file_open
    File.new("/home/asd/files/cpinfo_test") do |file|
      # some method for find out the necessary information
    end
  end

  def topology_cluster
    # schema for searching interfaces from topology - cluster and physical i-faces
  end
end