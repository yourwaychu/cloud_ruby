require 'active_support/all'

module CloudStack
  module Model
    class Template
      cattr_accessor :attr_list
      attr_accessor :id, :name, :ispublic, :isready, :passwordenabled,
                    :format, :isfeatured, :crosszones, :ostypeid, :ostypename,
                    :account, :zoneid, :zonename, :status, :templatetype,
                    :hypervisor, :domain, :domainid, :isextractable, :checksum

      @@attr_list=[:id, :name, :ispublic, :isready, :passwordenabled,
                   :format, :isfeatured, :crosszones, :ostypeid, :ostypename,
                   :account, :zoneid, :zonename, :status, :templatetype,
                   :hypervisor, :domain, :domainid, :isextractable, :checksum]
                   
    end
  end
end