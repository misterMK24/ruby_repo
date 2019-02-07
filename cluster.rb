class NewClass

  def initialize(filename)
    @filename = filename
  end

  def read_file

   f = File.open(@filename, "r")
   whole_file = f.read
   f.close
   return whole_file

  end

  def cl_name
    
    whole_file = self.read_file
    some_str = Array.new(2)
    cluster_members = whole_file.scan(/:cluster_members[\S\s]+?:edges/)
    names = cluster_members[0].scan(/:Name[\s]{1}[(][\S\s]+?[)]/)
    names.each_index do |index|
      names[index].sub!(/:Name[\s]{1}[(]/, "").sub!(")", "")
      # puts "#{names[index]}"
    end
    return names
  
  end

  def cl_interfaces

    whole_file = self.read_file
    cl_ifs = whole_file.scan(/:cluster_members[\S\s]+?:masters/)
    if_each = cl_ifs[0].match(/:ClassName [(]cluster_interface[)]{1}[\S\s]+?:officialname[\s]{1}[(][\S\s]+?[)]/)

    # puts "#{cl_ifs[0]}"
    # return if_each # cl_ifs

  end

  def cluster

    self.cl_interfaces
=begin
    self.cl_interfaces.each do |str|
      puts "#{str}"
    end
=end
#    puts "#{self.cl_interfaces}"
    
    File.open(@filename, "r") do |file|
      index, index2, index3 = 0, 0
      # index, index2 = nil, nil
      whole_file = file.read
      puts "#{self.cl_name}"
      # some_str3 = some_str2.scan(/:ClassName [(]gateway_cluster[)][\S\s]+?:certificates[\s]{1}[(]{1}/)
      some_str = "" 
      # file.rewind # - go to the begining of the file
      # puts "#{names.map {|item| item.match(/[(][\S\s]+?[)]/)}}"
      file.each_line do |line|
        if line.match(/:ClassName [(]gateway_cluster[)]{1}/)
          index = 1
        elsif index == 1
          case line 
          when /:ip_pool_allocation/
            index2 = 1
            # puts "#{line}"
          when /:multicast_enforcement/
            index2 = 1
            # puts "#{line}"
          when /:Wiznum/
            index2 = 1
          end
          if index2 == 1
            if line.match(/:ipaddr/) || line.match(/:netmask/)
              some_str << line
              index2 = 0
            end
          end
        end
      end
      puts "#{some_str}"
    end

  end

end


new_cluster = NewClass.new("C:\\_ruby\\objects_5_0.C")
new_cluster.cluster