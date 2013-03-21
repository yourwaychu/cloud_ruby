module CloudStack
  module Model
    
    class Account < Raw

      cattr_accessor :attr_list

      attr_accessor :id, 
                    :name, 
                    :accounttype, 
                    :state, 
                    :domainid,
                    :users

      @@attr_list = [:id, 
                     :name, 
                     :accounttype, 
                     :state, 
                     :domainid]

      def initialize(*args)
        super(args[0], args[1], args[2])
        @users = {}
      end

      include AccountsModelHelper::Account
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

      def initialize(*args)
        super(args[0], args[1], args[2])
        @accounts = {}
        @domains  = {}
      end

      include AccountsModelHelper::Domain
    end
    
    class User < Raw

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
                     :domainid]

      include AccountsModelHelper::User

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

