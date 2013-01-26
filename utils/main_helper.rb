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
    adminObj = JSON.parse(listuserresponse)['listusersresponse']['user'][0]

    @root_admin = SharedFunction.pack_params CloudStack::Model::Admin.new, adminObj
    @root_admin.add_observer @observer
    @root_admin.registerCSHelper(request_url, self)
  end
  
  def update_env_domains
    resp = @root_admin.list_domains :listall=>true
    if resp['domain']
      resp['domain'].each do |dom|
        domainObj = SharedFunction.pack_params CloudStack::Model::Domain.new, dom
        @domains["#{domainObj.id}"]=domainObj
      end
    end
  end
    
  def update_env_accounts
    resp = @root_admin.list_accounts :listall=>true
    if resp['account']
      resp['account'].each_with_index do |acc, idx|
        accountObj = SharedFunction.pack_params CloudStack::Model::Account.new, acc
        @accounts["#{accountObj.id}"] = accountObj
        @domains["#{acc['domainid']}"].accounts["#{accountObj.id}"] = accountObj
      end
    end
  end

  def update_env_users
    resp = @root_admin.list_users :listall=>true
    if resp['user']
      resp['user'].each do |user|
        userObj = SharedFunction.pack_params CloudStack::Model::User.new, user 
        userObj.registerCSHelper(request_url, self)
        userObj.add_observer @observer
        @users["#{userObj.id}"] = userObj
        @accounts["#{user['accountid']}"].users["#{userObj.id}"] = userObj
      end
    end
  end

  def update_env_network_offerings
    resp = @root_admin.list_network_offerings :listall=>true 
    if resp['networkoffering']
      resp['networkoffering'].each do |netoffer|
        netOfferObj = SharedFunction.pack_params CloudStack::Model::NetworkOffering.new, netoffer
        @networkofferings["#{netOfferObj.id}"] = netOfferObj 

        netoffer['service'].each do |netservice|
          netservObj = SharedFunction.pack_params CloudStack::Model::NetworkOfferingService.new,\
                                                                netservice
          netOfferObj.services["#{netservObj.name}"] = netservObj

          netservice['provider'].each do |netprovider|
            netprovObj = SharedFunction.pack_params CloudStack::Model::NetworkOfferingServiceProvider.new, netprovider
            netservObj.providers["#{netservObj.name}"] = netprovObj
          end
        end
      end
    end
  end

  def update_env_disk_offerings
    resp = @root_admin.list_disk_offerings :listall=>true
    if resp['diskoffering']
      resp['diskoffering'].each do |diskoffer|
        diskOfferObj = SharedFunction.pack_params CloudStack::Model::DiskOffering.new, diskoffer
        @diskofferings["#{diskOfferObj.id}"] = diskOfferObj
      end
    end
  end

  def update_env_service_offerings
    resp = @root_admin.list_service_offerings :listall=>true
    if resp['serviceoffering']
      resp['serviceoffering'].each do |serviceOffer|
        serviceOfferObj = SharedFunction.pack_params CloudStack::Model::ServiceOffering.new, serviceOffer
        @serviceofferings["#{serviceOfferObj.id}"] = serviceOfferObj
      end
    end
  end

  def update_env_zones
    resp = @root_admin.list_zones :listall=>true
    if resp['zone']
      resp['zone'].each do |zone|
        zoneObj = SharedFunction.pack_params CloudStack::Model::Zone.new, zone
        @zones["#{zoneObj.id}"] = zoneObj
      end
    end
  end
  
  def update_env_pods
    resp = @root_admin.list_pods
    if resp['pod']
      resp['pod'].each do |pod|
        podObj = SharedFunction.pack_params CloudStack::Model::Pod.new, pod
        @pods["#{podObj.id}"] = podObj
        @zones["#{podObj.zoneid}"].pods["#{podObj.id}"] = podObj
      end
    end
  end
  
  def update_env_clusters
    resp = @root_admin.list_clusters
    if resp['cluster']
      resp['cluster'].each do |cluster|
        clusterObj = SharedFunction.pack_params CloudStack::Model::Cluster.new, cluster
        @clusters["#{clusterObj.id}"] = clusterObj
        @pods["#{clusterObj.podid}"].clusters["#{clusterObj.id}"] = clusterObj
      end
    end
  end
  
  def update_env_hosts
    resp = @root_admin.list_hosts
    if resp['host']
      resp['host'].each do |host|
        hostObj = SharedFunction.pack_params CloudStack::Model::Host.new, host
        @hosts["#{hostObj.id}"] = hostObj
				if !hostObj.clusterid.nil?
					@clusters["#{hostObj.clusterid}"].hosts["#{hostObj.id}"] = hostObj
				end
      end
    end
  end
  
  def update_env_uservms
  end
  
  def update_env_ssvms
  end
  
  def update_env_pristorages
  end
  
  def update_env_secstorages
  end
  
  def update_env_vrouters
  end
  
  def update_env_templates
    resp = @root_admin.list_templates :templatefilter=>"all"
    if resp['template']
      resp['template'].each do |tmpl|
        tmplObj = SharedFunction.pack_params CloudStack::Model::Template.new, tmpl
        @templates["#{tmplObj.id}"] = tmplObj
      end
    end
  end
  
end
