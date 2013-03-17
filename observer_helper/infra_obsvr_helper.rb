module InfraObsvrHelper

private
  def obsvr_create_zone(h_para, zoneObj)
    @zones["#{zoneObj.id}"] = zoneObj
  end

  def obsvr_update_zone(h_para, zoneObj)
    @zones["#{zoneObj.id}"] = zoneObj
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
    @physical_networks["#{pnObj.id}"] = pnObj
  end

  def obsvr_add_cluster(params, response)
  end

  def obsvr_add_host(params, response)
  end

  def obsvr_add_traffic_type(params, response)
    
  end

  def obsvr_update_physical_network(params, response)
  end
end
