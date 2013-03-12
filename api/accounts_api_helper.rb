module AccountsApiHelper

  module Domain
    sync_cmd_processor :list_domains,
                       :create_domain,
                       :update_domain

    async_cmd_processor :delete_domain

  end

  module Account
    sync_cmd_processor :list_accounts,
                       :create_account,
                       :update_account

    async_cmd_processor :delete_account
  end

  module User
    sync_cmd_processor :list_users,
                       :create_user,
                       :delete_user,
                       :update_user,
                       :enable_user,
                       :register_user_keys

    async_cmd_processor :disable_user
  end

end

