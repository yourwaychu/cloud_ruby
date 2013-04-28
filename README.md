## Installation :
 - Ruby 2.0.0
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

- Example-4 : Different ways for operation

        require 'cloudstack'
        cs = CloudStack::CloudStack.new  "192.168.56.10", "8080", "8096"
        cs.user["user id"].disable
        puts cs.user["user id"].state    # Will show disabled
        
   - note : To see more usage examples, please refer to the spec files

- Example-5 : Infratructure deployer (A sample deployment  yaml file is in  spec/scripts/ )

        $cd to project path
        $./cloudstack_deployer.rb spec/scripts/testdeployement1.yml

  - note : The deployer supports only Basic Zone for now

## Currently Supported API commands

- Accounts :

    - Domain :
       
        list_domains, create_domain, update_domain, delete_domain
    - Account :
    
        list_accounts, create_account, update_account, delete_account
    - User :
    
        list_users,  create_user, update_user, disable_user, enable_user, delete_user, register_user_keys

- Infrastructure :

    - Zone :
    
        list_zones, create_zone, update_zone, delete_zone
    
    - Pod :

        list_pods, create_pod, update_pod, delete_pod

    - Cluster :

        list_clusters, add_cluster, update_cluster, delete_cluster

    - Hosts :
        
        add_host, delete_host, list_hosts

    - Network :
    
        create_physical_network, add_traffic_type, update_physical_network, list_network_service_providers, list_virtual_router_elements, configure_virtual_router_element, update_network_service_provider, update_network_service_provider, create_network, create_vlan_ip_range,
delete_vlan_ip_range 

    - Storage :

        add_secondary_storage

    - Service Offering :
        
        list_service_offerings, create_service_offering, update_service_offering, delete_service_offering, list_disk_offerings, create_disk_offering, update_disk_offering, delete_disk_offering

    - System VM :

       list_system_vms, reboot_system_vm, start_system_vm, stop_system_vm, destroy_system_vm


- Instances

    - VirtualMachine :
    
        deploy_virtual_machine, destroy_virtual_machine, reboot_virtual_machine, start_virtual_machine, stop_virtual_machine

## History
- 4-28-2013 : Huge refactor, remove cloudstack_helper due to json issue and ready for basic zone deployment
- 3-22-2013 : Not done yet; don't expect it to work. It's really close though.
