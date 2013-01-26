module CloudStackDomainApiHelper

  APICOMMAND = "domain"

  sync_cmd_processor :list_domains, :create_domain, :update_domain

  async_cmd_processor :delete_domain

end

