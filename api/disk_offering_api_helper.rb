module CloudStackDiskOfferingApiHelper

  APICOMMAND = "diskoffering"

  sync_cmd_processor :list_disk_offerings, :create_disk_offering,
                     :delete_disk_offering, :update_disk_offering

end