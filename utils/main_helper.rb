module CloudStackMainHelper

private
  def register_root_admin
    listuserresponse = RestClient.send(
                                    :get,
                                    "#{@admin_request_url}?" +
                                    "command=listUsers&" +
                                    "username=admin&response=json")

    adminObj = JSON.parse(listuserresponse)['listusersresponse']['user'][0]


    registeruserkeyresponse = RestClient.send(
                                           :get,
                                           "#{@admin_request_url}?" +
                                           "command=registerUserKeys&"+
                                           "id=#{adminObj['id']}&"+
                                           "response=json")
    adminkeyObj = JSON.parse(
           registeruserkeyresponse)['registeruserkeysresponse']['userkeys']
    
    listuserresponse = RestClient.send(
                                    :get,
                                    "#{@admin_request_url}?" +
                                    "command=listUsers&" +
                                    "username=admin&response=json")

    adminJObj = JSON.parse(listuserresponse)['listusersresponse']['user'][0]

    @root_admin = CloudStack::Model::Admin.new adminJObj
    @root_admin.add_observer @observer
    @root_admin.registerCSHelper(request_url, self)
  end
  
  def update_env
    update_env_domains
    update_env_accounts
    update_env_users
    update_env_zones
    update_env_pods
    update_env_clusters
    update_env_hosts
    update_env_networkofferings
  end
  
  def update_env_networkofferings
    resultObjs = @root_admin.list_network_offerings :listall => true
    resultObjs.each do |obj|
      @networkofferings["#{obj.id}"] = obj
    end
  end
  

  def update_env_domains
    resultObjs = @root_admin.list_domains :listall=>true

    resultObjs.each do |obj|
      @domains["#{obj.id}"] = obj
    end
  end
     
  def update_env_accounts
    resultObjs = @root_admin.list_accounts :listall=>true

    resultObjs.each do |obj|
      @accounts["#{obj.id}"] = obj
    end
  end
  
  def update_env_users
    resultObjs = @root_admin.list_users :listall=>true

    resultObjs.each do |obj|
      @users["#{obj.id}"] = obj
    end
  end

  def update_env_zones
    resultObjs = @root_admin.list_zones :listall => true
    resultObjs.each do |obj|
      @zones["#{obj.id}"] = obj
    end
  end

  def update_env_pods
    resultObjs = @root_admin.list_pods :listall => true
    resultObjs.each do |obj|
      @pods["#{obj.id}"] = obj
    end
  end 

  def update_env_clusters
    resultObjs = @root_admin.list_clusters :listall => true
    resultObjs.each do |obj|
      @clusters["#{obj.id}"] = obj
    end
  end

  def update_env_hosts
    resultObjs = @root_admin.list_hosts :listall => true
    resultObjs.each do |obj|
      @hosts["#{obj.id}"] = obj
    end
  end
end
