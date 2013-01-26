require 'active_support/all'
require 'observer'

module CloudStack
  module Model
    class User

      include Observable
      include UserModelHelper
      include CloudStackDomainApiHelper
      include CloudStackAccountApiHelper
      include CloudStackUserApiHelper
      include CloudStackNetworkApiHelper
      include CloudStackDiskOfferingApiHelper
      include CloudStackServiceOfferingApiHelper
      include CloudStackZoneApiHelper
      include CloudStackTemplateApiHelper
      include CloudStackPodApiHelper
      include CloudStackClusterApiHelper
      include CloudStackHostApiHelper
      include CloudStackVMApiHelper

      cattr_accessor :attr_list

      attr_accessor :id, :username, :password, :firstname, :lastname,
                    :email, :state, :apikey, :secretkey, :account,
                    :domainid, :cs_helper

      @@attr_list=["id", "username", "password", "firstname", "lastname", 
                   "email", "state", "apikey", "secretkey", "account",
                   "domainid"]

    end
    
    class Admin < User

    end
    
  end# End of module module
end# End of cloudstack module


