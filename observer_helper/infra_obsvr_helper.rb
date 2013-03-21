module InfraObsvrHelper

private
  def obsvr_create_zone(h_para, zoneObj)
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

  def obsvr_create_pod(params, podObj)
    #@pods["#{podObj.id}"] = podObj
    @zones["#{podObj.zoneid}"].pods["#{podObj.id}"] = podObj
  end

  def obsvr_create_vlan_ip_range(params, vlanObj)
    @zones["#{vlanObj.zoneid}"].pods["#{vlanObj.podid}"].vlans["#{vlanObj.id}"] = vlanObj
  end

  def obsvr_create_physical_network(h_para, pnObj)
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
    # puts "#{h_para[:physicalnetworkid]}"
    oldObj = @physical_networks["#{h_para[:physicalnetworkid]}"].network_service_providers.choose("VirtualRouter")[0].virtual_router_elements.values.to_a[0]

    SharedFunction.update_object(oldObj, vreObj)
  end


  def obsvr_enable_network_service_provider(h_para, respObj)
    oldObj = @physical_networks["#{respObj.physicalnetworkid}"].network_service_providers["#{respObj.id}"]
    SharedFunction.update_object oldObj, respObj
  end

  def obsvr_add_cluster(params, clusterList)
    clusterList.each do |clusterObj|
      @zones["#{clusterObj.zoneid}"].pods["#{clusterObj.podid}"].clusters["#{clusterObj.id}"] = clusterObj
    end
  end

  def obsvr_add_host(params, hostObjList)
    hostObjList.each do |hostObj|
      @zones["#{hostObj.zoneid}"].pods["#{hostObj.podid}"].clusters["#{hostObj.clusterid}"].hosts["#{hostObj.id}"] = hostObj
    end
  end

  def obsvr_add_traffic_type(params, response)
    
  end

  def obsvr_add_secondary_storage(h_params, stObj)
    @zones["#{stObj.zoneid}"].secondary_storages["#{stObj.id}"] = stObj
  end
end
