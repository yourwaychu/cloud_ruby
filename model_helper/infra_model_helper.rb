module InfraModelHelper
  module Zone
    def update(args={})
      params = {:command  => "updateZone", :id => "#{self.id}"}
      params.merge! args unless args.empty?
      response = SharedFunction.make_request @cs_agent,
                                             @model_observer,
                                             params,
                                             "updatezoneresponse",
                                             "Zone"

      if response &&
        !response.instance_of?(CloudStack::Model::Error) &&
        response.instance_of?(CloudStack::Model::Zone)

        SharedFunction.update_object self, response
      end
      return response
    end

    def delete(args={})
      params = {:command  => "deleteZone", :id => "#{self.id}"}
      params.merge! args unless args.empty?
      response = SharedFunction.make_request @cs_agent,
                                             @model_observer,
                                             params,
                                             "deletezoneresponse",
                                             "Zone"
      if response &&
         !response.instance_of?(CloudStack::Model::Error) &&
         response.instance_of?(CloudStack::Model::Success) &&
         response.success.eql?("true")
        changed
        notify_observers("model_delete_zone", params, response)
      end
      return response

    end

    def create_physical_network(args={}) #Asychronous
      params = {:command  => "createPhysicalNetwork", :zoneid => "#{self.id}"}
      params.merge! args unless args.empty?
      jJob = SharedFunction.make_async_request @cs_agent, params, "createphysicalnetworkresponse"

      response = SharedFunction.query_async_job @cs_agent,
                                                @model_observer,
                                                {:jobid => jJob['jobid']},
                                                "createPhysicalNetwork",
                                                "PhysicalNetwork"

      if response &&
         !response.instance_of?(CloudStack::Model::Error) &&
         response.instance_of?(CloudStack::Model::PhysicalNetwork)

        response.p_node = self
        self.physical_networks["#{response.id}"] = response
        changed
        notify_observers("model_create_physical_network", params, response)
      end
      return response
    end

    def create_network(args={})
      params = {:command  => "createNetwork", :zoneid => "#{self.id}"}
      params.merge! args unless args.empty?
      response = SharedFunction.make_request @cs_agent,
                                             @model_observer,
                                             params,
                                             "createnetworkresponse",
                                             "Network"

      if response &&
         !response.instance_of?(CloudStack::Model::Error) &&
         response.instance_of?(CloudStack::Model::Network)

        response.p_node = self
        self.networks["#{response.id}"] = response
      end
      return response
    end

    def create_pod(args={})
      params = {:command  => "createPod", :zoneid => "#{self.id}"}
      params.merge! args unless args.empty?
      response = SharedFunction.make_request @cs_agent,
                                             @model_observer,
                                             params,
                                             "createpodresponse",
                                             "Pod"
      if response &&
         !response.instance_of?(CloudStack::Model::Error) &&
         response.instance_of?(CloudStack::Model::Pod)

        response.p_node = self
        self.pods["#{response.id}"] = response
      end
      return response

    end

    def add_secondary_storage(args={})
      params = {:command  => "addSecondaryStorage", :zoneid => "#{self.id}"}
      params.merge! args unless args.empty?
      response = SharedFunction.make_request @cs_agent,
                                             @model_observer,
                                             params, 
                                             "addsecondarystorageresponse",
                                             "SecondaryStorage"
      if response &&
         !response.instance_of?(CloudStack::Model::Error) &&
         response.instance_of?(CloudStack::Model::SecondaryStorage)

        response.p_node = self
        self.secondary_storages["#{response.id}"] = response

      end
      return response
    end
  end

  module Pod
    def delete(args={})
      params = {:command  => "deletePod", :id => "#{self.id}"}
      params.merge! args unless args.empty?
      response = SharedFunction.make_request @cs_agent,
                                             @model_observer,
                                             params, 
                                             "deletepodresponse",
                                             "Pod"
      if response &&
         !response.instance_of?(CloudStack::Model::Error) &&
         response.instance_of?(CloudStack::Model::Success) &&
         response.success.eql?("true")

        self.p_node.pods.delete self.id
      end
      return response
    end

    def create_vlan_ip_range(args={})
      params = {:command  => "createVlanIpRange", :podid => "#{self.id}"}
      params.merge! args unless args.empty?
      response = SharedFunction.make_request @cs_agent,
                                             @model_observer,
                                             params,
                                             "createvlaniprangeresponse", 
                                             "Vlan"
      if response &&
         !response.instance_of?(CloudStack::Model::Error) &&
         response.instance_of?(CloudStack::Model::Vlan)

        response.p_node = self
        self.vlans["#{response.id}"] = response
      end
      return response
    end
    
    def add_cluster(args={}) 
      params = {:command  => "addCluster", :podid => "#{self.id}", :zoneid => "#{self.zoneid}"}
      params.merge! args unless args.empty?
      response = SharedFunction.make_request @cs_agent,
                                             @model_observer, 
                                             params, 
                                             "addclusterresponse",
                                             "Cluster"
      if response &&
         !response.instance_of?(CloudStack::Model::Error) &&
         response.instance_of?(Array)

        response.each do |cr|
          cr.p_node = self
          self.clusters["#{cr.id}"] = cr
        end

        changed
        notify_observers("model_add_cluster", params, response)
      end
      return response
    end

  end

  module Cluster
    def delete(args={})
      params = {:command  => "deleteCluster", :id => "#{self.id}"}
      params.merge! args unless args.empty?
      response = SharedFunction.make_request @cs_agent,
                                             @model_observer,
                                             params, 
                                             "deleteclusterresponse",
                                             "Cluster"
      if response &&
         !response.instance_of?(CloudStack::Model::Error) &&
         response.instance_of?(CloudStack::Model::Success) &&
         response.success.eql?("true")

        self.p_node.clusters.delete self.id
      end
      return response
    end

    def add_host(args={})
      params = {:command   => "addHost",
                :clusterid => "#{self.id}",
                :podid     => "#{self.podid}",
                :zoneid    => "#{self.zoneid}"}

      params.merge! args unless args.empty?
      response = SharedFunction.make_request @cs_agent, 
                                             @model_observer,
                                             params, 
                                             "addhostresponse",
                                             "Host"
      if response &&
         !response.instance_of?(CloudStack::Model::Error) &&
         response.instance_of?(Array)

        response.each do |ht|
          ht.p_node = self
          self.hosts["#{ht.id}"] = ht
        end

        changed
        notify_observers("add_host", params, response)
      end
      return response
    end

    def create_storage_pool(args={})
      params = {:command   => "createStoragePool",
                :zoneid    => "#{self.zoneid}",
                :podid     => "#{self.podid}",
                :clusterid => "#{self.id}"}

      params.merge! args unless args.empty?
      response = SharedFunction.make_request @cs_agent,
                                             @model_observer,
                                             params, 
                                             "createstoragepoolresponse",
                                             "StoragePool"
      if response &&
         !response.instance_of?(CloudStack::Model::Error) &&
         response.instance_of?(CloudStack::Model::StoragePool)

        response.p_node = self
        self.storage_pools["#{response.id}"] = response
        changed
        notify_observers("model_create_storage_pool", params, response)
      end
      return response
    end
  end


  module Host
    def delete(args={})
      params = {:command  => "deleteHost", :id => "#{self.id}"}
      params.merge! args unless args.empty?
      response = SharedFunction.make_request @cs_agent,
                                             @model_observer,
                                             params, 
                                             "deletehostresponse",
                                             "Host"
      if response &&
         !response.instance_of?(CloudStack::Model::Error) &&
         response.instance_of?(CloudStack::Model::Success) &&
         response.success.eql?("true")

        self.p_node.hosts.delete self.id
      end
      return response
    end
  end

  module SecondaryStorage
    def delete(args={})
      params = {:command  => "deleteHost", :id => "#{self.id}"}
      params.merge! args unless args.empty?
      response = SharedFunction.make_request @cs_agent,
                                             @model_observer,
                                             params, 
                                             "deletehostresponse",
                                             "SecondaryStorage"

      if response &&
         !response.instance_of?(CloudStack::Model::Error) &&
         response.instance_of?(CloudStack::Model::Success) &&
         response.success.eql?("true")

        self.p_node.secondary_storages.delete self.id
      end
      return response
    end
  end
  
  module SystemVm
    def restart(args={}) # asynchronous
      params = {:command  => "rebootSystemVm", :id => "#{self.id}"}
      params.merge! args unless args.empty?
      jJob = SharedFunction.make_async_request @cs_agent, params, "rebootsystemvmresponse"

      response = SharedFunction.query_async_job @cs_agent,
                                                @model_observer,
                                                {:jobid => jJob['jobid']},
                                                "rebootSystemVm",
                                                "SystemVm"

      if response &&
         !response.instance_of?(CloudStack::Model::Error) &&
         response.instance_of?(CloudStack::Model::SystemVm)

        SharedFunction.update_object self, response
        # response.p_node = self
        # changed
        # notify_observers("model_create_physical_network", params, response)
      end
      return response
    end
    
    def start(args={}) # asynchronous
      params = {:command  => "startSystemVm", :id => "#{self.id}"}
      params.merge! args unless args.empty?
      jJob = SharedFunction.make_async_request @cs_agent, params, "startsystemvmresponse"

      response = SharedFunction.query_async_job @cs_agent,
                                                @model_observer,
                                                {:jobid => jJob['jobid']},
                                                "startSystemVm",
                                                "SystemVm"

      if response &&
         !response.instance_of?(CloudStack::Model::Error) &&
         response.instance_of?(CloudStack::Model::SystemVm)

        SharedFunction.update_object self, response
        # response.p_node = self
        # changed
        # notify_observers("model_create_physical_network", params, response)
      end
      return response
    end
    def stop(args={}) # asynchronous
      params = {:command  => "stopSystemVm", :id => "#{self.id}"}
      params.merge! args unless args.empty?
      jJob = SharedFunction.make_async_request @cs_agent, params, "stopsystemvmresponse"

      response = SharedFunction.query_async_job @cs_agent,
                                                @model_observer,
                                                {:jobid => jJob['jobid']},
                                                "stopSystemVm",
                                                "SystemVm"

      if response &&
         !response.instance_of?(CloudStack::Model::Error) &&
         response.instance_of?(CloudStack::Model::SystemVm)

        SharedFunction.update_object self, response
        # response.p_node = self
        # changed
        # notify_observers("model_create_physical_network", params, response)
      end
      return response
    end
  end
  module StoragePool
    def delete(args={})
      params = {:command  => "deleteStoragePool", :id => "#{self.id}", :forced => true}
      params.merge! args unless args.empty?
      response = SharedFunction.make_request @cs_agent,
                                             @model_observer,
                                             params, 
                                             "deletestoragepoolresponse",
                                             "StoragePool"

      p response

      if response &&
         !response.instance_of?(CloudStack::Model::Error) &&
         response.instance_of?(CloudStack::Model::Success) &&
         response.success.eql?("true")

        self.p_node.storage_pools.delete self.id
        changed
        notify_observers("model_delete_storage_pool", params, response)
      end
      return response
    end
  end
end
