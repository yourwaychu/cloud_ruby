module InfraObsvrHelper

private
  def create_zone(h_para, resp)
    zoneJObj = resp['zone']
    zoneObj = SharedFunction.pack_params CloudStack::Model::Zone.new, zoneJObj
    @zones["#{zoneObj.id}"] = zoneObj
  end

  def update_zone(h_para, resp)
    zoneJObj = resp['zone']
    zoneObj = SharedFunction.pack_params CloudStack::Model::Zone.new, zoneJObj
    SharedFunction.update_object @zones["#{zoneObj.id}"], zoneObj
  end

  def delete_zone(h_para, resp)
    if resp['success'].eql? "true"
      @zones.delete h_para[:id]
    end 
  end

  def create_physical_network(h_para, resp)
    physicalNetObj = SharedFunction.pack_params\
                                    CloudStack::Model::PhysicalNetwork.new,
                                    resp['jobresult']['physicalnetwork']

    @physical_networks["#{physicalNetObj.id}"] = physicalNetObj
    @zones["#{physicalNetObj.zoneid}"].physical_networks["#{physicalNetObj.id}"]\
                                                      = physicalNetObj
  end

  def add_traffic_type(h_para, resp)
    if resp['jobstatus'] == 1
      traffictypeJObj = resp['jobresult']['traffictype']
      traffictypeObj = SharedFunction.pack_params CloudStack::Model::TrafficType.new,
                                                  traffictypeJObj
      @traffic_typs["#{traffictypeObj.id}"] = traffictypeObj
      @physical_networks["#{traffictypeObj.physicalnetworkid}"].\
      traffic_typs["#{traffictypeObj.id}"] = traffictypeObj
    end
  end
end
