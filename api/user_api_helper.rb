module CloudStackUserApiHelper
  APICOMMAND = "user"  

  sync_cmd_processor :list_users, :create_user, :delete_user,
                     :register_user_keys, :update_user

end
