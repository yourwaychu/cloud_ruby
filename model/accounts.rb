module CloudStack
  module Model
    
    class Account < Raw
      include AccountModelHelper

      cattr_accessor :attr_list

      attr_accessor :id, 
                    :name, 
                    :accounttype, 
                    :state, 
                    :domainid

      @@attr_list = [:id, 
                     :name, 
                     :accounttype, 
                     :state, 
                     :domainid]

    end
    
    class Domain < Raw
      cattr_accessor :attr_list

      attr_accessor :id,
                    :name,
                    :level,
                    :parentdomainid,
                    :path,
                    :accounts,
                    :domains,
                    :haschild

      @@attr_list = [:id,
                     :name,
                     :level,
                     :parentdomainid,
                     :path,
                     :accounts,
                     :domains,
                     :haschild]


    end
    
    class User < Raw

      include Observable
      include UserModelHelper
      include CloudStackDomainApiHelper
      include CloudStackAccountApiHelper
      include CloudStackUserApiHelper
      include CloudStackUserkeysApiHelper
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

      attr_accessor :id,
                    :username,
                    :password,
                    :firstname,
                    :lastname,
                    :email,
                    :state,
                    :apikey,
                    :secretkey,
                    :account,
                    :accountid,
                    :domain,
                    :domainid, 
                    :cs_helper

      @@attr_list = [:id,
                     :username,
                     :password,
                     :firstname,
                     :lastname,
                     :email,
                     :state,
                     :apikey,
                     :secretkey,
                     :account,
                     :accountid,
                     :domain,
                     :domainid, 
                     :cs_helper]

    end
    
    class Admin < User

    end
    
    class Userkeys < Raw

      cattr_accessor :apikey, :secretkey

      @@attr_list = [:apikey, :secretkey]

    end
  end
end

