require 'active_support/all'


module CloudStack
  module Model
    
    class DiskOffering < Raw
      
      include ServiceOfferingModelHelper::DiskOffering

      cattr_accessor :attr_list
      
      attr_accessor :id, :name, :displaytext, :disksize, :iscustomized,
                    :tags, :storagetype
                    
      @@attr_list=[:id, :name, :displaytext, :disksize, :iscustomized,
                   :tags, :storagetype]

    end
    
    class ServiceOffering < Raw
      include ServiceOfferingModelHelper::ServiceOffering
      cattr_accessor :attr_list
      attr_accessor :id,
                    :name,
                    :displaytext,
                    :cpunumber,
                    :cpuspeed,
                    :memory,
                    :storagetype,
                    :offerha,
                    :limitcpuuse,
                    :issystem,
                    :defaultuse,
                    :networkrate,
                    :tags,
                    :hosttags
      @@attr_list=[:id,
                   :name,
                   :displaytext,
                   :cpunumber,
                   :cpuspeed,
                   :memory,
                   :storagetype,
                   :offerha,
                   :limitcpuuse,
                   :issystem,
                   :defaultuse,
                   :networkrate,
                   :tags,
                   :hosttags]

    end

    class NetworkOffering < Raw
      include ServiceOfferingModelHelper::NetworkOffering
      cattr_accessor :attr_list

      attr_accessor :id, :name, :displaytext, :traffictype, :isdefault,
                    :specifyvlan, :conservemode, :specifyipranges,
                    :availability, :networkrate, :state, :guestiptype,
                    :serviceofferingid

      @@attr_list=[:id, :name, :displaytext, :traffictype, :isdefault,
                   :specifyvlan, :conservemode, :specifyipranges,
                   :availability, :networkrate, :state, :guestiptype,
                   :serviceofferingid]

    end
  end
end
