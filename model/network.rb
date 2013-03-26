module CloudStack
  module Model

    class Network < Raw

      include NetworkModelHelper::Network

      cattr_accessor :attr_list

      attr_accessor :id,
                    :name,
                    :displaytext,
                    :broadcastdomaintype,
                    :traffictype,
                    :zoneid,
                    :zonename,
                    :networkofferingid,
                    :networkofferingname,
                    :networkofferingdisplaytext,
                    :networkofferingavailability,
                    :issystem,
                    :state,
                    :related,
                    :dns1,
                    :type,
                    :acltype,
                    :subdomainaccess,
                    :domainid,
                    :domain,
                    :service,
                    :networkdomain,
                    :physicalnetworkid,
                    :restartrequired,
                    :specifyipranges,
                    :canusefordeploy,
                    :ispersistent,
                    :tags
                    
      @@attr_list = [:id,
                     :name,
                     :displaytext,
                     :broadcastdomaintype,
                     :traffictype,
                     :zoneid,
                     :zonename,
                     :networkofferingid,
                     :networkofferingname,
                     :networkofferingdisplaytext,
                     :networkofferingavailability,
                     :issystem,
                     :state,
                     :related,
                     :dns1,
                     :type,
                     :acltype,
                     :subdomainaccess,
                     :domainid,
                     :domain,
                     :service,
                     :networkdomain,
                     :physicalnetworkid,
                     :restartrequired,
                     :specifyipranges,
                     :canusefordeploy,
                     :ispersistent,
                     :tags]


    end

    class PhysicalNetwork < Raw

      include NetworkModelHelper::PhysicalNetwork

      cattr_accessor :attr_list

      attr_accessor :id, :broadcastdomainrange, :domainid, :isolationmethods,
                    :name, :networkspeed, :state, :tags, :vlan, :zoneid, :network_service_providers,
                    :traffic_types

      @@attr_list=[:id, :broadcastdomainrange, :domainid, :isolationmethods,
                    :name, :networkspeed, :state, :tags, :vlan, :zoneid]


      def initialize(*args)
        @network_service_providers = {}
        @traffic_types = {}
        super(args[0], args[1], args[2])
      end
    end
    
    class TrafficType < Raw
      
      include NetworkModelHelper::TrafficType

      cattr_accessor :attr_list

      attr_accessor :id, :traffictype, :physicalnetworkid

      @@attr_list = [:id, :traffictype, :physicalnetworkid]

    end

    class NetworkServiceProvider < Raw

      include NetworkModelHelper::NetworkServiceProvider

      cattr_accessor :attr_list

      attr_accessor :id, :name, :physicalnetworkid, :state, :servicelist, :virtual_router_elements

      @@attr_list = [:id, :name, :physicalnetworkid, :state, :servicelist] 

      def initialize(*args)
        @virtual_router_elements = {}
        super(args[0], args[1], args[2])
      end
    end


    class VirtualRouterElement < Raw

      include NetworkModelHelper::VirtualRouterElement

      cattr_accessor :attr_list

      attr_accessor :id, :nspid, :enabled, :physicalnetworkid

      @@attr_list = [:id, :nspid, :enabled]


    end



    class NetworkOffering < Raw
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

    class Vlan < Raw
      cattr_accessor :attr_list
      attr_accessor :id,
                    :forvirtualnetwork,
                    :zoneid,
                    :vlan,
                    :account,
                    :domainid,
                    :domain,
                    :podid,
                    :podname,
                    :gateway,
                    :netmask,
                    :startip,
                    :endip,
                    :networkid,
                    :physicalnetworkid
                    
      @@attr_list = [:id,
                    :forvirtualnetwork,
                    :zoneid,
                    :vlan,
                    :account,
                    :domainid,
                    :domain,
                    :podid,
                    :podname,
                    :gateway,
                    :netmask,
                    :startip,
                    :endip,
                    :networkid,
                    :physicalnetworkid]

    end
   
  end
end




