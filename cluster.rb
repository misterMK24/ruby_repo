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
    end
    # puts "#{final_cl_array}"
    # puts "#{some_str_tmp}"
  end

  def local_interfaces

    final_array = Array.new
    some_str = self.cl_name          # got the names of the cluster members
    whole_file = self.read_file
    check_regex = Regexp.new(":[\s]{1}[(]+?#{cl_name[0]}[\S\s]+?:interfaces[\S\s]+?:Machine_weight")
    puts "#{check_regex}"
    some_str_tmp = whole_file.scan(/:[\s]{1}[(]#{self.cl_name[0]}[\S\s]+?:interfaces[\S\s]+?:Machine_weight/)
    puts "#{some_str_tmp[0]}"

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
    # self.cl_interfaces
    self.local_interfaces
    # puts "#{self.cl_name[0]} \n"
  end


end


new_cluster = NewClass.new("C:\\_ruby\\cpinfo_cpmgmt-int-srv.txt")
new_cluster.cluster