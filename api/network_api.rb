module NetworkApiHelper
  module Network
    sync_cmd_processor :list_network_service_providers,
                       :list_virtual_router_elements,
                       :create_network,
                       :create_vlan_ip_range,
                       :delete_vlan_ip_range,
                       :add_secondary_storage,
                       :list_networks
        
    async_cmd_processor :configure_virtual_router_element,
                        :update_network_service_provider,
                        :delete_network,
                        :create_storage_network_ip_range,
                        :delete_storage_network_ip_range
  end

  module TrafficType
    sync_cmd_processor :list_traffic_types

    async_cmd_processor :add_traffic_type,
                        :delete_traffic_type,
                        :update_traffic_type
  end

  module PhysicalNetwork
    sync_cmd_processor :list_physical_networks
    async_cmd_processor :create_physical_network,
                        :delete_physical_network,
                        :update_physical_network
  end
end
