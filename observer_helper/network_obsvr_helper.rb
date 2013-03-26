module NetworkObsvrHelper

private

  def obsvr_create_network(h_para, networkObj)
    @networks["#{networkObj.id}"] = networkObj
    @zones["#{networkObj.zoneid}"].networks["#{networkObj.id}"] = networkObj
  end

  def obsvr_model_create_network(params, networkObj)
  end

  def obsvr_delete_network(h_para, networkObj)
    _network = @networks["#{h_para[:id]}"]
    @networks.delete "#{_network.id}"
    @zones["#{_network.zoneid}"].networks.delete "#{_network.id}"
  end

  def obsvr_update_network_service_provider(params, obj)
  end
end
