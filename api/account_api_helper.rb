module CloudStackAccountApiHelper

  APICOMMAND = "account"

  sync_cmd_processor :list_accounts, :create_account, :update_account

  async_cmd_processor :delete_account

end

