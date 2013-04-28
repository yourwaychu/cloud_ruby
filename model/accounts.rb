module CloudStack
  module Model
    class Domain < Raw
      include AccountsApiHelper::Domain
      include AccountsApiHelper::Account
      include AccountsModelHelper::Domain

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
                     :haschild]

      def initialize(*args)
        @accounts = {}
        @domains  = {}
        super(args[0], args[1])
      end

    end

    class Account < Raw
      include AccountsApiHelper::Account
      include AccountsApiHelper::User
      include AccountsModelHelper::Account
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
        @users = {}
        super(args[0], args[1])
      end
    end
    
    
    class User < Raw
      include AccountsApiHelper::Domain
      include AccountsApiHelper::Account
      include AccountsApiHelper::User
      include AccountsModelHelper::User
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
                    :domainid

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

