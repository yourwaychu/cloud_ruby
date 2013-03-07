module AccountsObsvrHelper

private
  def create_account(h_para, accObj)
    @accounts["#{accObj.id}"] = accObj
  end
  
  def create_domain(h_para, domainObj)
    @domains["#{domainObj.id}"]=domainObj
  end

  def update_domain(h_para, domainObj)
    @domains["#{domainObj.id}"] = domainObj
  end

  def delete_domain(h_para, respObj) # aynchronous
    if respObj.success == true
      @domains.delete h_para[:id]
    end
  end
  
  def update_account(h_para, accObj)
    @accounts["#{accObj.id}"] = accObj
  end

  def delete_account(h_para, respObj)
    if respObj.success.to_s.eql? "true"
      @accounts.delete "#{h_para[:id]}"
    end
  end

  def create_user(h_para, userObj)
    @users["#{userObj.id}"] = userObj
  end

  def update_user(h_para, userObj)
    @users["#{userObj.id}"] = userObj
  end

  def register_user_keys(h_para, keyObj)
      @userObj = @users["#{h_para[:id]}"]
      @userObj.apikey = "#{keyObj.apikey}"
      @userObj.secretkey = "#{keyObj.secretkey}"
      @userObj.registerCSHelper request_url, self
  end


  def delete_user(h_para, respObj)
    if respObj.success.to_s.eql? "true"
      @users.delete "#{h_para[:id]}"
    end
  end
end

