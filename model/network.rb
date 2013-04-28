module CloudStack
  module Model

    class Network < Raw
      include NetworkApiHelper::Network
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
                       :list_traffic_types,
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
      include NetworkApiHelper::TrafficType
      include NetworkApiHelper::PhysicalNetwork
      include NetworkModelHelper::PhysicalNetwork

      cattr_accessor :attr_list

      attr_accessor :id, :broadcastdomainrange, :domainid, :isolationmethods,
                    :name, :networkspeed, :state, :tags, :vlan, :zoneid, :network_service_providers,
                    :traffic_types, :vlans

      @@attr_list=[:id, :broadcastdomainrange, :domainid, :isolationmethods,
                    :name, :networkspeed, :state, :tags, :vlan, :zoneid]


      def initialize(*args)
        @network_service_providers = {}
        @traffic_types = []
        @vlans = {}
        super(args[0], args[1])
      end
    end
    
    class TrafficType < Raw
      include NetworkApiHelper::TrafficType  
      include NetworkModelHelper::TrafficType

      cattr_accessor :attr_list

      attr_accessor :id,
                    :traffictype,
                    :physicalnetworkid,
                    :kvmnetworklabel,
                    :vmwarenetworklabel,
                    :xennetworklabel

      @@attr_list = [:id,
                     :traffictype,
                     :physicalnetworkid,
                     :kvmnetworklabel,
                     :vmwarenetworklabel,
                     :xennetworklabel]
    end

    class NetworkServiceProvider < Raw
      include NetworkApiHelper::Network
      include NetworkModelHelper::NetworkServiceProvider

      cattr_accessor :attr_list

      attr_accessor :id, :name, :physicalnetworkid, :state, :servicelist, :virtual_router_elements

      @@attr_list = [:id, :name, :physicalnetworkid, :state, :servicelist] 

      def initialize(*args)
        @virtual_router_elements = {}
        super(args[0], args[1])
      end
    end


    class VirtualRouterElement < Raw
      include NetworkApiHelper::Network
      include NetworkModelHelper::VirtualRouterElement

      cattr_accessor :attr_list

      attr_accessor :id, :nspid, :enabled, :physicalnetworkid

      @@attr_list = [:id, :nspid, :enabled]


    end



    # class NetworkOffering < Raw
    #   cattr_accessor :attr_list

    #   attr_accessor :id, :name, :displaytext, :traffictype, :isdefault,
    #                 :specifyvlan, :conservemode, :specifyipranges,
    #                 :availability, :networkrate, :state, :guestiptype,
    #                 :serviceofferingid

    #   @@attr_list=[:id, :name, :displaytext, :traffictype, :isdefault,
    #                :specifyvlan, :conservemode, :specifyipranges,
    #                :availability, :networkrate, :state, :guestiptype,
    #                :serviceofferingid]

    # end

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




