module InfraApiHelper

  module Zone
    sync_cmd_processor :list_zones,
                       :create_zone,
                       :update_zone,
                       :delete_zone
  end

  module Pod
    sync_cmd_processor :list_pods,
                       :create_pod,
                       :update_pod,
                       :delete_pod
  end

  module Cluster
    sync_cmd_processor :list_clusters,
                       :add_cluster,
                       :update_cluster,
                       :delete_cluster
  end

  

  module Host
    sync_cmd_processor :list_hosts,
                       :add_host,
                       :delete_host,
                       :add_secondary_storage

    async_cmd_processor :reconnect_host
  end

  module SystemVm
    sync_cmd_processor  :list_system_vms
    async_cmd_processor :start_system_vm,
                        :stop_system_vm,
                        :reboot_system_vm,
                        :destroy_system_vm
  end

  module StoragePool
    sync_cmd_processor :list_storage_pools,
                       :create_storage_pool,
                       :update_storage_pool,
                       :delete_storage_pool
  end
end
