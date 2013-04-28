module MainModelHelper

  def create_domain(args={})  #create level 1 domain under ROOT
    super(args)
  end


  def create_zone(args={})
    super(args)
  end
  # def create_zone(args={}, api_caller=nil)
  #   params = {:command => "createZone"}
  #   params.merge! args unless args.empty?
  #   response = SharedFunction.make_request @cs_agent,
  #                                          @model_observer, 
  #                                          params,
  #                                          "createzoneresponse",
  #                                          "Zone"

  #   if response &&
  #      (!response.instance_of?(CloudStack::Model::Error)) &&
  #      response.instance_of?(CloudStack::Model::Zone)
  #     response.p_node = self
  #     self.zones["#{response.id}"] = response
  #     changed
  #     notify_observers("model_create_zone", params, response)
  #   end
  #   return response
  # end
  # def create_service_offering(args={})
  #   params = {:command => "createServiceOffering"}
  #   params.merge! args unless args.empty?
  #   response = SharedFunction.make_request @cs_agent,
  #                                          @model_observer, 
  #                                          params,
  #                                          "createserviceofferingresponse",
  #                                          "ServiceOffering"

  #   if response &&
  #      (!response.instance_of?(CloudStack::Model::Error)) &&
  #      response.instance_of?(CloudStack::Model::ServiceOffering)
  #     response.p_node = self
  #     if response.issystem.eql?(true)
  #       self.service_offerings["#{response.id}"] = response
  #     else 
  #       self.compute_offerings["#{response.id}"] = response
  #     end
  #   end
  #   return response

  # end
end
