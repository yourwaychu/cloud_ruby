module ServiceOfferingApiHelper

  module DiskOffering
    sync_cmd_processor :list_disk_offerings,
                       :create_disk_offering,
                       :delete_disk_offering,
                       :update_disk_offering

  end

  module ServiceOffering
    sync_cmd_processor :list_service_offerings,
                       :create_service_offering,
                       :delete_service_offering,
                       :update_service_offering

  end
  
  module NetworkOffering
    sync_cmd_processor :list_network_offerings,
                       :create_network_offering,
                       :update_network_offering,
                       :delete_network_offering
  end
                       
end
