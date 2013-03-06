## Prerequisites :
 - Ruby 1.9
 - CloudStack API commands
 - gem install cloudstack_helper ; To this step, please refer to [cloudstack_helper](https://github.com/darrendao/cloudstack_helper)

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
        user1 = cs.users.first
        user1.list_zones :listall=>true

  - note : The response will reflect if a api caller has corresponding priviledge

- Example-4 : Infratructure deployer (A sample deployment  yaml file is in  spec/scripts/ )

        $cd to project path
        $./cloudstack_deployer.rb spec/scripts/testdeployement1.yml

  - note : The deployer supports only DevCloud2 by now
