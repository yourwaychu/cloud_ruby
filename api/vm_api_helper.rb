module CloudStackVMApiHelper

  async_cmd_processor :deploy_virtual_machine,
                      :destroy_virtual_machine,
                      :reboot_virtual_machine,
                      :start_virtual_machine,
                      :stop_virtual_machine

end

