module ServiceOfferingObsvrHelper

private
  def create_service_offering(h_para, respObj)
    if respObj
      @service_offerings["#{respObj.id}"] = respObj
    end
  end

  def update_service_offering(h_para, respObj)
    if respObj
      @service_offerings["#{respObj.id}"] = respObj
    end
  end

  def delete_service_offering(h_para, respObj)
    if respObj.success.eql? "true"
      @service_offerings.delete h_para[:id]
    end
  end

  def create_disk_offering(h_para, respObj) 
    if respObj
      @disk_offerings["#{respObj.id}"] = respObj
    end
  end


  def update_disk_offering(h_para, respObj) 
    if respObj
      @disk_offerings["#{respObj.id}"] = respObj
    end
  end

  def delete_disk_offering(h_para, respObj) 
    if respObj.success.eql? "true"
      @disk_offerings.delete h_para[:id]
    end
  end
end
