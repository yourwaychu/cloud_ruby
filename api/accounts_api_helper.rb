module CloudStackAccountsApiHelper

  sync_cmd_processor :list_domains,
                     :create_domain,
                     :update_domain,
                     :list_accounts,
                     :create_account,
                     :update_account,
                     :list_users,
                     :create_user,
                     :delete_user,
                     :update_user,
                     :enable_user,
                     :register_user_keys
                     

  async_cmd_processor :delete_domain,
                      :delete_account,
                      :disable_user

end

