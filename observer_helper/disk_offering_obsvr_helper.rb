module DiskOfferingObsvrHelper

private
  def create_disk_offering(h_para, resp)
    diskOfferJObj = resp['diskoffering']
    diskOfferObj = SharedFunction.pack_params CloudStack::Model::DiskOffering.new,\
                                                           diskOfferJObj
    @diskofferings["#{diskOfferObj.id}"] = diskOfferObj
  end

  def update_disk_offering(h_para, resp)
    diskOfferJObj = resp['diskoffering']
    diskOfferObj = SharedFunction.pack_params CloudStack::Model::DiskOffering.new,\
                                                           diskOfferJObj

    SharedFunction.update_object @diskofferings["#{diskOfferObj.id}"],\
                                                            diskOfferObj
  end

  def delete_disk_offering(h_para, resp)
    if resp['success'].eql? "true"
      @diskofferings.delete h_para[:id]
    end
  end
end
