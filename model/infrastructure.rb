require 'active_support/all'

module CloudStack
  module Model

    class Zone < Raw

      cattr_accessor :attr_list

      attr_accessor :id,
                    :name,
                    :dns1,
                    :dns2,
                    :internaldns1,
                    :internaldns2,
                    :zonetoken,
                    :networktype,
                    :allocationstate,
                    :localstorageenabled,
                    :domain,
                    :domainid,
                    :dhcpprovider,
                    :guestcidraddress,
                    :securitygroupenabled,
                    :physical_networks,
                    :networks,
                    :pods,
                    :secondary_storages


      @@attr_list = [:id,
                     :name,
                     :dns1,
                     :dns2,
                     :internaldns1,
                     :internaldns2,
                     :zonetoken,
                     :networktype,
                     :allocationstate,
                     :localstorageenabled,
                     :domain,
                     :domainid,
                     :dhcpprovider,
                     :guestcidraddress,
                     :securitygroupenabled]

      def initialize(*args)
        super(args[0])
        @physical_networks  = {}
        @networks           = {}
        @pods               = {}
        @secondary_storages = {}
      end


      def sync
        # sync_phsical_networks
        # sync_networks
        # sync_pods
        # sync_secondary_storage
      end

      def update(args={})
        params = {:command  => "updateZone", :id => "#{self.id}"}
        params.merge! args unless args.empty?
        response = SharedFunction.make_request @cs_helper, params, "updatezoneresponse", "Zone"
        if response &&
           !response.instance_of?(Error) #&&
           #(/(create|update|delete|register|add)/i.match("updateAccount"))
          changed
          notify_observers("update_zone", params, response)
        end
        return response
      end

      def create_physical_network(args={}) #Asychronous
        params = {:command  => "createPhysicalNetwork", :zoneid => "#{self.id}"}
        params.merge! args unless args.empty?
        jJob = SharedFunction.make_async_request @cs_helper, params, "createphysicalnetworkresponse"

        responseObj = SharedFunction.query_async_job @cs_helper,
                                                     {:jobid => jJob['jobid']},
                                                     "createPhysicalNetwork",
                                                     "PhysicalNetwork"

        # if (/(create|update|delete|register|add|disable|enable)/i.match("deleteAccount"))
          changed
          notify_observers("create_physical_network", params, responseObj)
        # end

        return responseObj
      end


      def create_network(args={})
        params = {:command  => "createNetwork", :zoneid => "#{self.id}"}
        params.merge! args unless args.empty?
        response = SharedFunction.make_request @cs_helper, params, "createnetworkresponse", "Network"
        if response &&
           !response.instance_of?(Error) #&&
           #(/(create|update|delete|register|add)/i.match("updateAccount"))
          changed
          notify_observers("create_network", params, response)
        end
        return response

      end


      def create_pod(args={})
        params = {:command  => "createPod", :zoneid => "#{self.id}"}
        params.merge! args unless args.empty?
        response = SharedFunction.make_request @cs_helper, params, "createpodresponse", "Pod"
        if response &&
           !response.instance_of?(Error) #&&
           #(/(create|update|delete|register|add)/i.match("updateAccount"))
          changed
          notify_observers("create_pod", params, response)
        end
        return response

      end


      def add_secondary_storage(args={})
        params = {:command  => "addSecondaryStorage", :zoneid => "#{self.id}"}
        params.merge! args unless args.empty?
        response = SharedFunction.make_request @cs_helper, params, "addsecondarystorageresponse", "SecondaryStorage"
        if response &&
           !response.instance_of?(Error) #&&
           #(/(create|update|delete|register|add)/i.match("updateAccount"))
          changed
          notify_observers("add_secondary_storage", params, response)
        end
        return response

      end
    end
    
    class Pod < Raw
      cattr_accessor :attr_list

      attr_accessor :id, 
                    :name,
                    :zoneid,
                    :zonename,
                    :gateway,
                    :netmask,
                    :startip,
                    :endip,
                    :allocationstate,
                    :vlans,
                    :clusters

      @@attr_list = [:id,                  
                     :name,
                     :zoneid,
                     :zonename,
                     :gateway,
                     :netmask,
                     :startip,
                     :endip,
                     :allocationstate]

      def initialize(*args)
        super(args[0])
        @vlans = {}
        @clusters = {}
      end 


      def create_vlan_ip_range(args={})
        params = {:command  => "createVlanIpRange", :podid => "#{self.id}"}
        params.merge! args unless args.empty?
        response = SharedFunction.make_request @cs_helper, params, "createvlaniprangeresponse", "Vlan"
        if response &&
           !response.instance_of?(Error) #&&
           #(/(create|update|delete|register|add)/i.match("updateAccount"))
          changed
          notify_observers("create_vlan_ip_range", params, response)
        end
        return response
      end
      
      def add_cluster(args={}) 
        params = {:command  => "addCluster", :podid => "#{self.id}", :zoneid => "#{self.zoneid}"}
        params.merge! args unless args.empty?
        response = SharedFunction.make_request @cs_helper, params, "addclusterresponse", "Cluster"
        if response &&
           !response.instance_of?(Error) #&&
           #(/(create|update|delete|register|add)/i.match("updateAccount"))
          changed
          notify_observers("add_cluster", params, response)
        end
        return response
      end
    end
    
    class Cluster < Raw

      cattr_accessor :attr_list

      attr_accessor :id,
                    :name,
                    :podid,
                    :podname,
                    :zoneid, 
                    :zonename,
                    :hypervisortype, 
                    :clustertype,
                    :allocationstate,
                    :managedstate,
                    :cpuovercommitratio,
                    :memoryovercommitratio,
                    :hosts
                    
      @@attr_list = [:id,
                     :name,
                     :podid,
                     :podname,
                     :zoneid, 
                     :zonename,
                     :hypervisortype, 
                     :clustertype,
                     :allocationstate,
                     :managedstate,
                     :cpuovercommitratio,
                     :memoryovercommitratio]

      def initialize(*args)
        super(args[0])
        @hosts = {}
      end

      def add_host(args={})
        params = {:command   => "addHost",
                  :clusterid => "#{self.id}",
                  :podid     => "#{self.podid}",
                  :zoneid    => "#{self.zoneid}"}

        params.merge! args unless args.empty?
        response = SharedFunction.make_request @cs_helper, params, "addhostresponse", "Host"
        if response &&
           !response.instance_of?(Error) #&&
           #(/(create|update|delete|register|add)/i.match("updateAccount"))
          changed
          notify_observers("add_host", params, response)
        end
        return response
      end

    end
    
    class Host < Raw

      cattr_accessor :attr_list

      attr_accessor :id,
                    :name,
                    :state,
                    :disconnected, 
                    :type, 
                    :ipaddress,
                    :zoneid, 
                    :zonename,
                    :podid, 
                    :podname,
                    :version,
                    :hypervisor,
                    :cpunumber,
                    :cpuspeed,
                    :cpuallocated,
                    :cpuused,
                    :cpuwithoverprovisioning, 
                    :memorytotal, 
                    :memoryallocated,
                    :memoryused,
                    :capabilities,
                    :lastpinged,
                    :managementserverid, 
                    :clusterid, 
                    :clustername,
                    :clustertype,
                    :islocalstorageactive, 
                    :events,
                    :hosttags,
                    :suitableformigration,
                    :resourcestate,
                    :hahost,
                    :jobstatus
                    
      @@attr_list = [:id,
                     :name,
                     :state,
                     :disconnected, 
                     :type, 
                     :ipaddress,
                     :zoneid, 
                     :zonename,
                     :podid, 
                     :podname,
                     :version,
                     :hypervisor,
                     :cpunumber,
                     :cpuspeed,
                     :cpuallocated,
                     :cpuused,
                     :cpuwithoverprovisioning, 
                     :memorytotal, 
                     :memoryallocated,
                     :memoryused,
                     :capabilities,
                     :lastpinged,
                     :managementserverid, 
                     :clusterid, 
                     :clustername,
                     :clustertype,
                     :islocalstorageactive, 
                     :events,
                     :hosttags,
                     :suitableformigration,
                     :resourcestate,
                     :hahost,
                     :jobstatus]

    end

    class SecondaryStorage < Raw
      cattr_accessor :attr_list
      attr_accessor :id,
                    :name,
                    :state,
                    :type,
                    :ipaddress,
                    :zoneid,
                    :zonename,
                    :hypervisor,
                    :islocalstorageactive,
                    :events,
                    :resourcestate,
                    :jobstatus

      @@attr_list = [:id,
                     :name,
                     :state,
                     :type,
                     :ipaddress,
                     :zoneid,
                     :zonename,
                     :hypervisor,
                     :islocalstorageactive,
                     :events,
                     :resourcestate,
                     :jobstatus]

    end

    class SystemVm < Raw
      cattr_accessor :attr_list
      attr_accessor :id,
                    :systemvmtype,
                    :zoneid,
                    :zonename,
                    :dns1,
                    :gateway,
                    :name,
                    :podid,
                    :hostid,
                    :hostname,
                    :privateip,
                    :privatemacaddress,
                    :privatenetmask,
                    :linklocalip,
                    :linklocalmacaddress,
                    :linklocalnetmask,
                    :publicip,
                    :publicmacaddress,
                    :publicnetmask,
                    :templateid,
                    :state

      @@attr_list = [:id,
                     :systemvmtype,
                     :zoneid,
                     :zonename,
                     :dns1,
                     :gateway,
                     :name,
                     :podid,
                     :hostid,
                     :hostname,
                     :privateip,
                     :privatemacaddress,
                     :privatenetmask,
                     :linklocalip,
                     :linklocalmacaddress,
                     :linklocalnetmask,
                     :publicip,
                     :publicmacaddress,
                     :publicnetmask,
                     :templateid,
                     :state]

    end

  end # End of module module
end # End of cloudstack module
