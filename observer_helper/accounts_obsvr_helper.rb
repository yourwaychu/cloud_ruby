module AccountsObsvrHelper

  module Domain
  private
    def obsvr_create_domain(params, domainObj)
      @domains["#{domainObj.id}"] = domainObj
      if domainObj.parentdomainid
        domainObj.p_node = @domains["#{domainObj.parentdomainid}"]
        @domains["#{domainObj.parentdomainid}"].domains["#{domainObj.id}"] = domainObj
      end
    end

    def obsvr_model_create_domain(params, domainObj)
      @domains["#{domainObj.id}"] = domainObj
    end

    def obsvr_update_domain(params, domainObj)
      oldObj = @domains["#{domainObj.id}"]
      SharedFunction.update_object(oldObj, domainObj)
    end

    def obsvr_delete_domain(params, respObj)
      if @domains["#{params[:id]}"]
        recur_delete_domain @domains["#{params[:id]}"]
      end
    end
    
    def recur_delete_domain(dobj)
      if dobj.domains.length != 0
        dobj.domains.each do |k, subdobj|
          recur_delete_domain subdobj
        end
      end
      
      @accounts.values.each do |acc|
        if acc.domainid.eql? dobj.id
          acc.users.each do |k, usr|
            @users.delete usr.id
          end
          @accounts.delete acc.id
        end
       end
       @domains["#{dobj.parentdomainid}"].domains.delete dobj.id unless dobj.parentdomainid == nil
       @domains.delete dobj.id    
    end

    def obsvr_model_delete_domain(params, respObj)
      if @domains["#{params[:id]}"]
        recur_delete_domain @domains["#{params[:id]}"]
      end
    end
  end

  module Account
  private
    def obsvr_create_account(params, accObj)
      accObj.p_node = @domains["#{accObj.domainid}"]
      
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

    def obsvr_update_account(params, accObj)
      oldObj = @accounts["#{accObj.id}"]
      SharedFunction.update_object(oldObj, accObj)
    end

    def obsvr_delete_account(params, respObj)
      @accounts.delete "#{params[:id]}"
      @users.values.each do |usr|
        if usr.accountid.eql? params[:id]
          @users.delete usr.id
        end
      end
    end
    
    def obsvr_model_delete_account(params, respObj)
      @accounts.delete "#{params[:id]}"
      @users.values.each do |usr|
        if usr.accountid.eql? params[:id]
          @users.delete usr.id
        end
      end
    end
    
  end

  module User
  private
    def obsvr_create_user(params, user_obj)
      user_obj.p_node = @accounts["#{user_obj.accountid}"]
      
      @users["#{user_obj.id}"] = user_obj

      @accounts["#{user_obj.accountid}"].users["#{user_obj.id}"] = user_obj
    end

    def obsvr_model_create_user(params, user_obj)
      @users["#{user_obj.id}"] = user_obj
    end

    def obsvr_update_user(params, user_obj)
      oldObj = @users["#{user_obj.id}"]
      SharedFunction.update_object(oldObj, user_obj)
    end

    def obsvr_register_user_keys(params, keyObj)
      @userObj = @users["#{params[:id]}"]
      @userObj.apikey = "#{keyObj.apikey}"
      @userObj.secretkey = "#{keyObj.secretkey}"
      @userObj.registerCSHelper request_url, self
    end

    def obsvr_disable_user(params, respObj)
      @users["#{respObj.id}"].state = respObj.state
    end

    def obsvr_enable_user(params, respObj)
      @users["#{respObj.id}"].state = respObj.state
    end

    def obsvr_delete_user(params, respObj)
      user_obj = @users["#{params[:id]}"]
      @domains["#{user_obj.do}"].accounts["#{user_obj.accountid}"].delete "#{user_obj.id}"
      @users.delete "#{user_obj.id}"
    end

    def obsvr_model_delete_user(params, respObj)
      @users.delete "#{params[:id]}"
    end

  end
end

