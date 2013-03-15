module ServiceOfferingObsvrHelper

private
  def obsvr_create_service_offering(h_para, respObj)
    if respObj
      @service_offerings["#{respObj.id}"] = respObj
    end
  end

  def obsvr_update_service_offering(h_para, respObj)
    if respObj
      @service_offerings["#{respObj.id}"] = respObj
    end
  end

  def obsvr_delete_service_offering(h_para, respObj)
    if respObj.success.eql? "true"
      @service_offerings.delete h_para[:id]
    end
  end

  def obsvr_create_disk_offering(h_para, respObj) 
    if respObj
      @disk_offerings["#{respObj.id}"] = respObj
    end
  end


  def obsvr_update_disk_offering(h_para, respObj) 
    if respObj
      @disk_offerings["#{respObj.id}"] = respObj
    end
  end

  def obsvr_delete_disk_offering(h_para, respObj) 
    if respObj.success.eql? "true"
      @disk_offerings.delete h_para[:id]
    end
  end
end
