require 'active_support/all'

module CloudStack
  module Model
    
    class NetworkOffering
      cattr_accessor :attr_list

      attr_accessor :id, :name, :displaytext, :traffictype, :isdefault,
                    :specifyvlan, :conservemode, :specifyipranges,
                    :availability, :networkrate, :state, :guestiptype,
                    :serviceofferingid, :services

      @@attr_list=["id", "name", "displaytext", "traffictype",
                   "isdefault", "specifyvlan", "conservemode",
                   "specifyipranges", "availability", "networkrate",
                   "state", "guestiptype", "serviceofferingid"]
      def initialize
        @services={}
      end
    end

    class NetworkOfferingService
      cattr_accessor :attr_list
      attr_accessor :name, :providers
      @@attr_list=["name"]
      def initialize
        @providers={}
      end
    end

    class NetworkOfferingServiceProvider
      cattr_accessor :attr_list
      attr_accessor :name
      @@attr_list=["name"]
    end
    
  end # End of module module
end # End of cloudstack module




