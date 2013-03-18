module InfraObsvrHelper

private
  def obsvr_create_zone(h_para, zoneObj)
    zoneObj.add_observer @observer
    zoneObj.cs_helper = @cs_helper
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
    @pods["#{podObj.id}"] = podObj
  end

  def obsvr_create_vlan_ip_range(params, vlanObj)
  end

  def obsvr_create_physical_network(h_para, pnObj)
    pnObj.add_observer @observer
    pnObj.cs_helper = @cs_helper
    zoneObj = @zones["#{pnObj.zoneid}"]
    zoneObj.physical_networks.merge!({"#{pnObj.id}" => pnObj})
    @vr_networkserviceproviders = @root_admin.list_network_service_providers :name => "VirtualRouter",
                                                                          :physicalnetworkid  => "#{pnObj.id}"

    @sg_networkserviceproviders = @root_admin.list_network_service_providers :name => "SecurityGroupProvider",
                                                                          :physicalnetworkid  => "#{pnObj.id}"

    @vr_networkserviceproviders.each do |vrsp|

      vrsp.add_observer @observer
      vrsp.cs_helper = @cs_helper

      @virtualrouterelements = @root_admin.list_virtual_router_elements :nspid => "#{vrsp.id}"

      @virtualrouterelements.each do |vre|
        vre.physicalnetworkid = pnObj.id
        vre.add_observer @observer
        vre.cs_helper = @cs_helper
        vrsp.virtual_router_elements["#{vre.id}"] = vre
      end
        
      pnObj.network_service_providers["#{vrsp.id}"] = vrsp
    end

    @sg_networkserviceproviders.each do |sgsp|
      sgsp.add_observer @observer
      sgsp.cs_helper = @cs_helper
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

  def obsvr_add_cluster(params, response)
  end

  def obsvr_add_host(params, response)
  end

  def obsvr_add_traffic_type(params, response)
    
  end
end
