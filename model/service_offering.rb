require 'active_support/all'


module CloudStack
  module Model
    
    class DiskOffering < Raw
      
      cattr_accessor :attr_list
      
      attr_accessor :id, :name, :displaytext, :disksize, :iscustomized,
                    :tags, :storagetype
                    
      @@attr_list=[:id, :name, :displaytext, :disksize, :iscustomized,
                   :tags, :storagetype]

    end
    
    class ServiceOffering < Raw
      cattr_accessor :attr_list
      attr_accessor :id, :name, :displaytext, :cpunumber, :cpuspeed, :memory,
                    :storagetype, :offerha, :limitcpuuse, :tags, :issystem,
                    :defaultuse, :networkrate
      @@attr_list=[:id, :name, :displaytext, :cpunumber, :cpuspeed, :memory,
                   :storagetype, :offerha, :limitcpuuse, :tags, :issystem,
                   :defaultuse, :networkrate]

    end
    
  end# End of module module
end# End of cloudstack module
