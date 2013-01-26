module ServiceOfferingObsvrHelper

private
  def create_service_offering(h_para, resp)
    serviceOfferJObj = resp['serviceoffering']
    serviceOfferObj = SharedFunction.pack_params CloudStack::Model::ServiceOffering.new, serviceOfferJObj
    @serviceofferings["#{serviceOfferObj.id}"] = serviceOfferObj
  end

  def update_service_offering(h_para, resp)
    serviceOfferJObj = resp['serviceoffering']
    serviceOfferObj = SharedFunction.pack_params CloudStack::Model::ServiceOffering.new, serviceOfferJObj

    SharedFunction.update_object @serviceofferings["#{serviceOfferObj.id}"], serviceOfferObj
  end

  def delete_service_offering(h_para, resp)
    if resp['success'].eql? "true"
      @serviceofferings.delete h_para[:id]
    end
  end
end
