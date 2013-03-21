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
          # networktype   = zone["networktype"] 
          # dns1          = zone["public_dns1"]
          # dns2          = zone["public_dns2"]
          # internal_dns1 = zone["internal_dns1"]
          # internal_dns2 = zone["internal_dns2"]
          # hypervisor    = zone["hypervisor"]
          # zonename      = zone["name"]
          # local_storage = zone["local_storage"]
          self.create_zone zone
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

    @root_admin = CloudStack::Model::Admin.new(JSON.parse(listuserresponse)['listusersresponse']['user'][0], @cs_helper, @model_observer)


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

    @root_admin.registerCSHelper(request_url, self)
    @cs_agent = @root_admin.cs_helper
  end

  def update_env
    update_env_accounts
    update_env_infra
    update_env_network_offerings
    update_env_service_offerings
    update_env_disk_offerings
    # update_env_system_vms
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
  

  def update_env_accounts
    _domains = @root_admin.list_domains :listall => true
    _domains.each do |dobj|
      _accounts = @root_admin.list_accounts :domainid => "#{dobj.id}"
      _accounts.each do |aobj|
        _users = @root_admin.list_users :accountid => "#{aobj.id}"
        _users.each do |uobj|
          aobj.users["#{uobj.id}"] = uobj
          @users["#{uobj.id}"] = uobj
        end
        dobj.accounts["#{aobj.id}"] = aobj
        @accounts["#{aobj.id}"] = aobj
      end
      @domains["#{dobj.id}"] = dobj
    end
  end

  def update_env_infra
    _zones = @root_admin.list_zones :listall => true
    _zones.each do |zoneobj|
      @zones["#{zoneobj.id}"] = zoneobj
      _pnets = @root_admin.list_physical_networks :zoneid => "#{zoneobj.id}"
      _pnets.each do |pnetobj|
        _traffic_types = @root_admin.list_traffic_types :physicalnetworkid => "#{pnetobj.id}"
        _traffic_types.each do |trafobj|
          pnetobj.traffic_types["#{trafobj.id}"] = trafobj
        end
        zoneobj.physical_networks["#{pnetobj.id}"] = pnetobj
          
      end
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
