require 'active_support/all'


module CloudStack
  module Model
    
    class DiskOffering
      
      cattr_accessor :attr_list
      
      attr_accessor :id, :name, :displaytext, :disksize, :iscustomized,
                    :tags, :storagetype
                    
      @@attr_list=["id", "name", "displaytext", "disksize", "iscustomized",
                   "tags", "storagetype"]
                   
      def initialize
      end
    end
    
    class ServiceOffering
      cattr_accessor :attr_list
      attr_accessor :id, :name, :displaytext, :cpunumber, :cpuspeed, :memory,
                    :storagetype, :offerha, :limitcpuuse, :tags, :issystem,
                    :defaultuse, :networkrate
      @@attr_list=["id", "name", "displaytext", "cpunumber", "cpuspeed",
                   "memory", "storagetype", "offerha", "limitcpuuse","tags",
                   "issystem", "defaultuse", "networkrate"]


      def initialize
      end
    end
    
  end# End of module module
end# End of cloudstack module