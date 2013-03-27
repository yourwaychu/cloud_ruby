module AccountsObsvrHelper

  module Domain
  private
    def obsvr_create_domain(h_para, domainObj)
      @domains["#{domainObj.id}"] = domainObj
    
      if domainObj.parentdomainid
        domainObj.p_node = @domains["#{domainObj.parentdomainid}"]
        @domains["#{domainObj.parentdomainid}"].domains["#{domainObj.id}"] = domainObj
      end
    end

    def obsvr_model_create_domain(params, domainObj)
      @domains["#{domainObj.id}"] = domainObj
    end

    def obsvr_update_domain(h_para, domainObj)
      oldObj = @domains["#{domainObj.id}"]
      SharedFunction.update_object(oldObj, domainObj)
    end

    def obsvr_delete_domain(params, respObj)
      _domain = @domains["#{params[:id]}"]
      @accounts.values.each do |acc|
        if acc.domainid.eql? params[:id]
          acc.users.values.each do |usr|
            @users.delete usr.id
          end
          @accounts.delete acc.id
        end
      end
      if _domain.parentdomainid
        @domains["#{_domain.parentdomainid}"].domains.delete "#{_domain.id}"
      end
      @domains.delete "#{_domain.id}"
    end

    def obsvr_model_delete_domain(params, respObj)
      @domains.delete "#{params[:id]}"
      @accounts.values.each do |acc|
        if acc.domainid.eql? params[:id]
          acc.users.values.each do |usr|
            @users.delete usr.id
          end
          @accounts.delete acc.id
        end
      end
    end
  end

  module Account
  private
    def obsvr_create_account(h_para, accObj)
      @accounts["#{accObj.id}"] = accObj

      @domains["#{accObj.domainid}"].accounts["#{accObj.id}"] = accObj

      _user = accObj.users.values[0]

      if _user
        @users["#{_user.id}"] = _user
      end
    end

    def obsvr_model_create_account(params, respObj)
      @accounts["#{respObj.id}"] = respObj

      _user = respObj.users.values[0]

      if _user
        @users["#{_user.id}"] = _user
      end
    end

    def obsvr_model_delete_account(params, respObj)
      if respObj.success.to_s.eql? "true"
        @accounts.delete "#{params[:id]}"
        @users.values.each do |usr|
          if usr.accountid.eql? params[:id]
            @users.delete usr.id
          end
        end
      end
    end

    def obsvr_update_account(h_para, accObj)
      oldObj = @accounts["#{accObj.id}"]
      SharedFunction.update_object(oldObj, accObj)
    end

    def obsvr_delete_account(h_para, respObj)
      if respObj.success.eql? "true"
        @accounts.delete "#{h_para[:id]}"
        @users.values.each do |usr|
          if usr.accountid.eql? h_para[:id]
            @users.delete usr.id
          end
        end
      end
    end
  end

  module User
  private
    def obsvr_create_user(h_para, userObj)
      @users["#{userObj.id}"] = userObj

      @accounts.each do |k, acc|
        if acc.id.eql? userObj.accountid
          acc.users["#{userObj.id}"] = userObj
        end
      end
    end

    def obsvr_model_create_user(params, userObj)
      @users["#{userObj.id}"] = userObj
    end

    def obsvr_update_user(h_para, userObj)
      oldObj = @users["#{userObj.id}"]
      SharedFunction.update_object(oldObj, userObj)
    end

    def obsvr_register_user_keys(h_para, keyObj)
      @userObj = @users["#{h_para[:id]}"]
      @userObj.apikey = "#{keyObj.apikey}"
      @userObj.secretkey = "#{keyObj.secretkey}"
      @userObj.registerCSHelper request_url, self
    end

    def obsvr_disable_user(h_para, respObj)
      @users["#{respObj.id}"].state = respObj.state
    end

    def obsvr_enable_user(h_para, respObj)
      @users["#{respObj.id}"].state = respObj.state
    end

    def obsvr_delete_user(h_para, respObj)
      if respObj.success.eql? "true"
        @users.delete "#{h_para[:id]}"
      end
    end

    def obsvr_model_delete_user(params, respObj)
      if respObj.success.eql? "true"
        @users.delete "#{params[:id]}"
      end
    end

  end
end

