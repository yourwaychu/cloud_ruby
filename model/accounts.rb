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

      def update(args={})
        params = {:command  => "updateAccount", :id => "#{self.id}"}
        params.merge! args unless args.empty?
        response = SharedFunction.make_request @cs_helper, params, "updateaccountresponse", "Account"
        if response &&
           !response.instance_of?(Error) #&&
           #(/(create|update|delete|register|add)/i.match("updateAccount"))
          changed
          notify_observers("update_account", params, response)
        end
        return response
      end

      def delete(args={})  # Asynchronus
        params = {:command  => "deleteAccount", :id => "#{self.id}"}
        params.merge! args unless args.empty?
        jJob = SharedFunction.make_async_request @cs_helper, params, "deleteaccountresponse"

        responseObj = SharedFunction.query_async_job @cs_helper,
                                                     {:jobid => jJob['jobid']},
                                                     "deleteAccount",
                                                     "Account"

        # if (/(create|update|delete|register|add|disable|enable)/i.match("deleteAccount"))
          changed
          notify_observers("delete_account", params, responseObj)
        # end

        return responseObj
      end

      def create_user(args={})
        params = {:command  => "createUser",
                  :account  => "#{self.name}",
                  :domainid => "#{self.domainid}"}
        params.merge! args unless args.empty?
        response = SharedFunction.make_request @cs_helper, params, "createuserresponse", "User"
        if response &&
           !response.instance_of?(Error) # &&
           #(/(create|update|delete|register|add)/i.match("createUser"))
          changed
          notify_observers("create_user", params, response)
        end
        return response

      end
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

      def create_account(args={})
        params = {:command  => "createAccount",
                  :domainid => "#{self.id}"}
        params.merge! args unless args.empty?
        response = SharedFunction.make_request @cs_helper, params, "createaccountresponse", "Account"
        if response &&
           !response.instance_of?(Error) # &&
           #(/(create|update|delete|register|add)/i.match("createAccount"))
          changed
          notify_observers("create_account", params, response)
        end
        return response
      end

      def update(args={})
        params = {:command  => "updateDomain", :id => "#{self.id}"}
        params.merge! args unless args.empty?
        response = SharedFunction.make_request @cs_helper, params, "updatedomainresponse", "Domain"
        if response &&
           !response.instance_of?(Error) # &&
           # (/(create|update|delete|register|add)/i.match("updateDomain"))
          changed
          notify_observers("update_domain", params, response)
        end
        return response

      end

      def delete(args={}) # Asynchronus
        params = {:command  => "deleteDomain", :id => "#{self.id}"}
        params.merge! args unless args.empty?
        jJob = SharedFunction.make_async_request @cs_helper, params, "deletedomainresponse"

        responseObj = SharedFunction.query_async_job @cs_helper,
                                                     {:jobid => jJob['jobid']},
                                                     "deleteDomain",
                                                     "Domain"

        # if (/(create|update|delete|register|add|disable|enable)/i.match("deleteDomain"))
          changed
          notify_observers("delete_domain", params, responseObj)
        # end

        return responseObj
      end

      # def update_account(args={})
      #   params = {:command  => "updateAccount"}
      #   params.merge! args unless args.empty?
      #   response = SharedFunction.make_request @cs_helper, params, "updateaccountresponse", "Account"
      #   if response &&
      #      !response.instance_of?(Error) &&
      #      (/(create|update|delete|register|add)/i.match("updateAccount"))
      #     changed
      #     notify_observers("update_account", params, response)
      #   end
      #   return response
      # end

      # def delete_account(args={})
      #   params = {:command  => "deleteAccount"}
      #   params.merge! args unless args.empty?
      #   response = SharedFunction.make_request @cs_helper, params, "deleteaccountresponse", "Account"
      #   if response &&
      #      !response.instance_of?(Error) &&
      #      (/(create|update|delete|register|add)/i.match("deleteAccount"))
      #     changed
      #     notify_observers("delete_account", params, response)
      #   end
      #   return response
      # end
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
                     :domainid]

      def delete(args={})
        params = {:command  => "deleteUser", :id => "#{self.id}"}
        params.merge! args unless args.empty?
        response = SharedFunction.make_request @cs_helper, params, "deleteuserresponse", "User"
        if response &&
           !response.instance_of?(Error) # &&
           # (/(create|update|delete|register|add)/i.match("deleteUser"))
          changed
          notify_observers("delete_user", params, response)
        end
        return response
      end

      def update(args={})
        params = {:command  => "updateUser", :id => "#{self.id}"}
        params.merge! args unless args.empty?
        response = SharedFunction.make_request @cs_helper, params, "updateuserresponse", "User"
        if response &&
           !response.instance_of?(Error) # &&
           # (/(create|update|delete|register|add)/i.match("updateUser"))
          changed
          notify_observers("update_user", params, response)
        end
        return response
      end

      def enable(args={})
        params = {:command  => "enableUser", :id => "#{self.id}"}
        params.merge! args unless args.empty?
        response = SharedFunction.make_request @cs_helper, params, "enableuserresponse", "User"
        if response &&
           !response.instance_of?(Error) #&&
           #(/(create|update|delete|register|add|enable)/i.match("enableUser"))
          changed
          notify_observers("enable_user", params, response)
        end
        return response
      end

      def disable(args={}) # Asynchronus
        params = {:command  => "disableUser", :id => "#{self.id}"}
        params.merge! args unless args.empty?
        jJob = SharedFunction.make_async_request @cs_helper, params, "disableuserresponse"

        responseObj = SharedFunction.query_async_job @cs_helper,
                                                     {:jobid => jJob['jobid']},
                                                     "disableUser",
                                                     "User"
        #if (/(create|update|delete|register|add|disable|enable)/i.match("disableUser"))
          changed
          notify_observers("disable_user", params, responseObj)
        #end

        return responseObj
      end

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

