module CloudStackInfraApiHelper

  sync_cmd_processor :list_zones,
                     :create_zone,
                     :update_zone,
                     :delete_zone,
                     :list_clusters,
                     :add_cluster,
                     :delete_cluster,
                     :update_cluster,
                     :list_pods,
                     :create_pod,
                     :update_pod,
                     :delete_pod,
                     :list_system_vms,
                     :list_hosts,
                     :add_host,
                     :delete_host
                     
  async_cmd_processor :reboot_system_vm,
                      :start_system_vm,
                      :stop_system_vm,
                      :destroy_system_vm


                  
end
