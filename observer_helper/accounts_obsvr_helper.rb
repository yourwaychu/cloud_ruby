module AccountsObsvrHelper

  module Domain
  private
    def obsvr_create_domain(h_para, domainObj)
      #domainObj.add_observer @observer
      @domains["#{domainObj.id}"]=domainObj
    end

    def obsvr_update_domain(h_para, domainObj)
      @domains["#{domainObj.id}"] = domainObj
    end

    def obsvr_delete_domain(h_para, respObj) # aynchronous
      if respObj.success == true
        @domains.delete h_para[:id]
      end
    end
  end

  module Account
  private
    def obsvr_create_account(h_para, accObj)
      @accounts["#{accObj.id}"] = accObj
    end

    def obsvr_update_account(h_para, accObj)
      @accounts["#{accObj.id}"] = accObj
    end

    def obsvr_delete_account(h_para, respObj)
      if respObj.success.to_s.eql? "true"
        @accounts.delete "#{h_para[:id]}"
      end
    end
  end

  module User
  private
    def obsvr_create_user(h_para, userObj)
      @users["#{userObj.id}"] = userObj
    end

    def obsvr_update_user(h_para, userObj)
      @users["#{userObj.id}"] = userObj
    end

    def obsvr_register_user_keys(h_para, keyObj)
        @userObj = @users["#{h_para[:id]}"]
        @userObj.apikey = "#{keyObj.apikey}"
        @userObj.secretkey = "#{keyObj.secretkey}"
        @userObj.registerCSHelper request_url, self
    end


    def obsvr_delete_user(h_para, respObj)
      if respObj.success.to_s.eql? "true"
        @users.delete "#{h_para[:id]}"
      end
    end
  end
end

