module NetworkObsvrHelper

private
  def create_network_offering(h_para, resp)
    netOfferJObj = resp['networkoffering'] 
    netOfferObj = SharedFunction.pack_params CloudStack::Model::NetworkOffering\
                                                      .new, netOfferJObj
    @networkofferings["#{netOfferObj.id}"] = netOfferObj

    netOfferJObj['service'].each do |netservice|
      netServiceObj = SharedFunction.pack_params CloudStack::Model::\
                                  NetworkOfferingService.new, netservice

      netOfferObj.services["#{netServiceObj.name}"] = netServiceObj
      
      netservice['provider'].each do |netserviceprovider|
        netProviderObj = SharedFunction.pack_params CloudStack::Model::\
                   NetworkOfferingServiceProvider.new netserviceprovider
        netServiceObj.providers["#{netProviderObj.if}"] = netProviderObj
      end

    end

  end

  def update_network_offering(h_para, resp)
    netOfferJObj = resp['networkoffering']
    newNetOfferObj = SharedFunction.pack_params CloudStack::Model::NetworkOffering.new, netOfferJObj

    netOfferObj = @networkofferings["#{netOfferJObj['id']}"]
    SharedFunction.update_object netOfferObj, newNetOfferObj
  end

  def delete_network_offering(h_para, resp)
    if resp['success'].eql? "true"
      @networkofferings.delete "#{h_para[:id]}"
    end
  end

  def create_physical_network(h_para, resp)
  end
end
