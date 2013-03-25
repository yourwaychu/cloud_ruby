module NetworkObsvrHelper

private
  def obsvr_create_physical_network(h_para, obj)
  end

  def obsvr_create_network(h_para, networkObj)
    @zones["#{networkObj.zoneid}"].networks["#{networkObj.id}"] = networkObj
  end

  def obsvr_delete_network(h_para, respObj)
  end

  def obsvr_update_network_service_provider(params, obj)
  end
end
