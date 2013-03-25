require 'active_support/all'

module CloudStack
  module Model

    class Zone < Raw

      include InfraModelHelper::Zone

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
        super(args[0], args[1], args[2])
        @physical_networks  = {}
        @networks           = {}
        @pods               = {}
        @secondary_storages = {}
      end

    end
    
    class Pod < Raw

      include InfraModelHelper::Pod

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
        super(args[0], args[1], args[2])
        @vlans = {}
        @clusters = {}
      end 


    end
    
    class Cluster < Raw

      include InfraModelHelper::Cluster

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
        @hosts = {}
        super(args[0], args[1], args[2])
      end
    end
    
    class Host < Raw

      include InfraModelHelper::Host

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

      def initialize(*args)
        super(args[0], args[1], args[2])
      end

    end

    class SecondaryStorage < Raw

      include InfraModelHelper::SecondaryStorage

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
