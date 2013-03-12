module CloudStackMainHelper

  def deploy(*args)
    _deploy_config = YAML.load_file "#{args[0]}"
    _deploy_config.each do |config|
      case config[0]
      when /accounts/i
        format_logger ["Parsing Accounts..."]
        config[1]["domains"].each do |domain|
        end
      when /infrastructure/i
        format_logger ["Parsing Infrastructure..."]
        config[1]["zones"].each do |zone|
          networktype   = zone["networktype"] 
          dns1          = zone["public_dns1"]
          dns2          = zone["public_dns2"]
          internal_dns1 = zone["internal_dns1"]
          internal_dns2 = zone["internal_dns2"]
          hypervisor    = zone["hypervisor"]
          zonename      = zone["name"]
          local_storage = zone["local_storage"]

          # create domain
          zone = @root_admin.create_zone :name => "#{zonename}",
                                         :dns1 => "#{dns1}",
                                         :dns2 => "#{dns2}",
                                         :internaldns1 => "#{internal_dns1}",
                                         :internaldns1 => "#{internal_dns2}",
                                         :networktype => "#{networktype}",
                                         :localstorageenabled => "#{local_storage}"
          # create physical network
          zone.create_physical_network :name => "Physical Network 1"

        end
      else
        puts "Error!"
      end
    end
  end
private
  def register_root_admin
    listuserresponse = RestClient.send(:get,
                                       "#{@admin_request_url}?" +
                                       "command=listUsers&" +
                                       "username=admin&response=json")

    @root_admin = CloudStack::Model::Admin.new JSON.parse(listuserresponse)['listusersresponse']['user'][0]


    if !@root_admin.apikey
      registeruserkeyresponse = RestClient.send(:get,
                                                "#{@admin_request_url}?" +
                                                "command=registerUserKeys&"+
                                                "id=#{@root_admin.id}&"+
                                                "response=json")


      adminkeyObj = CloudStack::Model::UserKeys.new JSON.parse(registeruserkeyresponse)['registeruserkeysresponse']['userkeys']

      @root_admin.apikey      = adminkeyObj.apikey
      @root_admin.secretkey   = adminkeyObj.secretkey
    end

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
    update_env_network_offerings
    update_env_service_offerings
    update_env_disk_offerings
    update_env_system_vms
  end

  def update_env_system_vms
    resultObjs = @root_admin.list_system_vms
    resultObjs.each do |obj|
      @systemvms["#{obj.id}"] = obj
    end
  end
  def update_env_disk_offerings
    resultObjs = @root_admin.list_disk_offerings
    resultObjs.each do |obj|
      @disk_offerings["#{obj.id}"] = obj
    end
  end

  def update_env_service_offerings
    resultObjs = @root_admin.list_service_offerings
    resultObjs.each do |obj|
      @service_offerings["#{obj.id}"] = obj
    end
  end

  
  def update_env_network_offerings
    resultObjs = @root_admin.list_network_offerings :listall => true
    resultObjs.each do |obj|
      @network_offerings["#{obj.id}"] = obj
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

  def format_logger(params) 
    # action, action target, in what step
    if params[0] && params[1] && params[2]
      puts "%-40s: %-30s -- %-10s" % params
    elsif params[0] && params[1]
      puts "%-40s: %-30s" % params
    elsif params[0]
      puts "%-40s" % params
    end
  end
  
  
end
