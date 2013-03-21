module NetworkObsvrHelper

private
  def obsvr_create_physical_network(h_para, obj)
  end

  def obsvr_create_network(h_para, networkObj)
    @zones["#{networkObj.zoneid}"].networks["networkObj.id"] = networkObj
  end

  def obsvr_delete_network(h_para, respObj)
    if respObj.success.eql? "true"
      @zones["#{networkObj.zoneid}"].networks.delete "#{h_para[:id]}"
    end
  end

  def obsvr_update_network_service_provider(params, obj)
  end
end
