module NetworkModelHelper

  module Network
    def delete(args={})
      params = {:command  => "deleteNetwork", :id => "#{self.id}"}
      params.merge! args unless args.empty?
      jJob = SharedFunction.make_async_request @cs_agent, params, "deletenetworkresponse"

      responseObj = SharedFunction.query_async_job @cs_agent,
                                                   {:jobid => jJob['jobid']},
                                                   "deleteNetwork",
                                                   "Network"

      if responseObj && (!responseObj.instance_of?(CloudStack::Model::Error))
        self.p_node.networks.delete "#{self.id}"
        changed
        notify_observers("delete_network", params, responseObj)
      end

      return responseObj

    end
  end

  module PhysicalNetwork
    def delete(args={}) # Asynchronous
      params = {:command  => "deletePhysicalNetwork", :id => "#{self.id}"}
      params.merge! args unless args.empty?
      jJob = SharedFunction.make_async_request @cs_agent, params, "deletephysicalnetworkresponse"

      responseObj = SharedFunction.query_async_job @cs_agent,
                                                   @model_observer,
                                                   {:jobid => jJob['jobid']},
                                                   "deletePhysicalNetwork",
                                                   "PhysicalNetwork"

      if responseObj && (!responseObj.instance_of?(CloudStack::Model::Error))
        changed
        notify_observers("delete_physical_network", params, responseObj)
      end

      return responseObj
    end

    def add_traffic_type(args={}) #Asynchronous
      params = {:command  => "addTrafficType", :physicalnetworkid => "#{self.id}"}
      params.merge! args unless args.empty?
      jJob = SharedFunction.make_async_request @cs_agent, params, "addtraffictyperesponse"

      responseObj = SharedFunction.query_async_job @cs_agent,
                                                   @model_observer,
                                                   {:jobid => jJob['jobid']},
                                                   "addTrafficType",
                                                   "TrafficType"

      if responseObj && (!responseObj.instance_of?(CloudStack::Model::Error))
        responseObj.p_node = self
        @traffic_types["#{responseObj.id}"] = responseObj
        #changed
        #notify_observers("add_traffic_type", params, responseObj)
      end
      return responseObj
    end

    def update(args={}) #Asynchronous
      params = {:command  => "updatePhysicalNetwork", :id => "#{self.id}"}
      params.merge! args unless args.empty?
      jJob = SharedFunction.make_async_request @cs_agent, params, "updatephysicalnetworkresponse"

      responseObj = SharedFunction.query_async_job @cs_agent,
                                                   @model_observer,
                                                   {:jobid => jJob['jobid']},
                                                   "updatePhysicalNetwork",
                                                   "PhysicalNetwork"

      
      if responseObj && (!responseObj.instance_of?(CloudStack::Model::Error))
        changed
        notify_observers("update_physical_network", params, responseObj)
      end

      return responseObj

    end
  end

  module TrafficType
    def delete(args={})
      params = {:command  => "deleteTrafficType", :id => "#{self.id}"}
      params.merge! args unless args.empty?
      jJob = SharedFunction.make_async_request @cs_agent, params, "deletetraffictyperesponse"

      responseObj = SharedFunction.query_async_job @cs_agent,
                                                   @model_observer,
                                                   {:jobid => jJob['jobid']},
                                                   "deleteTrafficType",
                                                   "TrafficType"

      if responseObj && (!responseObj.instance_of?(CloudStack::Model::Error))
        self.p_node.traffic_types.delete self.id
      end
      return responseObj

    end
  end

  module NetworkServiceProvider

    def enable(args={}) # Asynchronous
      params = {:command  => "updateNetworkServiceProvider", :id => "#{self.id}", :state =>"Enabled"}
      params.merge! args unless args.empty?
      jJob = SharedFunction.make_async_request @cs_agent, params, "updatenetworkserviceproviderresponse"

      responseObj = SharedFunction.query_async_job @cs_agent,
                                                   @model_observer,
                                                   {:jobid => jJob['jobid']},
                                                   "updateNetworkServiceProvider",
                                                   "NetworkServiceProvider"

      if responseObj && (!responseObj.instance_of?(CloudStack::Model::Error))
        changed
        notify_observers("enable_network_service_provider", params.merge!({:physicalnetworkid => "#{self.physicalnetworkid}"}), responseObj)
      end
      return responseObj
    end

    def update(args={})
      # FIXME
      puts "FIXME : Updating network service provider"
      
    end
  end

  module VirtualRouterElement
    def enable(args={}) #Asynchronous

      params = {:command  => "configureVirtualRouterElement", :id => "#{self.id}", :enabled => true}

      params.merge! args unless args.empty?

      jJob = SharedFunction.make_async_request @cs_agent,
                                               params, 
                                               "configurevirtualrouterelementresponse"

      responseObj = SharedFunction.query_async_job @cs_agent,
                                                   @model_observer,
                                                   {:jobid => jJob['jobid']},
                                                   "configureVirtualRouterElement",
                                                   "VirtualRouterElement"

      if responseObj && (!responseObj.instance_of?(CloudStack::Model::Error))
        changed
        notify_observers("configure_virtual_router_element", params.merge!({:physicalnetworkid=>"#{self.physicalnetworkid}"}), responseObj)
      end
      return responseObj

    end
  end
end