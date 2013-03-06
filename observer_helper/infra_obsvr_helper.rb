module InfraObsvrHelper

private
  def create_zone(h_para, zoneObj)
    @zones["#{zoneObj.id}"] = zoneObj
  end

  def update_zone(h_para, zoneObj)
    @zones["#{zoneObj.id}"] = zoneObj
  end

  def delete_zone(h_para, resp)
    if resp['success'].eql? "true"
      @zones.delete h_para[:id]
    end 
  end

  def create_pod(params, podObj)
    @pods["#{podObj.id}"] = podObj
  end

  def create_vlan_ip_range(params, vlanObj)
  end

  def create_physical_network(h_para, pnObj)
    @physical_networks["#{pnObj.id}"] = pnObj
  end

  def add_cluster(params, response)
  end

  def add_host(params, response)
  end

  def add_traffic_type(params, response)
    
  end

  def update_physical_network(params, response)
  end
end
