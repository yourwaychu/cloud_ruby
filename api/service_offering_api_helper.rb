module CloudStackServiceOfferingApiHelper

  APICOMMAND = "serviceoffering"

  sync_cmd_processor :list_service_offerings, :create_service_offering,
                     :delete_service_offering, :update_service_offering


end
