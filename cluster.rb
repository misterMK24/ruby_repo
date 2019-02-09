require 'roo'       # working with excel files

class NewClass

  def initialize(filename)
    @filename = filename
  end

  def read_file
    f = File.open(@filename, "r")
    whole_file = f.read
    # puts whole_file.class

    return whole_file.encode!('UTF-8', 'binary', invalid: :replace, undef: :replace, replace: '')
  end

  def cl_name 
    some_str = Array.new
    whole_file = self.read_file
    some_str_tmp = whole_file.scan(/:ClassName[\s]{1}[(]{1}gateway_cluster[)]{1}[\S\s]+?:edges/)
    cluster_names = Array.new(some_str_tmp.length, " ")
    cluster_members = Array.new

    some_str_tmp.each_with_index do |cluster, i|
      cluster = cluster.scan(/:name[\S\s]+?:edges/)[0]
      cluster_name = cluster.match(/:name[\s]{1}[(][\S\s]+?[)]/)[0].sub!(/:name[\s]{1}[(]/, "").sub!(/[)]{1}/, "")
      cluster_members << cluster.scan(/:Name[\s]{1}[()][^int][\S\s]+?[)]{1}/)
      cluster_names[i] = cluster_name
    end

    cluster_members.each do |line|
      line.each do |subline|
        subline.sub!(/:Name[\s]{1}[(]/, "").sub!(/[)]/, "")
      end
    end

    final_array_new = cluster_names.zip(cluster_members).flatten
    puts final_array_new

    return some_str_tmp # Array
  end

  def cl_interfaces
    final_cl_array = Array.new
    
    whole_file = self.read_file
    
    some_str_tmp = whole_file.scan(/:cluster_members[\S\s]+?:masters/).uniq!                                                              # find out each list of cluster interfaces
    some_str = Array.new(some_str_tmp.size)
    some_str_tmp.each_with_index do |iface, i|
      some_str[i] = iface.scan(/:cluster_interface[\S\s]+?:officialname[\s]{1}[(][\S\s]+?[)]/)[0]
    end
#    puts some_str
    some_str_new = Array.new
    some_str.each_with_index do |iface, i|
      some_str_new << iface.scan(/:officialname[\S\s]+?[)]{1}/)[0].sub!(/:officialname[\s]{1}[(]/, "").sub!(/[)]{1}/, "") + "\s\s"
      some_str_new[i] << iface.match(/:ipaddr[\S\s]+?[)]{1}/)[0].sub!(/:ipaddr[\s]{1}[(]/, "").sub!(/[)]{1}/, "") + "\s\s"
      some_str_new[i] << iface.match(/:netmask[\S\s]+?[)]{1}/)[0].sub!(/:netmask[\s]{1}[(]/, "").sub!(/[)]{1}/, "")
      # puts "#{some_str}"
