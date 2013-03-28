module AccountsModelHelper
  module Domain
    def create_domain(args={})
      params = {:command  => "createDomain", :parentdomainid => self.id}
      params.merge! args unless args.empty?
      response = SharedFunction.make_request @cs_agent,
                                             @model_observer, 
                                             params,
                                             "createdomainresponse",
                                             "Domain"

      if response && 
         (!response.instance_of?(CloudStack::Model::Error)) &&
         response.instance_of?(CloudStack::Model::Domain)


        response.p_node = self
        self.domains["#{response.id}"] = response
        changed
        notify_observers("model_create_domain", params, response)
      end
      return response
    end

    def create_account(args={})
      params = {:command  => "createAccount",
                :domainid => "#{self.id}"}
      params.merge! args unless args.empty?
      response = SharedFunction.make_request @cs_agent,
                                             @model_observer, 
                                             params,
                                             "createaccountresponse",
                                             "Account"

      if response && 
         (!response.instance_of?(CloudStack::Model::Error)) &&
         response.instance_of?(CloudStack::Model::Account)
        response.p_node = self
        @accounts["#{response.id}"] = response
        changed
        notify_observers("model_create_account", params, response)
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
         !response.instance_of?(CloudStack::Model::Error) &&
         response.instance_of?(CloudStack::Model::Domain)

        SharedFunction.update_object self, response
      end
      return response
    end

    def delete(args={}) # Asynchronus
      params = {:command  => "deleteDomain", :id => "#{self.id}", :cleanup => true}
      params.merge! args unless args.empty?
      jJob = SharedFunction.make_async_request @cs_agent,
                                               params,
                                               "deletedomainresponse"

      responseObj = SharedFunction.query_async_job @cs_agent,
                                                   @model_observer,
                                                   {:jobid => jJob['jobid']},
                                                   "deleteDomain",
                                                   "Domain"

      if responseObj &&
         !responseObj.instance_of?(CloudStack::Model::Error) &&
         responseObj.instance_of?(CloudStack::Model::Success) &&
         responseObj.success.eql?("true")

        self.p_node.domains.delete self.id
        changed
        notify_observers("model_delete_domain", params, responseObj)
      end
      return responseObj
    end

  end

  module Account
    def pack(j_obj)
      super(j_obj)
      user_j_objs = j_obj['user']

      user_j_objs.each do |juser|
        _tmp = CloudStack::Model::User.new juser, @cs_agent, @model_observer
        @users["#{_tmp.id}"] = _tmp
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
         !response.instance_of?(CloudStack::Model::Error) &&
         response.instance_of?(CloudStack::Model::Account)
        SharedFunction.update_object self, response
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

      if responseObj &&
         !responseObj.instance_of?(CloudStack::Model::Error) &&
         responseObj.instance_of?(CloudStack::Model::Success) &&
         responseObj.success.eql?("true")

        self.p_node.accounts.delete self.id
        changed
        notify_observers("model_delete_account", params, responseObj)
      end

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
         !response.instance_of?(CloudStack::Model::Error) &&
         response.instance_of?(CloudStack::Model::User)
        response.p_node = self
        self.users["#{response.id}"] = response
        changed
        notify_observers("model_create_user", params, response)
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
         !response.instance_of?(CloudStack::Model::Error) &&
         response.instance_of?(CloudStack::Model::Success) &&
         response.success.eql?("true")
        self.p_node.users.delete self.id
        changed
        notify_observers("model_delete_user", params, response)
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
         !response.instance_of?(CloudStack::Model::Error) &&
         response.instance_of?(CloudStack::Model::User)
        SharedFunction.update_object self, response
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
         !response.instance_of?(CloudStack::Model::Error) &&
         response.instance_of?(CloudStack::Model::User)
        SharedFunction.update_object self, response
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

      if responseObj &&  
         !responseObj.instance_of?(CloudStack::Model::Error) &&
         responseObj.instance_of?(CloudStack::Model::User)
        SharedFunction.update_object self, responseObj
      end
      return responseObj
    end
  end
end
