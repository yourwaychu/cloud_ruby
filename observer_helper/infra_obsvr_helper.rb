module InfraObsvrHelper

private
  def obsvr_create_zone(h_para, zoneObj)
    @zones["#{zoneObj.id}"] = zoneObj
  end

  def obsvr_model_create_zone(params, zoneObj)
    @zones["#{zoneObj.id}"] = zoneObj
  end

  def obsvr_update_zone(h_para, zoneObj)
    oldObj = @zones["#{zoneObj.id}"]
    SharedFunction.update_object(oldObj, zoneObj)
  end

  def obsvr_delete_zone(h_para, resp)
    if resp.success.eql? "true"
      @zones.delete h_para[:id]
    end 
  end

  def obsvr_model_delete_zone(h_para, resp)
    @zones.delete h_para[:id]
  end

  def obsvr_create_pod(params, podObj)
    @pods["#{podObj.id}"] = podObj
    _zone = @zones["#{podObj.zoneid}"]
    podObj.p_node = _zone
    _zone.pods["#{podObj.id}"] = podObj
  end

  def obsvr_model_create_pod(params, podObj)
    @pods["#{podObj.id}"] = podObj
  end

  def obsvr_delete_pod(params, respObj)
    _pod = @pods["#{params[:id]}"]
    @pods.delete _pod.id
    @zones["#{_pod.zoneid}"].pods.delete "#{_pod.id}"
  end

  def obsvr_create_vlan_ip_range(params, vlanObj)
    @vlans["#{vlanObj.id}"] = vlanObj
    _pod = @pods["#{vlanObj.podid}"]
    vlanObj.p_node = _pod
    @zones["#{vlanObj.zoneid}"].pods["#{vlanObj.podid}"].vlans["#{vlanObj.id}"] = vlanObj
  end

  def obsvr_delete_vlan_ip_range(params, respObj)
    _vlan = @vlans["#{params[:id]}"] 
    _pod  = @pods["#{_vlan.podid}"]
    @vlans.delete "#{_vlan.id}"
    _pod.vlans.delete "#{_vlan.id}"
  end
  
  def obsvr_model_delete_vlan_ip_range(params, respObj)
    _vlan = @vlans["#{params[:id]}"] 
    _pod  = @pods["#{_vlan.podid}"]
    @vlans.delete "#{_vlan.id}"
  end

  def obsvr_model_create_vlan_ip_range(params, vlanObj)
    @vlans["#{vlanObj.id}"] = vlanObj
  end

  def obsvr_model_create_physical_network(h_para, pnObj)
    @physical_networks["#{pnObj.id}"] = pnObj
    zoneObj = @zones["#{pnObj.zoneid}"]
    zoneObj.physical_networks.merge!({"#{pnObj.id}" => pnObj})
    @vr_networkserviceproviders = @root_admin.list_network_service_providers :name => "VirtualRouter",
                                                                             :physicalnetworkid  => "#{pnObj.id}"

    @sg_networkserviceproviders = @root_admin.list_network_service_providers :name => "SecurityGroupProvider",
                                                                             :physicalnetworkid  => "#{pnObj.id}"

    @vr_networkserviceproviders.each do |vrsp|

      @virtualrouterelements = @root_admin.list_virtual_router_elements :nspid => "#{vrsp.id}"

      @virtualrouterelements.each do |vre|
        vre.physicalnetworkid = pnObj.id
        vrsp.virtual_router_elements["#{vre.id}"] = vre
      end
        
      pnObj.network_service_providers["#{vrsp.id}"] = vrsp
    end

    @sg_networkserviceproviders.each do |sgsp|
      pnObj.network_service_providers["#{sgsp.id}"] = sgsp
    end
    @physical_networks["#{pnObj.id}"] = pnObj
  end

  def obsvr_create_physical_network(h_para, pnObj)
    @physical_networks["#{pnObj.id}"] = pnObj
    zoneObj = @zones["#{pnObj.zoneid}"]
    pnObj.p_node = zoneObj
    zoneObj.physical_networks.merge!({"#{pnObj.id}" => pnObj})
    @vr_networkserviceproviders = @root_admin.list_network_service_providers :name => "VirtualRouter",
                                                                          :physicalnetworkid  => "#{pnObj.id}"

    @sg_networkserviceproviders = @root_admin.list_network_service_providers :name => "SecurityGroupProvider",
                                                                             :physicalnetworkid  => "#{pnObj.id}"

    @vr_networkserviceproviders.each do |vrsp|


      @virtualrouterelements = @root_admin.list_virtual_router_elements :nspid => "#{vrsp.id}"

      @virtualrouterelements.each do |vre|
        vre.physicalnetworkid = pnObj.id
        vrsp.virtual_router_elements["#{vre.id}"] = vre
      end
        
      pnObj.network_service_providers["#{vrsp.id}"] = vrsp
    end

    @sg_networkserviceproviders.each do |sgsp|
      pnObj.network_service_providers["#{sgsp.id}"] = sgsp
    end
    @physical_networks["#{pnObj.id}"] = pnObj
  end

  def obsvr_delete_physical_network(h_para, pnObj)
    pnObj = @physical_networks["#{h_para[:id]}"] 
    @physical_networks.delete pnObj.id
    @zones["#{pnObj.zoneid}"].physical_networks.delete pnObj.id
  end

  def obsvr_update_physical_network(h_para, pnObj)
    oldObj = @physical_networks["#{h_para[:id]}"]
    SharedFunction.update_object(oldObj, pnObj)
  end

  def obsvr_configure_virtual_router_element(h_para, vreObj)
    oldObj = @physical_networks["#{h_para[:physicalnetworkid]}"].network_service_providers.choose("VirtualRouter")[0].virtual_router_elements.values.to_a[0]

    SharedFunction.update_object(oldObj, vreObj)
  end


  def obsvr_enable_network_service_provider(h_para, respObj)
    oldObj = @physical_networks["#{respObj.physicalnetworkid}"].network_service_providers["#{respObj.id}"]
    SharedFunction.update_object oldObj, respObj
  end

  def obsvr_add_cluster(params, clusterList)
    _pod = @pods["#{clusterList[0].podid}"]
    clusterList.each do |clusterObj|
      clusterObj.p_node = _pod
      @clusters["#{clusterObj.id}"] = clusterObj
      @zones["#{clusterObj.zoneid}"].pods["#{clusterObj.podid}"].clusters["#{clusterObj.id}"] = clusterObj
    end
  end

  def obsvr_model_add_cluster(params, clusterList)
    clusterList.each do |clusterObj|
      @clusters["#{clusterObj.id}"] = clusterObj
    end
  end

  def obsvr_delete_cluster(params, respObj)
    _cluster = @clusters["#{params[:id]}"]
    @clusters.delete "#{_cluster.id}" 
    @pods["#{_cluster.podid}"].clusters.delete "#{_cluster.id}"
  end

  def obsvr_model_delete_cluster(params, respObj)
    _cluster = @clusters["#{params[:id]}"]
    @clusters.delete "#{_cluster.id}" 
  end

  def obsvr_add_host(params, hostObjList)
    _cluster = @clusters["#{hostObjList[0].clusterid}"]
    hostObjList.each do |hostObj|
      hostObj.p_node = _cluster
      @hosts["#{hostObj.id}"] = hostObj
      @zones["#{hostObj.zoneid}"].pods["#{hostObj.podid}"].clusters["#{hostObj.clusterid}"].hosts["#{hostObj.id}"] = hostObj
    end
  end

  def obsvr_model_add_host(params, hostLists)
    hostLists.each do |hostObj|
      @hosts["#{hostObj.id}"] = hostObj
    end
  end

  def obsvr_delete_host(params, respObj)
    _host = @hosts["#{params[:id]}"]
    _cluster = @clusters["#{_host.clusterid}"]
    if _cluster
      @hosts.delete "#{_host.id}"
      _cluster.hosts.delete "#{_host.id}"
    end
    
    if @secondary_storages["#{_host.id}"]
      @zones["#{_host.zoneid}"].secondary_storages.delete "#{_host.id}"
      @secondary_storages.delete "#{_host.id}"
    end
  end


  def obsvr_model_delete_host(params, respObj)
    _host = @hosts["#{params[:id]}"]
    @hosts.delete "#{_host.id}"
    @cluster["#{_host.clusterid}"].hosts.delete "#{_host.id}"
  end

  def obsvr_add_traffic_type(params, response)
    _pnObj = @physical_networks["#{response.physicalnetworkid}"]
    response.p_node = _pnObj
    _pnObj.traffic_types["#{response.id}"] = response
  end

  def obsvr_model_create_storage_pool(params, response)
    @storage_pools["#{resposne.id}"] = response
  end

  def obsvr_model_delete_storage_pool(params, response)
    _sp_obj = @storage_pools["#{params[:id]}"]
    @storage_pools.delete "#{_sp_obj.id}"
  end

  def obsvr_add_secondary_storage(h_params, stObj)
    _zone = @zones["#{stObj.zoneid}"]
    stObj.p_node = _zone
    @secondary_storages["#{stObj.id}"] = stObj
    @hosts["#{stObj.id}"] = stObj
    @zones["#{stObj.zoneid}"].secondary_storages["#{stObj.id}"] = stObj
  end

  def obsvr_delete_secondary_storage(params, respObj)
    _scObj = @secondary_storages["#{params[:id]}"]
    @secondary_storages.delete "#{_scObj.id}"
  end
end
