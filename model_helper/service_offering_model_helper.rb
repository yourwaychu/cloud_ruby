module ServiceOfferingModelHelper
  module ServiceOffering
    def delete(args={})  
      params = {:command => "deleteServiceOffering",
                :id      => "#{self.id}"}
      params.merge! args unless args.empty?
      response = SharedFunction.make_request @cs_agent,
                                             @model_observer, 
                                             params,
                                             "deleteserviceofferingresponse",
                                             "ServiceOffering"

      if response && 
         (!response.instance_of?(CloudStack::Model::Error)) &&
         response.instance_of?(CloudStack::Model::Success) &&
         response.success.eql?("true")

        if self.issystem.eql? true
          self.p_node.system_offerings.delete self.id
        else
          self.p_node.compute_offerings.delete self.id
        end
      end
      return response
    end

    def update(args={})
      params = {:command => "updateServiceOffering",
                :id      => "#{self.id}"}
      params.merge! args unless args.empty?
      response = SharedFunction.make_request @cs_agent,
                                             @model_observer, 
                                             params,
                                             "updateserviceofferingresponse",
                                             "ServiceOffering"

      if response && 
         (!response.instance_of?(CloudStack::Model::Error)) &&
         response.instance_of?(CloudStack::Model::ServiceOffering)

        SharedFunction.update_object self, response
      end
      return response
    end
  end

  module NetworkOffering
    def delete(args={})  
      params = {:command => "deleteNetworkOffering",
                :id      => "#{self.id}"}
      params.merge! args unless args.empty?
      response = SharedFunction.make_request @cs_agent,
                                             @model_observer, 
                                             params,
                                             "deletenetworkofferingresponse",
                                             "NetworkOffering"

      if response && 
         (!response.instance_of?(CloudStack::Model::Error)) &&
         response.instance_of?(CloudStack::Model::Success) &&
         response.success.eql("true")

        self.p_node.network_offerings.delete self.id
        changed
        notify_observers("model_delete_network_offering", params, response)
      end
      return response
    end

    def update(args={})
      params = {:command => "updateNetworkOffering",
                :id      => "#{self.id}"}
      params.merge! args unless args.empty?
      response = SharedFunction.make_request @cs_agent,
                                             @model_observer, 
                                             params,
                                             "updateserviceofferingresponse",
                                             "NetworkOffering"

      if response && 
         (!response.instance_of?(CloudStack::Model::Error)) &&
         response.instance_of?(CloudStack::Model::NetworkOffering)

        SharedFunction.update_object self, response
      end
      return response
    end

  end

  module DiskOffering
    def delete(args={})  
      params = {:command => "deleteDiskOffering",
                :id      => "#{self.id}"}
      params.merge! args unless args.empty?
      response = SharedFunction.make_request @cs_agent,
                                             @model_observer, 
                                             params,
                                             "deletediskofferingresponse",
                                             "DiskOffering"

      if response && 
         (!response.instance_of?(CloudStack::Model::Error)) &&
         response.instance_of?(CloudStack::Model::Success) &&
         response.success.eql("true")
        self.p_node.disk_offerings.delete self.id
        changed
        notify_observers("model_delete_disk_offering", params, response)
      end
      return response
    end
    def update(args={})
      params = {:command => "updateDiskOffering",
                :id      => "#{self.id}"}
      params.merge! args unless args.empty?
      response = SharedFunction.make_request @cs_agent,
                                             @model_observer, 
                                             params,
                                             "updatediskofferingresponse",
                                             "DiskOffering"

      if response && 
         (!response.instance_of?(CloudStack::Model::Error)) &&
         response.instance_of?(CloudStack::Model::DiskOffering)

        SharedFunction.update_object self, response
      end
      return response
    end
  end
end
