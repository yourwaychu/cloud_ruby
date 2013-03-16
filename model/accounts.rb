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

      include UserModelHelper
      include AccountsApiHelper::Domain
      include AccountsApiHelper::Account
      include AccountsApiHelper::User
      include NetworkApiHelper
      include InfraApiHelper::Zone
      include InfraApiHelper::Pod
      include InfraApiHelper::Cluster
      include InfraApiHelper::Host
      include InfraApiHelper::SystemVm
      include ServiceOfferingApiHelper::DiskOffering
      include ServiceOfferingApiHelper::ServiceOffering
      include ServiceOfferingApiHelper::NetworkOffering
      include TemplateApiHelper
      include VMApiHelper

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
    
    class UserKeys < Raw
      
      cattr_accessor :attr_list
      
      attr_accessor :apikey, :secretkey

      @@attr_list = [:apikey, :secretkey]

    end
  end
end

