module AccountObsvrHelper

private
  def create_account(h_para, resp)
    accJObj = resp['account']
    accObj = SharedFunction.pack_params CloudStack::Model::Account.new, accJObj
    userObj = SharedFunction.pack_params CloudStack::Model::User.new, accJObj['user'][0]
    accObj.users["#{userObj.id}"] = userObj
    @domains["#{accJObj['domainid']}"].accounts["#{accJObj['id']}"] = accObj
    @accounts["#{accObj.id}"] = accObj
    @users["#{userObj.id}"] = userObj
  end

  def update_account(h_para, resp)
    accJObj = resp['account']
    userJObj = resp['account']['user'][0]
    accObj = SharedFunction.pack_params CloudStack::Model::Account.new, accJObj
    userObj = SharedFunction.pack_params CloudStack::Model::User.new, userJObj
    SharedFunction.update_object @accounts["#{accObj.id}"], accObj
    SharedFunction.update_object @users["#{userObj.id}"], userObj
  end 

  def delete_account(h_para, resp) #asynchronous
    if resp['jobstatus'] == 1
      accObj = @accounts["#{h_para[:id]}"]
      domainObj = @domains["#{accObj.domainid}"]
      domainObj.accounts.delete accObj.id
      accObj.users.each do |k, v|
        @users.delete v.id
      end
      @accounts.delete h_para[:id] 
    end
  end

end

