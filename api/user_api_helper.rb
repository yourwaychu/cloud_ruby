module CloudStackUserApiHelper
  APICOMMAND = "user"  

  sync_cmd_processor :list_users, :create_user, :delete_user,
                     :update_user, :enable_user

  async_cmd_processor :disable_user

end

module CloudStackUserkeysApiHelper
  APICOMMAND = 'userkeys'
  sync_cmd_processor :register_user_keys
end

