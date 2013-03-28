module ServiceOfferingObsvrHelper

private
  def obsvr_create_service_offering(params, respObj)
    respObj.p_node = self
    if params[:issystem] && params[:issystem].eql(true)
      @system_offerings["#{respObj.id}"] = respObj
    else
      @compute_offerings["#{respObj.id}"] = respObj
    end
  end

  def obsvr_update_service_offering(params, respObj)
    _old_so = nil

    if params[:issystem] && params[:issystem].eql(true)
      _old_so = @system_offerings["#{respObj.id}"]
    else
      _old_so = @compute_offerings["#{respObj.id}"]
    end
    SharedFunction.update_object _old_so, respObj
  end

  def obsvr_delete_service_offering(params, respObj)
    if @system_offerings["#{params[:id]}"]
      @system_offerings.delete "#{params[:id]}"
    elsif @compute_offerings["#{params[:id]}"]
      @compute_offerings.delete "#{params[:id]}"
    end
  end

  def obsvr_create_disk_offering(params, respObj) 
    respObj.p_node = self
    @disk_offerings["#{respObj.id}"] = respObj
  end


  def obsvr_update_disk_offering(params, respObj) 
    _old_do = @disk_offerings["#{respObj.id}"]
    SharedFunction.update_object _old_do, respObj
  end

  def obsvr_delete_disk_offering(params, respObj) 
    @disk_offerings.delete params[:id]
  end

  def obsvr_create_network_offering(params, respObj)
    respObj.p_node = self
    @network_offerings["#{respObj.id}"] = respObj
  end

  def obsvr_update_network_offering(params, respObj)
    _old_do = @network_offerings["#{respObj.id}"]
    SharedFunction.update_object _old_do, respObj
  end

  def obsvr_delete_network_offering(params, respObj)
    @network_offerings.delete params[:id]
  end

end
