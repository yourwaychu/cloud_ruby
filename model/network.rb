module CloudStack
  module Model

    class Network < Raw

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

      def delete(args={})
        params = {:command  => "deleteNetwork", :id => "#{self.id}"}
        params.merge! args unless args.empty?
        jJob = SharedFunction.make_async_request @cs_helper, params, "deletenetworkresponse"

        responseObj = SharedFunction.query_async_job @cs_helper,
                                                     {:jobid => jJob['jobid']},
                                                     "deleteNetwork",
                                                     "Network"

        # if (/(create|update|delete|register|add|disable|enable)/i.match("deleteAccount"))
          changed
          notify_observers("delete_network", params, responseObj)
        # end

        return responseObj

      end

    end

    class PhysicalNetwork < Raw

      cattr_accessor :attr_list

      attr_accessor :id, :broadcastdomainrange, :domainid, :isolationmethods,
                    :name, :networkspeed, :state, :tags, :vlan, :zoneid, :network_service_providers

      @@attr_list=[:id, :broadcastdomainrange, :domainid, :isolationmethods,
                    :name, :networkspeed, :state, :tags, :vlan, :zoneid]


      def initialize(*args)
        super(args[0])
        @network_service_providers = {}
      end

      def delete(args={}) # Asynchronous
        params = {:command  => "deletePhysicalNetwork", :id => "#{self.id}"}
        params.merge! args unless args.empty?
        jJob = SharedFunction.make_async_request @cs_helper, params, "deletephysicalnetworkresponse"

        responseObj = SharedFunction.query_async_job @cs_helper,
                                                     {:jobid => jJob['jobid']},
                                                     "deletePhysicalNetwork",
                                                     "PhysicalNetwork"

        # if (/(create|update|delete|register|add|disable|enable)/i.match("deleteAccount"))
          changed
          notify_observers("delete_physical_network", params, responseObj)
        # end

        return responseObj
      end

      def add_traffic_type(args={}) #Asynchronous
        params = {:command  => "addTrafficType", :physicalnetworkid => "#{self.id}"}
        params.merge! args unless args.empty?
        jJob = SharedFunction.make_async_request @cs_helper, params, "addtraffictyperesponse"

        responseObj = SharedFunction.query_async_job @cs_helper,
                                                     {:jobid => jJob['jobid']},
                                                     "addTrafficType",
                                                     "TrafficType"

        # if (/(create|update|delete|register|add|disable|enable)/i.match("deleteAccount"))
          changed
          notify_observers("add_traffic_type", params, responseObj)
        # end
        return responseObj
      end

      def update(args={}) #Asynchronous
        params = {:command  => "updatePhysicalNetwork", :id => "#{self.id}"}
        params.merge! args unless args.empty?
        jJob = SharedFunction.make_async_request @cs_helper, params, "updatephysicalnetworkresponse"

        responseObj = SharedFunction.query_async_job @cs_helper,
                                                     {:jobid => jJob['jobid']},
                                                     "updatePhysicalNetwork",
                                                     "PhysicalNetwork"

        # if (/(create|update|delete|register|add|disable|enable)/i.match("deleteAccount"))
          changed
          notify_observers("update_physical_network", params, responseObj)
        # end
        return responseObj

      end

    end
    
    class TrafficType < Raw

      cattr_accessor :attr_list

      attr_accessor :id, :traffictype, :physicalnetworkid

      @@attr_list = [:id, :traffictype, :physicalnetworkid]

    end

    class NetworkServiceProvider < Raw
      cattr_accessor :attr_list
      attr_accessor :id, :name, :physicalnetworkid, :state, :servicelist, :virtual_router_elements
      @@attr_list = [:id, :name, :physicalnetworkid, :state, :servicelist] 

      def initialize(*args)
        super(args[0])
        @virtual_router_elements = {}
      end


      def enable(args={}) # Asynchronous
        params = {:command  => "updateNetworkServiceProvider", :id => "#{self.id}", :state =>"Enabled"}
        params.merge! args unless args.empty?
        jJob = SharedFunction.make_async_request @cs_helper, params, "updatenetworkserviceproviderresponse"

        responseObj = SharedFunction.query_async_job @cs_helper,
                                                     {:jobid => jJob['jobid']},
                                                     "updateNetworkServiceProvider",
                                                     "NetworkServiceProvider"

        # if (/(create|update|delete|register|add|disable|enable)/i.match("deleteAccount"))
          changed
          notify_observers("enable_network_service_provider", params.merge!({:physicalnetworkid => "#{self.physicalnetworkid}"}), responseObj)
        # end
        return responseObj
      end

      def update(args={})
        # FIXME
        puts "FIXME : Updating network service provider"
        
      end

    end


    class VirtualRouterElement < Raw
      cattr_accessor :attr_list
      attr_accessor :id, :nspid, :enabled, :physicalnetworkid
      @@attr_list = [:id, :nspid, :enabled]


      def enable(args={}) #Asynchronous
        params = {:command  => "configureVirtualRouterElement", :id => "#{self.id}", :enabled => true}
        params.merge! args unless args.empty?
        jJob = SharedFunction.make_async_request @cs_helper, params, "configurevirtualrouterelementresponse"

        responseObj = SharedFunction.query_async_job @cs_helper,
                                                     {:jobid => jJob['jobid']},
                                                     "configureVirtualRouterElement",
                                                     "VirtualRouterElement"

        # if (/(create|update|delete|register|add|disable|enable)/i.match("deleteAccount"))
          changed
          notify_observers("configure_virtual_router_element", params.merge!({:physicalnetworkid=>"#{self.physicalnetworkid}"}), responseObj)
        # end
        return responseObj

      end
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
   
  end # End of module module
end # End of cloudstack module




