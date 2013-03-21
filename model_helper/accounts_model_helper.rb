module AccountsModelHelper
  module Domain
    def create_account(args={})
      params = {:command  => "createAccount",
                :domainid => "#{self.id}"}
      params.merge! args unless args.empty?
      response = SharedFunction.make_request @cs_agent,
                                             @model_observer, 
                                             params,
                                             "createaccountresponse",
                                             "Account"

      if response && (!response.instance_of?(CloudStack::Model::Error))
        @accounts["#{response.id}"] = response
        changed
        notify_observers("create_account", params, response)
      end
      return response
    end

    def update(args={})

      params = {:command  => "updateDomain", :id => "#{self.id}"}

      params.merge! args unless args.empty?

      response = SharedFunction.make_request @cs_agent,
                                             @model_observer, 
                                             params, 
                                             "updatedomainresponse",
                                             "Domain"
      if response &&
         !response.instance_of?(CloudStack::Model::Error) # &&
        SharedFunction.update_object self, response
        # changed
        # notify_observers("update_domain", params, response)
      end
      return response

    end

    def delete(args={}) # Asynchronus
      params = {:command  => "deleteDomain", :id => "#{self.id}"}
      params.merge! args unless args.empty?
      jJob = SharedFunction.make_async_request @cs_agent,
                                               params,
                                               "deletedomainresponse"

      responseObj = SharedFunction.query_async_job @cs_agent,
                                                   @model_observer,
                                                   {:jobid => jJob['jobid']},
                                                   "deleteDomain",
                                                   "Domain"

      changed
      notify_observers("delete_domain", params, responseObj)

      return responseObj
    end

  end

  module Account

    #override
    def pack(j_obj)
      super(j_obj)
      user_j_objs = j_obj['user']

      user_j_objs.each do |juser|
        tmp = CloudStack::Model::User.new juser, nil, @model_observer
        @users["#{tmp.id}"] = tmp
      end
    end

    def update(args={})
      params = {:command  => "updateAccount", :id => "#{self.id}"}
      params.merge! args unless args.empty?
      response = SharedFunction.make_request @cs_agent,
                                             @model_observer, 
                                             params,
                                             "updateaccountresponse",
                                             "Account"
      if response &&
         !response.instance_of?(CloudStack::Model::Error) #&&
        SharedFunction.update_object self, response
        # changed
        # notify_observers("update_account", params, response)
      end
      return response
    end

    def delete(args={})  # Asynchronus
      params = {:command  => "deleteAccount", :id => "#{self.id}"}
      params.merge! args unless args.empty?
      jJob = SharedFunction.make_async_request @cs_agent,
                                               params,
                                               "deleteaccountresponse"

      responseObj = SharedFunction.query_async_job @cs_agent,
                                                   @model_observer,
                                                   {:jobid => jJob['jobid']},
                                                   "deleteAccount",
                                                   "Account"

      changed
      notify_observers("delete_account", params, responseObj)

      return responseObj
    end

    def create_user(args={})
      params = {:command  => "createUser",
                :account  => "#{self.name}",
                :domainid => "#{self.domainid}"}
      params.merge! args unless args.empty?
      response = SharedFunction.make_request @cs_agent,
                                             @model_observer, 
                                             params, 
                                             "createuserresponse",
                                             "User"
      if response &&
         !response.instance_of?(CloudStack::Model::Error)
        @users["#{response.id}"] = response
        changed
        notify_observers("create_user", params, response)
      end
      return response

    end
  end

  module User

    def registerCSHelper(url, cs_instance)
      if self.apikey && self.secretkey  
        @cs_helper = CloudStackHelper.new :api_key => self.apikey, 
                                         :secret_key => self.secretkey,
                                         :api_url => "#{url}"
      end
    end

    def delete(args={})
      params = {:command  => "deleteUser", :id => "#{self.id}"}
      params.merge! args unless args.empty?
      response = SharedFunction.make_request @cs_agent,
                                             @model_observer,
                                             params, 
                                             "deleteuserresponse", 
                                             "User"
      if response &&
         !response.instance_of?(CloudStack::Model::Error) # &&
        changed
        notify_observers("delete_user", params, response)
      end
      return response
    end

    def update(args={})
      params = {:command  => "updateUser", :id => "#{self.id}"}
      params.merge! args unless args.empty?
      response = SharedFunction.make_request @cs_agent,
                                             @model_observer,
                                             params,
                                             "updateuserresponse",
                                             "User"
      if response &&
         !response.instance_of?(CloudStack::Model::Error) # &&
        SharedFunction.update_object self, response
        # changed
        # notify_observers("update_user", params, response)
      end
      return response
    end

    def enable(args={})
      params = {:command  => "enableUser", :id => "#{self.id}"}
      params.merge! args unless args.empty?
      response = SharedFunction.make_request @cs_agent,
                                             @model_observer,
                                             params, 
                                             "enableuserresponse",
                                             "User"
      if response &&
         !response.instance_of?(CloudStack::Model::Error) #&&
        changed
        notify_observers("enable_user", params, response)
      end
      return response
    end

    def disable(args={}) # Asynchronus

      params = {:command  => "disableUser", :id => "#{self.id}"}

      params.merge! args unless args.empty?

      jJob = SharedFunction.make_async_request @cs_agent,
                                               params, 
                                               "disableuserresponse"

      responseObj = SharedFunction.query_async_job @cs_agent,
                                                   @model_observer,
                                                   {:jobid => jJob['jobid']},
                                                   "disableUser",
                                                   "User"
      changed
      notify_observers("disable_user", params, responseObj)

      return responseObj
    end
  end
end
