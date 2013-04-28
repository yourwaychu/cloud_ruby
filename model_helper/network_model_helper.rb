module NetworkModelHelper

  module Network
    def delete(args={})
      args[:id] = self.id
      delete_network(args)
    end
    def create_vlan_ip_range(args={})
      args[:networkid] = "#{self.id}"
      super(args)
    end
  end

  module PhysicalNetwork
    def delete(args={}) # Asynchronous
      args[:id] = "#{self.id}"
      delete_physical_network(args)
    end

    def add_traffic_type(args={}) #Asynchronous
      args[:physicalnetworkid] = "#{self.id}"
      super(args)
    end

    def update(args={}) #Asynchronous
    end

    def enable(args={}) # Asynchronous
      args[:id]    = "#{self.id}"
      args[:state] = "Enabled"
      update_physical_network(args)
    end
  end

  module TrafficType
    def delete(args={})
    end
  end

  module NetworkServiceProvider
    def enable(args={}) # Asynchronous
      args[:id] = "#{self.id}"
      args[:state] = "Enabled"
      update_network_service_provider(args)
    end
  end

  module VirtualRouterElement
    def enable(args={}) #Asynchronous
      args[:id] = "#{self.id}"
      args[:enabled] = true
      configure_virtual_router_element(args)
    end
  end
end
