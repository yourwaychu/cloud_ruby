
module UserObsvrHelper

private
  def create_user(h_para, resp)
    userJObj = resp['user']
    userObj = SharedFunction.pack_params CloudStack::Model::User.new, userJObj
    @domains["#{userObj.domainid}"].accounts.each do |k, v|
      if v.name.eql? "#{userObj.account}"
        v.users["#{userObj.id}"] = userObj
      end
    end
    @users["#{userObj.id}"] = userObj
  end

  def update_user(h_para, resp)
    userJObj = resp['user']
    userObj = SharedFunction.pack_params CloudStack::Model::User.new, userJObj
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


