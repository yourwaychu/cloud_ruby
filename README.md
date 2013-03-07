## Prerequisites :
 - Ruby 1.9
 - CloudStack API commands
 - gem install cloudstack_helper ; Please refer to [cloudstack_helper](https://github.com/darrendao/cloudstack_helper)
 - gem install rest-client

## Usage:
- Example-1 : Require zones in a cloudstack

        require 'cloudstack'
        cs = CloudStack::CloudStack.new  "192.168.56.10", "8080", "8096"
        p cs.zones

- Example-2 : Request to a CloudStack as a root_admin

        require 'cloudstack'
        cs = CloudStack::CloudStack.new  "192.168.56.10", "8080", "8096"
        cs.root_admin.list_zones :listall=>true
- Example-3 : Request to a CloudStack as different role

        require 'cloudstack'
        cs = CloudStack::CloudStack.new  "192.168.56.10", "8080", "8096"
        user1 = cs.users["put the user id here"]
        user1.list_zones :listall=>true

  - note : The response will reflect if a api caller has corresponding priviledge

- Example-4 : Infratructure deployer (A sample deployment  yaml file is in  spec/scripts/ )

        $cd to project path
        $./cloudstack_deployer.rb spec/scripts/testdeployement1.yml

  - note : The deployer supports only DevCloud2 by now

## Currently Supported API commands
- Accounts :
    list_domians, create_domain, udpate_domain, delete_domain, list_accounts, create_account, update_account, delete_account, list_users,  create_user, update_user, disable_user, enable_user, delete_user, register_user_keys
- Infrastructure :
    create_zone, create_physical_network, add_traffic_type, update_physical_network, list_network_service_providers, list_virtual_router_elements, configure_virtual_router_element, update_network_service_provider, update_network_service_provider, create_network, create_pod, create_vlan_ip_range, add_cluster, add_host, add_secondary_storage, update_zone
