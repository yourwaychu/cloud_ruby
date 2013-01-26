module CloudStackNetworkApiHelper

  APICOMMAND = "network"

  sync_cmd_processor :list_network_offerings, :create_network_offering,
                     :delete_network_offering, :update_network_offering,
                     :list_physical_networks
                     
  async_cmd_processor :create_physical_network, :delete_physical_network

end
