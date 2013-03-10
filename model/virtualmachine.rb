module CloudStack
  module Model
    class VirtualMachine < Raw

      cattr_accessor :attr_list

      attr_accessor :id,
                    :name,
                    :account,
                    :domainid,
                    :domain,
                    :state,
                    :haenable,
                    :zoneid,
                    :zonename,
                    :hostid,
                    :hostname,
                    :templateid,
                    :templatename,
                    :templatedisplaytext,
                    :passwordenabled,
                    :serviceofferingid,
                    :serviceofferingname,
                    :cpunumber,
                    :cpuspeed,
                    :memory,
                    :guestosid,
                    :rootdeviceid,
                    :rootdevicetype,
                    :securitygroup,
                    :nic,
                    :hypervisor,
                    :instancename,
                    :tags,
                    :jobstatus

      @@attr_list = [:id,
                     :name,
                     :account,
                     :domainid,
                     :domain,
                     :state,
                     :haenable,
                     :zoneid,
                     :zonename,
                     :hostid,
                     :hostname,
                     :templateid,
                     :templatename,
                     :templatedisplaytext,
                     :passwordenabled,
                     :serviceofferingid,
                     :serviceofferingname,
                     :cpunumber,
                     :cpuspeed,
                     :memory,
                     :guestosid,
                     :rootdeviceid,
                     :rootdevicetype,
                     :securitygroup,
                     :nic,
                     :hypervisor,
                     :instancename,
                     :tags,
                     :jobstatus]
    end
  end
end
