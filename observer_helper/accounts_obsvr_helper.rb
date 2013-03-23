module AccountsObsvrHelper

  module Domain
  private
    def obsvr_create_domain(h_para, domainObj)
      @domains["#{domainObj.id}"] = domainObj

      if domainObj.parentdomainid
        @domains["#{domainObj.parentdomainid}"].domains["#{domainObj.id}"] = domainObj
      end
    end

    def obsvr_update_domain(h_para, domainObj)
      oldObj = @domains["#{domainObj.id}"]
      SharedFunction.update_object(oldObj, domainObj)
    end

    def obsvr_delete_domain(h_para, respObj)
      if respObj.success == true
        @domains.delete h_para[:id]
        @accounts.values.each do |acc|
          if acc.domainid.eql? h_para[:id]
            acc.users.values.each do |usr|
              @users.delete usr.id
            end
            @accounts.delete acc.id
          end
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
      @users["#{_user.id}"] = _user
    end

    def obsvr_update_account(h_para, accObj)
      oldObj = @accounts["#{accObj.id}"]
      SharedFunction.update_object(oldObj, accObj)
    end

    def obsvr_delete_account(h_para, respObj)
      if respObj.success.to_s.eql? "true"
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
      # FIXME
      @users["#{respObj.id}"].state = respObj.state

    end

    def obsvr_enable_user(h_para, respObj)
      # FIXME
      @users["#{respObj.id}"].state = respObj.state
    end

    def obsvr_delete_user(h_para, respObj)
      if respObj.success.to_s.eql? "true"
        @users.delete "#{h_para[:id]}"
      end
    end
  end
end

