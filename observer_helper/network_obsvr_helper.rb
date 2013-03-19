module NetworkObsvrHelper

private
  def obsvr_create_physical_network(h_para, obj)
  end

  def obsvr_create_network(h_para, networkObj)
    # puts "FIXME : obsvr : creating network"
    networkObj.add_observer @observer
    networkObj.cs_helper = @cs_helper
    @zones["#{networkObj.zoneid}"].networks["networkObj.id"] = networkObj
  end

  def obsvr_delete_network(h_para, respObj)
    # puts "FIXME : obsvr : deleting network"
    if respObj.success.eql? "true"
      @zones["#{networkObj.zoneid}"].networks.delete "#{h_para[:id]}"
    end
  end

  def obsvr_update_network_service_provider(params, obj)
  end
end
