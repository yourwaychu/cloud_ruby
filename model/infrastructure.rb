require 'active_support/all'

module CloudStack
  module Model

    class Zone

      cattr_accessor :attr_list

      attr_accessor :id, :name, :dns1, :dns2, :internaldns1, :internaldns2,
                    :networktype, :allocationstate, :domain, :domainid,
                    :guestcidraddress, :securitygroupenabled,
                    :physical_networks, :pods

      @@attr_list=["id", "name", "dns1", "dns2", "internaldns1", "internaldns2",
                   "networktype", "allocationstate", "domain", "domainid",
                   "guestcidraddress","securitygroupenabled"]


      def initialize
        @physical_networks = {}
        @pods = {}
      end

    end
    
    class Pod
      cattr_accessor :attr_list
      attr_accessor :id, :name, :zoneid, :zonename, :gateway, :netmask,
                    :startip, :endip, :allocationstate, :clusters
      @@attr_list = ["id", "name", "zoneid", "zonename", "gateway", "netmask",
                     "startip", "endip", "allocationstate"]
      def initialize
        @clusters = {}
      end
    end
    
    class Cluster
      cattr_accessor :attr_list
      attr_accessor :id, :name, :podid, :podname, :zoneid, :zonename,
                    :hypervisortype, :clustertype, :allocationstate,
                    :managedstate, :hosts
                    
      @@attr_list = ["id", "name", "podid", "podname", "zoneid", "zonename",
                     "hypervisortype", "clustertype", "allocationstate",
                     "managedstate"]
      def initialize
        @hosts = {}
      end
    end
    
    class Host
      cattr_accessor :attr_list
      attr_accessor :id, :name, :state, :disconnected, :type, :ipaddress,
                    :zoneid, :zonename, :podid, :podname, :version, :hypervisor,
                    :cpunumber, :cpuspeed, :cpuallocated, :cpuused,
                    :cpuwithoverprovisioning, :networkkbsread, :networkkbswrite,
                    :memorytotal, :memoryallocated, :memoryused, :capabilities,
                    :lastpinged, :managementserverid, :clusterid, :clustername,
                    :clustertype, :islocalstorageactive, :events, :hosttags,
                    :suitableformigration, :resourcestate, :hahost
                    
      @@attr_list = ["id", "name", "state", "disconnected", "type", "ipaddress",
                    "zoneid", "zonename", "podid", "podname", "version", "hypervisor",
                    "cpunumber", "cpuspeed", "cpuallocated", "cpuused",
                    "cpuwithoverprovisioning", "networkkbsread", "networkkbswrite",
                    "memorytotal", "memoryallocated", "memoryused", "capabilities",
                    "lastpinged", "managementserverid", "clusterid", "clustername",
                    "clustertype", "islocalstorageactive", "events", "hosttags",
                    "suitableformigration", "resourcestate", "hahost"]
      def initialize
      end
    end


    class PhysicalNetwork

      cattr_accessor :attr_list

      attr_accessor :id, :broadcastdomainrange, :domainid, :isolationmethods,
                    :name, :networkspeed, :state, :tags, :vlan, :zoneid

      @@attr_list=["id", "broadcastdomainrange", "domainid", "isolationmethods",
                   "name", "networkspeed", "state", "tags", "vlan", "zoneid"]

      def initialize
        @traffic_types = {}
      end
    end


    class TrafficType

      cattr_accessor :attr_list

      attr_accessor :id, :traffictype, :physicalnetworkid

      @@attr_list=["id", "traffictype", "physicalnetworkid"]
      
      def initialize
      end
      
    end
    
  end # End of module module
end # End of cloudstack module

