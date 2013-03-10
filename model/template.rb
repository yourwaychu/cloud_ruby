require 'active_support/all'

module CloudStack
  module Model
    class Template < Raw
      cattr_accessor :attr_list

      attr_accessor :id,
                    :name,
                    :displaytext,
                    :ispublic,
                    :isready,
                    :passwordenabled,
                    :format,
                    :isfeatured,
                    :crossZones,
                    :ostypeid,
                    :ostypename,
                    :account,
                    :zoneid,
                    :zonename,
                    :status,
                    :size,
                    :templatetype,
                    :hypervisor,
                    :domain,
                    :domainid,
                    :isextractable,
                    :checksum,
                    :sshkeyenabled

      @@attr_list=[:id,
                   :name,
                   :displaytext,
                   :ispublic,
                   :isready,
                   :passwordenabled,
                   :format,
                   :isfeatured,
                   :crossZones,
                   :ostypeid,
                   :ostypename,
                   :account,
                   :zoneid,
                   :zonename,
                   :status,
                   :size,
                   :templatetype,
                   :hypervisor,
                   :domain,
                   :domainid,
                   :isextractable,
                   :checksum,
                   :sshkeyenabled]
                   
    end
  end
end
