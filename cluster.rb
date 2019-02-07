require 'roo'       # working with excel files


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
    some_str_tmp = whole_file.scan(/:ClassName[\s]{1}[(]{1}gateway_cluster[)]{1}[\S\s]+?:edges/)
    some_str_tmp = some_str_tmp[0].scan(/:cluster_members[\S\s]+?:edges/)
    some_str_tmp = some_str_tmp[0].scan(/:Name[\s]{1}[(][\S\s]+?[)]/)
    some_str_tmp.each_index do |index|
      some_str_tmp[index].sub!(/:Name[\s]{1}[(]/, "").sub!(")", "")
    end    
    return some_str_tmp # Array
  
  end

  def cl_interfaces

    final_cl_array = Array.new
    some_str = Array.new
    whole_file = self.read_file
    some_str_tmp = whole_file.scan(/:cluster_members[\S\s]+?:masters/) # 
    some_str_tmp = some_str_tmp[0].scan(/:cluster_interface[\S\s]+?:officialname[\s]{1}[(][\S\s]+?[)]/)
    some_str_tmp.each_with_index do |iface, i|
      some_str << iface.scan(/:officialname[\S\s]+?[)]{1}/)[0].sub!(/:officialname[\s]{1}[(]/, "").sub!(/[)]{1}/, "") + "\s\s"
      some_str[i] << iface.match(/:ipaddr[\S\s]+?[)]{1}/)[0].sub!(/:ipaddr[\s]{1}[(]/, "").sub!(/[)]{1}/, "") + "\s\s"
      some_str[i] << iface.scan(/:netmask[\S\s]+?[)]{1}/)[0].sub!(/:netmask[\s]{1}[(]/, "").sub!(/[)]{1}/, "")
      # puts "#{some_str}"
      final_cl_array << some_str[i].split(" ")
      # some_str.clear      
      # puts "#{some_str}"
      # puts "#{iface.scan(/:officialname[\S\s]+?[)]{1}/)[0].sub!(/:officialname[\s]{1}[(]/, "").sub!(/[)]{1}/, "")}"
      # puts "#{iface.match(/:ipaddr[\S\s]+?[)]{1}/)[0]}"
      # puts "#{iface.scan(/:netmask[\S\s]+?[)]{1}/)[0]} \n\n"
    end
    # puts "#{final_cl_array}"
    # puts "#{some_str_tmp}"
  end

  def to_file(some_str)

    File.open("C:\\_ruby\\results.txt", "a") do |f|
      some_str.each do |line|
        f.write("#{line} \n")
      end
    end

  end

  def cluster
    # self.to_file(self.cl_name)
    self.cl_interfaces

    # puts "#{self.cl_name[0]} \n"


=begin
    self.cl_interfaces.each do |str|
      puts "#{str}"
    end
    puts "#{self.cl_interfaces}"
    
    File.open(@filename, "r") do |file|
      index, index2, index3 = 0, 0
      # index, index2 = nil, nil
      whole_file = file.read
      # puts "#{self.cl_name}"
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
=end
  end


end


new_cluster = NewClass.new("C:\\_ruby\\cpinfo_cpmgmt-int-srv.txt")
new_cluster.cluster