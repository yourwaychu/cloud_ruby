module CloudStackZoneApiHelper

  APICOMMAND = "zone"

  sync_cmd_processor :list_zones,
                     :create_zone,
                     :update_zone,
                     :delete_zone
end