#      final_cl_array << some_str_new[i].split(" ")
    end

    puts some_str_new
    # puts some_str_new
    # puts "#{some_str_tmp}"
  end

  def ifaces_cluster
    some_str = Array.new
    whole_file = self.read_file
    some_array_tmp = whole_file.scan(/:ClassName[\s]{1}[(]{1}gateway_cluster[)]{1}[\S\s]+?:masters/)
    cluster_ifaces = Array.new

    self.get_interfaces_members(some_array_tmp[0])

    some_array_tmp.each_with_index do |cluster, i|
      cluster_ifaces << cluster.scan(/:name[\s]{1}[(][\S]+?[)]{1}/)[0].sub!(/:name[\s]{1}[(]/, "").
                                                                                     sub!(/[)]/, "")
      cluster_ifaces << self.get_interfaces(cluster)
      # cluster_ifaces << self.get_interfaces_members(cluster)

      end
    # puts cluster_ifaces

  end

  def get_interfaces(cluster)
    final_array = Array.new
    some_array_tmp = Array.new

    some_array_tmp = cluster.scan(/:cluster_interface[\S\s]+?:officialname[\s]{1}[(][\S\s]+?[)]/)

    some_array_tmp.each_with_index do |iface, i|
      final_array << iface.scan(/:officialname[\S\s]+?[)]{1}/)[0].sub!(/:officialname[\s]{1}[(]/, "").sub!(/[)]{1}/, "") + "\s"
      final_array[i] << iface.match(/:ipaddr[\S\s]+?[)]{1}/)[0].sub!(/:ipaddr[\s]{1}[(]/, "").sub!(/[)]{1}/, "") + "\s"
      final_array[i] << iface.match(/:netmask[\S\s]+?[)]{1}/)[0].sub!(/:netmask[\s]{1}[(]/, "").sub!(/[)]{1}/, "")
    end

    return final_array
  end

  def get_interfaces_members(cluster)
    cluster_members_names = Array.new
    cluster_members = cluster.scan(/:cluster_members[\S\s]+?:edges/)[0]

    cluster_members.scan(/:Name[\s]{1}[(][\S]+?[)]/).each do |member|
      cluster_members_names << member.sub!(/:Name[\s][(]/, "").sub!(/[)]/, "")
    end

    self.ifaces_for_each_member(cluster_members_names)

  end

  def ifaces_for_each_member(cluster_members_names)
    final_array = Array.new(2, "")
    temp_array = Array.new
    whole_file = self.read_file

    cluster_members_names.each do |member|
      temp_array << whole_file.scan(/:[\s]{1}[(]#{member}\W+interfaces[\S\s]+?:Machine_weight/)[0]
    end

    temp_array.each_with_index do |iface, i|
      temp_array[i] = iface.scan(/:dual_wan[\S\s]+?:officialname[\s]{1}[()][\S\s]+?[)]/)
    end

    temp_array.each do |member|
      member.each_with_index do |iface, i|
        final_array[i] = iface.scan(/:officialname[\S\s]+?[)]{1}/)[0].sub!(/:officialname[\s]{1}[(]/, "").sub!(/[)]{1}/, "") + "\s\s\s"
        #### ДОДУМЫВАТЬ
      end
    end

  end

  def local_interfaces
    cluster_names = Array.new
    some_str_tmp = Array.new(2)
    some_str = self.cl_name          # got the names of the cluster members
    temp_array = Array.new
    some_array = Array.new
    whole_file = self.read_file
    gw_names = self.cl_name
    
    gw_names.each_with_index do |gw, index|
      some_str_tmp[index] = whole_file.scan(/:[\s]{1}[(]#{gw}\W+interfaces[\S\s]+?:Machine_weight/)[0]
    end
    
    some_str_tmp.each do |member|
      temp_array << member.scan(/:dual_wan[\S\s]+?:officialname[\s]{1}[()][\S\s]+?[)]/)
    end


    temp_array.each do |members|
      some_array.clear
      members.each_with_index do |iface, y|
        some_array << iface.scan(/:officialname[\S\s]+?[)]{1}/)[0].sub!(/:officialname[\s]{1}[(]/, "").sub!(/[)]{1}/, "") + "\s\s\s"
        some_array[y] << iface.scan(/:ipaddr[\S\s]+?[)]{1}/)[0].sub!(/:ipaddr[\s]{1}[(]/, "").sub!(/[)]{1}/, "") + "\s\s\s" 
        some_array[y] << iface.scan(/:netmask[\S\s]+?[)]{1}/)[0].sub!(/:netmask[\s]{1}[(]/, "").sub!(/[)]{1}/, "") + "\s\s\s" 
        cluster_names << some_array[y]
     end
   end

    puts cluster_names
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
    self.ifaces_cluster
    # self.cl_name
    # self.local_interfaces
    # puts "#{self.cl_name[0]} \n"
  end


end

new_cluster = NewClass.new("C:\\_ruby\\cpinfo_srv-rspd-mgmt-1") #//home//asd//ruby_theory//cpinfo_chepucks.info")
new_cluster.cluster