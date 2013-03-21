module NetworkApiHelper

  sync_cmd_processor :list_physical_networks,
                     :list_network_service_providers,
                     :list_virtual_router_elements,
                     :list_traffic_types,
                     :create_network,
                     :create_vlan_ip_range,
                     :add_secondary_storage
      
  async_cmd_processor :create_physical_network,
                      :delete_physical_network,
                      :add_traffic_type,
                      :update_physical_network,
                      :configure_virtual_router_element,
                      :update_network_service_provider
                      
end
