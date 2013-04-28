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

    def obsvr_update_domain(params, domainObj)
      oldObj = @domains["#{domainObj.id}"]
      SharedFunction.update_object(oldObj, domainObj)
    end

    def obsvr_delete_domain(params, successObj)
      _tmp = @domains["#{params[:id]}"]
      recur_delete_domain _tmp
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

    def obsvr_update_account(params, accObj)
      oldObj = @accounts["#{accObj.id}"]
      SharedFunction.update_object(oldObj, accObj)
    end

    def obsvr_delete_account(params, successObj)
      _tmp = @accounts["#{params[:id]}"]
      @accounts.delete _tmp.id
      @domains["#{_tmp.domainid}"].accounts.delete "#{_tmp.id}"
      @users.values.each do |usr|
        if usr.accountid.eql? _tmp.id
          @users.delete usr.id
        end
      end
    end
  end

  module User
  private
    def obsvr_create_user(params, userObj)
      userObj.p_node = @accounts["#{userObj.accountid}"]
      @users["#{userObj.id}"] = userObj
      @accounts["#{userObj.accountid}"].users["#{userObj.id}"] = userObj
    end

    def obsvr_update_user(params, userObj)
      oldObj = @users["#{userObj.id}"]
      SharedFunction.update_object(oldObj, userObj)
    end

    def obsvr_enable_user(params, userObj)
      oldObj = @users["#{userObj.id}"]
      SharedFunction.update_object(oldObj, userObj)
    end

    def obsvr_disable_user(params, userObj)
      oldObj = @users["#{userObj.id}"]
      SharedFunction.update_object(oldObj, userObj)
    end

    def obsvr_register_user_keys(params, keyObj)
      userObj = @users["#{params[:id]}"]
      userObj.apikey    = keyObj.apikey
      userObj.secretkey = keyObj.secretkey
    end

    def obsvr_delete_user(params, successObj)
      _tmp = @users["#{params[:id]}"]
      @users.delete "#{_tmp.id}"  
      @accounts["#{_tmp.accountid}"].users.delete "#{_tmp.id}"
    end
  end
end
