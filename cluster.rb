require 'rubyXL'       # working with excel files

class NewClass

  def initialize(filename)
    @filename = filename
    @@whole_file = IO.read(@filename)
    @@spreadsheet_file = RubyXL::Parser.parse("C:\\_ruby\\some_file.xlsx")
    @@spreadsheet_file_sheet = @@spreadsheet_file.worksheets[0]
    
  end

# ifaces_cluster - get interfaces for each cluster and cluster members
  def ifaces_cluster
    some_str = Array.new
    cluster_ifaces = Array.new
    cluster_member_ifaces = Array.new

    some_array_tmp = @@whole_file.scan(/:ClassName[\s]{1}[(]{1}gateway_cluster[)]{1}[\S\s]+?:masters/)
    some_array_tmp.each_with_index do |cluster, i|
#     cluster_ifaces << cluster.scan(/:name[\s]{1}[(][\S]+?[)]{1}/)[0].sub!(/:name[\s]{1}[(]/, "").
#                                                                                       sub!(/[)]/, "")
      cluster_ifaces.push(self.get_interfaces(cluster))
      cluster_ifaces << self.get_interfaces_members(cluster)
    end

    self.to_file(cluster_ifaces)
  end

  def get_interfaces(cluster)
    final_array = Array.new
    some_array_tmp = Array.new

    some_array_tmp = cluster.scan(/:cluster_interface[\S\s]+?:officialname[\s]{1}[(][\S\s]+?[)]/)
    final_array.push(cluster.scan(/:name[\s]{1}[(][\S]+?[)]{1}/)[0].sub!(/:name[\s]{1}[(]/, "").
                                                                                        sub!(/[)]/, "") + "\n")
    some_array_tmp.each_with_index do |iface, i|
      final_array.push(iface.scan(/:officialname[\S\s]+?[)]{1}/)[0].sub!(/:officialname[\s]{1}[(]/, "").
                                                                                        sub!(/[)]{1}/, "") + "\s")
      final_array[i+1] << iface.match(/:ipaddr[\S\s]+?[)]{1}/)[0].sub!(/:ipaddr[\s]{1}[(]/, "").sub!(/[)]{1}/, "") + "\s"
      final_array[i+1] << iface.match(/:netmask[\S\s]+?[)]{1}/)[0].sub!(/:netmask[\s]{1}[(]/, "").sub!(/[)]{1}/, "")
    end
    # puts "#{final_array}"
    return final_array
    # Temp
#   @@spreadsheet_file_sheet.insert_cell(0, 0, "")
#   cluster = @@whole_file.scan(/:ClassName[\s]{1}[(]{1}gateway_cluster[)]{1}[\S\s]+?:masters/)[0]
#   some_array_tmp = cluster.scan(/:cluster_interface[\S\s]+?:officialname[\s]{1}[(][\S\s]+?[)]/)
#   @@spreadsheet_file_sheet.insert_cell(0, 0, cluster.scan(/:name[\s]{1}[(][\S]+?[)]{1}/)[0].sub!(/:name[\s]{1}[(]/, "").
#                                                                                  sub!(/[)]/, ""))
#   index1 = 1
#   some_array_tmp.each_with_index do |iface, i|
#     index2 = 0
#     @@spreadsheet_file_sheet.insert_cell(index1, index2, iface.scan(/:officialname[\S\s]+?[)]{1}/)[0].sub!(/:officialname[\s]{1}[(]/, "").
#                                                                                    sub!(/[)]{1}/, ""))
#     @@spreadsheet_file_sheet.insert_cell(index1, index2+1, iface.match(/:ipaddr[\S\s]+?[)]{1}/)[0].sub!(/:ipaddr[\s]{1}[(]/, "").sub!(/[)]{1}/, ""))
#      final_array << iface.match(/:ipaddr[\S\s]+?[)]{1}/)[0].sub!(/:ipaddr[\s]{1}[(]/, "").sub!(/[)]{1}/, "") + "\s"
#     @@spreadsheet_file_sheet.insert_cell(index1, index2+2, iface.match(/:netmask[\S\s]+?[)]{1}/)[0].sub!(/:netmask[\s]{1}[(]/, "").sub!(/[)]{1}/, ""))
#      final_array << iface.match(/:netmask[\S\s]+?[)]{1}/)[0].sub!(/:netmask[\s]{1}[(]/, "").sub!(/[)]{1}/, "")
#     index1 += 1
#   end
#   
#   @@spreadsheet_file.write

# Temp
  end

  def get_interfaces_members(cluster)
    cluster_members_names_final = Array.new
    cluster_members_names = Array.new
    cluster_members = cluster.scan(/:cluster_members[\S\s]+?:edges/)[0]

    cluster_members.scan(/:Name[\s]{1}[(][\S]+?[)]/).each do |member|
      cluster_members_names.push(member.sub!(/:Name[\s][(]/, "").sub!(/[)]/, ""))
    end

    cluster_members_names_final = cluster_members_names.zip(self.get_ifaces_for_each_member(cluster_members_names))
    return cluster_members_names_final

  end

  def get_ifaces_for_each_member(cluster_members_names)
    final_array = [[], []]
    temp_array = []
    cluster_members_names.each do |member|
      temp_array.push(@@whole_file.scan(/:[\s]{1}[(]#{member}\W+interfaces[\S\s]+?:Machine_weight/)[0])
    end
    if temp_array[0].nil?
      cluster_members_names.each_with_index do |member, i|
        temp_array[i] = @@whole_file.scan(/:[\s]{1}[(]#{member}\W+certificates[\S\s]+?:Machine_weight/)[0]
      end
    end
    temp_array.each_with_index do |iface, i|
      temp_array[i] = iface.scan(/:dual_wan[\S\s]+?:officialname[\s]{1}[()][\S\s]+?[)]/)
    end
    temp_array.each_with_index do |member, i|
      member.each_with_index do |iface, y|
        final_array[i][y] = iface.scan(/:officialname[\S\s]+?[)]{1}/)[0].sub!(/:officialname[\s]{1}[(]/, "").
            sub!(/[)]{1}/, "") + "\s"
        final_array[i][y] << iface.scan(/:ipaddr[\S\s]+?[)]{1}/)[0].sub!(/:ipaddr[\s]{1}[(]/, "").sub!(/[)]{1}/, "") + "\s"
        final_array[i][y] << iface.scan(/:netmask[\S\s]+?[)]{1}/)[0].sub!(/:netmask[\s]{1}[(]/, "").sub!(/[)]{1}/, "")
      end
    end

    # puts "#{final_array}"
    return final_array
  end


  def to_file(some_str)
    begin
      File.open("C:\\_ruby\\results.txt", "a") do |f|
        some_str.each do |line|
          if line.kind_of?(Array)
            line.each do |some_str|
              if some_str.kind_of?(Array)
                some_str.each do |str|
                  f.puts(str)
                end
              else
                f.puts(some_str)
              end
            end
          else
            f.puts(line)
          end
        end
      end
    rescue StandardError => e
      puts e.inspect
    end
  end


  def cluster

    # self.get_interfaces
    self.ifaces_cluster
    # self.cl_name
  end


end

new_cluster = NewClass.new("C:\\_ruby\\cpinfo_for_testing.txt") #//home//asd//ruby_theory//cpinfo_chepucks.info")
new_cluster.cluster