module MainModelHelper
  def create_domain(args={})
    params = {:command  => "createDomain"}
    params.merge! args unless args.empty?
    response = SharedFunction.make_request @cs_agent,
                                           @model_observer, 
                                           params,
                                           "createdomainresponse",
                                           "Domain"

    if response && (!response.instance_of?(CloudStack::Model::Error))
      changed
      notify_observers("create_domain", params, response)
    end
    return response
  end

  def create_zone(args={})
    params = {:command => "createZone"}
    params.merge! args unless args.empty?
    response = SharedFunction.make_request @cs_agent,
                                           @model_observer, 
                                           params,
                                           "createzoneresponse",
                                           "Zone"

    if response && (!response.instance_of?(CloudStack::Model::Error))
      changed
      notify_observers("create_zone", params, response)
    end
    return response
  end
end
