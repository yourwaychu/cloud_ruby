module InfraModelHelper
  module Zone
    def update(args={})
      puts "not implemented yet"
    end

    def delete(args={})
      args[:id] = "#{self.id}"
      delete_zone(args)
    end

    def create_physical_network(args={})
      args[:zoneid] = self.id
      super(args)
    end

    def delete_physical_network(args={})
      pn = @physical_networks.values[0]
      args[:id] = "#{pn.id}"
      super(args)
    end

    def create_network(args={})
      args[:zoneid] = "#{self.id}"
      super(args)
    end

    def create_pod(args={})
      args[:zoneid] = "#{self.id}"
      super(args)
    end

    def add_secondary_storage(args={})
      args[:zoneid] = "#{self.id}"
      super(args)
    end
  end

  module Pod
    def delete(args={})
      args[:id] = "#{self.id}"
      delete_pod(args)
    end

    
    def add_cluster(args={}) 
      args[:podid]  = "#{self.id}"
      args[:zoneid] = "#{self.zoneid}"
      super(args)
    end
  end

  module Cluster
    def delete(args={})
      args[:id] = "#{self.id}"
      delete_cluster(args)
    end

    def add_host(args={})
      args[:podid]      = "#{self.podid}"
      args[:zoneid]     = "#{self.zoneid}"
      args[:clusterid]  = "#{self.id}"
      super(args)
    end

    def create_storage_pool(args={})
      args[:zoneid]     = "#{self.zoneid}"
      args[:podid]      = "#{self.podid}"
      args[:clusterid]  = "#{self.id}"
      super(args)
    end
  end


  module Host
    def delete(args={})
      puts "not implemented yet"
    end
  end

  module SecondaryStorage
    def delete(args={})
    end
  end
  
  module SystemVm
    def restart(args={}) # asynchronous
    end
    
    def start(args={}) # asynchronous
    end
    def stop(args={}) # asynchronous
    end
  end
  module StoragePool
    def delete(args={})
    end
  end
end
