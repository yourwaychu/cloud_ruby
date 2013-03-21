#cs_accounts_spec
require 'yaml'
require_relative '../cloudstack'

module CloudStack_Testing
  describe CloudStack, "Infra" do
    before(:all) do
      config = YAML.load_file("spec/config.yml")
      @host     = config["development"]["host"]
      @port     = config["development"]["port"]
      @apiport  = config["development"]["apiport"]
      @cs       = CloudStack::CloudStack.new "#{@host}",
                                             "#{@port}",
                                             "#{@apiport}"
    end  

    it "create zone (OO)" do 
      zoneObj = @cs.create_zone :name => "testzone",
                                :dns1 => "8.8.8.8",
                                :internaldns1 => "8.8.8.8",
                                :networktype => "Basic",
                                :localstorageenabled => true

      @cs.zones["#{zoneObj.id}"].name.should eql("testzone")
    end

    it "create physical network" do
      @cs.zones.each do |k, v|
        if v.name.eql? "testzone"
          @zoneObj = v
        end
      end
      respObj = @zoneObj.create_physical_network :name => "test physical network" 

      @zoneObj.physical_networks["#{respObj.id}"].name.should eq("test physical network")
    end


    it "add traffic type (guest)" do
      @cs.zones.each do |k, v|
        if v.name.eql? "testzone"
          @zoneObj = v
        end
      end
      
      resultObj = @zoneObj.physical_networks.values[0].add_traffic_type :traffictype => "Guest"

    end

    it "delete traffic type (guest)" do
      @cs.zones.each do |k, v|
        if v.name.eql? "testzone"
          @zoneObj = v
        end
      end
      @zoneObj.physical_networks.values[0].traffic_types.values[0].delete
    end

    it "add traffic type (management)" do
      @cs.zones.each do |k, v|
        if v.name.eql? "testzone"
          @zoneObj = v
        end
      end
      
      resultObj = @zoneObj.physical_networks.values[0].add_traffic_type :traffictype => "Guest"
      resultObj = @zoneObj.physical_networks.values[0].add_traffic_type :traffictype => "Management"
      resultObj = @zoneObj.physical_networks.values[0].add_traffic_type :traffictype => "Storage"
    end

    it "update physical_networks" do
      @cs.zones.each do |k, v|
        if v.name.eql? "testzone"
          @zoneObj = v
        end
      end

      @cs.physical_networks.each do |k, v|
        if v.name.eql? "test physical network"
          @pnObj = v
        end
      end
      @pnObj.update :state => "Enabled"
      @zoneObj.physical_networks["#{@pnObj.id}"].state.should eq("Enabled")
    end


    it "setup network service provider" do
      @cs.physical_networks.each do |k, v|
        if v.name.eql? "test physical network"
          @pnObj = v
        end
      end

      @pnObj.network_service_providers.choose("VirtualRouter")[0].virtual_router_elements.values.to_a[0].enable

      @pnObj.network_service_providers.choose("VirtualRouter")[0].enable

      @pnObj.network_service_providers.choose("SecurityGroupProvider")[0].enable
      

      @pnObj.network_service_providers.choose("VirtualRouter")[0].virtual_router_elements.values.to_a[0].enabled.should eql(true)

      @pnObj.network_service_providers.choose("SecurityGroupProvider")[0].state.should eql("Enabled")
      @pnObj.network_service_providers.choose("VirtualRouter")[0].state.should eql("Enabled")
    end

    it "create network" do
      @cs.zones.each do |k, v|
        if v.name.eql? "testzone"
          @zoneObj = v
        end
      end

      @networkoffering = @cs.network_offerings.choose("DefaultSharedNetworkOfferingWithSGService").first

      @zoneObj.create_network :name              => "DefaultGuestNetwork",
                              :displaytext       => "DefaultGuestNetwork" ,
                              :networkofferingid => "#{@networkoffering.id}"

      @zoneObj.networks.choose("DefaultGuestNetwork").first.name.should eq("DefaultGuestNetwork")
    end

    it "create pod and corresponding vlan ip range" do
      @cs.zones.each do |k, v|
        if v.name.eql? "testzone"
          @zoneObj = v
        end
      end
      networkObj = @zoneObj.networks.choose("DefaultGuestNetwork").first

      podObj = @zoneObj.create_pod :name    => "testpod",
                                   :netmask => "255.255.255.0",
                                   :gateway => "192.168.56.1",
                                   :startip => "192.168.56.51",
                                   :endip   => "192.168.56.70"

      @zoneObj.pods.choose("testpod")[0].name.should eq("testpod")

      vlanObj = podObj.create_vlan_ip_range :gateway           => "192.168.56.1",
                                            :netmask           => "255.255.255.0",
                                            :networkid         => "#{networkObj.id}",
                                            :forvirtualnetwork => "false",
                                            :startip           => "192.168.56.71",
                                            :endip             => "192.168.56.100"

      podObj.vlans["#{vlanObj.id}"].should_not be_nil
    end


    it "create cluster" do
      @cs.zones.each do |k, v|
        if v.name.eql? "testzone"
          @zoneObj = v
        end
      end
      
      @podObj =  @zoneObj.pods.choose("testpod")[0]

      clusterObjList = @podObj.add_cluster :clustername => "testcluster",
                                           :clustertype => "CloudManaged",
                                           :hypervisor  => "XenServer"

      @zoneObj.pods["#{@podObj.id}"].clusters["#{clusterObjList[0].id}"].should_not be_nil
    end


    it "add host" do
      @cs.zones.each do |k, v|
        if v.name.eql? "testzone"
          @zoneObj = v
        end
      end
      
      @podObj  = @zoneObj.pods.choose("testpod")[0]
      @cluster = @podObj.clusters.choose("testcluster")[0]

      # DevCloud2 testing 
      hostObjList = @cluster.add_host :hypervisor  => "XenServer",
                                      :clustertype => "CloudManaged",
                                      :hosttags    => "xen1",
                                      :username    => "root",
                                      :password    => "password",
                                      :url         => "http://192.168.56.10"

      @zoneObj.pods["#{@podObj.id}"].clusters["#{@cluster.id}"].hosts["#{hostObjList[0].id}"].should_not be_nil
      
    end

    it "add secondary storage" do
      @cs.zones.each do |k, v|
        if v.name.eql? "testzone"
          @zoneObj = v
        end
      end
      scObj = @zoneObj.add_secondary_storage :url => "nfs://192.168.56.10/opt/storage/secondary" 
      @zoneObj.secondary_storages["#{scObj.id}"].should_not be_nil
    end
    
    # it "delete network" do

    #   @cs.zones.each do |k, v|
    #     if v.name.eql? "testzone"
    #       @zoneObj = v
    #     end
    #   end

    #   @zoneObj.networks.choose("DefaultGuestNetwork").first.delete 
    #   
    #   @zoneObj.networks.choose("DefaultGuestNetwork").first.should be_nil
    # end

    # it "delete physical network" do
    #   @cs.zones.each do |k, v|
    #     if v.name.eql? "testzone"
    #       @zoneObj = v
    #     end
    #   end
    #   @zoneObj.physical_networks.each do |k, v|
    #     if v.name.eql? "test physical network"
    #       @pnObj = v
    #     end
    #   end
    #   @zoneObj.physical_networks["#{@pnObj.id}"].delete
    #   @zoneObj.physical_networks["#{@pnObj.id}"].should be_nil
    # end

    it "update zone (OO)" do
      @cs.zones.each do |k, v|
        if v.name.eql? "testzone"
          @zoneObj = v
        end
      end
      @zoneObj.update :name => "testzone(updated)", :allocationstate => "Enabled"
    end
    #
    # it "delete zone (OO)" do
    #   @cs.zones.each do |k, v|
    #     if v.name.eql? "testzone(updated)"
    #       @zoneObj = v
    #     end
    #     resultObj = @zoneObj.delete
    #     if resultObj.success.eql? "true"
    #       @cs.zones["#{@zoneObj.id}"].should be_nil
    #     end
    #   end
    # end
  end 
end
