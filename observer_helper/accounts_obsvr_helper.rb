module AccountsObsvrHelper

private
  def create_account(h_para, accObj)
    @accounts["#{accObj.id}"] = accObj
  end
  
  def create_domain(h_para, domainObj)
    @domains["#{domainObj.id}"]=domainObj
  end

  def update_domain(h_para, domainObj)
    SharedFunction.update_object @domains["#{domainObj.id}"], domainObj
  end

  def delete_domain(h_para, resp) # aynchronous
    if resp == 1
      @domains.delete h_para[:id]
    end
  end
  
  def create_user(h_para, userObj)
    @users["#{userObj.id}"] = userObj
  end

  def update_user(h_para, userObj)
    SharedFunction.update_object @users["#{userObj.id}"], userObj
  end

  def register_user_keys(h_para, resp)
    if resp
      @keyJObj = resp['userkeys']
      @userObj = @users["#{h_para[:id]}"]
      @userObj.apikey = "#{@keyJObj['apikey']}"
      @userObj.secretkey = "#{@keyJObj['secretkey']}"
      @userObj.registerCSHelper(request_url, self)
    end
  end


  def delete_user(h_para, resp)
    if resp['success'].eql? "true"
      @userObj = @users["#{h_para[:id]}"]
      @domains["#{@userObj.domainid}"].accounts.each do |k, v|
        if v.name.eql? "#{@userObj.account}"
          v.users.delete "#{@userObj.id}"
        end
      @users.delete "#{@userObj.id}"
      end
    end
  end
end

