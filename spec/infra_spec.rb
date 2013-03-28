#cs_accounts_spec
require 'yaml'
require_relative '../cloudstack'

module CloudStack_Testing
  describe CloudStack, "Infra" do
    before(:all) do
      config = YAML.load_file("spec/testconfig.yml")
      @host     = config["development"]["host"]
      @port     = config["development"]["port"]
      @apiport  = config["development"]["apiport"]
      @cs       = CloudStack::CloudStack.new "#{@host}",
                                             "#{@port}",
                                             "#{@apiport}"
    end  
    it "create zone" do
      zoneObj = @cs.root_admin.create_zone :name => "testzone",
                                           :dns1 => "8.8.8.8",
                                           :internaldns1 => "8.8.8.8",
                                           :networktype => "Basic",
                                           :localstorageenabled => true
      
      @cs.zones["#{zoneObj.id}"].name.should eql("testzone")
    end

    it "create physical network" do
      @cs.zones.each do |k, v|
        if v.name.eql?"testzone"
          @zoneObj = v
        end
      end
      resultObj = @cs.root_admin.create_physical_network :name   => "test physical network",
                                                         :zoneid => "#{@zoneObj.id}"
       
      @zoneObj.physical_networks["#{resultObj.id}"].name.should eq("test physical network")
    end

    it "add traffic type" do
      @cs.zones.each do |k, v|
        if v.name.eql?"testzone"
          @zoneObj = v
        end
      end

      @pnObj = @zoneObj.physical_networks.values[0]

      resultObj1 = @cs.root_admin.add_traffic_type :physicalnetworkid => "#{@pnObj.id}",
                                                   :traffictype       => "Guest"

      resultObj2 = @cs.root_admin.add_traffic_type :physicalnetworkid => "#{@pnObj.id}",
                                                   :traffictype       => "Management"


      @pnObj.traffic_types.each do |k, v|
        if v.traffictype.eql? "Guest"
          @tt = v
        end
      end

      @tt.should_not be_nil
      @pnObj.traffic_types.length.should eql(2)
    end

    it "update physical network" do
       @cs.zones.each do |k, v|
        if v.name.eql?"testzone"
          @zoneObj = v
        end
      end

      @pnObj = @zoneObj.physical_networks.values[0]
      resultObj1 = @cs.root_admin.update_physical_network :id    => "#{@pnObj.id}",
                                                          :state => "Enabled"
      @pnObj.state.should eq("Enabled")
    end

    it "configure service provider" do
      @cs.zones.each do |k, v|
        if v.name.eql?"testzone"
          @zoneObj = v
        end
      end

      @pnObj = @zoneObj.physical_networks.values[0]

      @vrsp = @cs.root_admin.list_network_service_providers :name => "VirtualRouter",
                                                            :physicalnetworkid => "#{@pnObj.id}"

      @vre = @cs.root_admin.list_virtual_router_elements :nspid => "#{@vrsp.first.id}"

      @cs.root_admin.configure_virtual_router_element :id      => "#{@vre.first.id}",
                                                      :enabled => "true"

      @cs.root_admin.update_network_service_provider :id    => "#{@vrsp.first.id}",
                                                     :state => "Enabled"

      @sgsp = @cs.root_admin.list_network_service_providers :name => "SecurityGroupProvider",
                                                            :physicalnetworkid => "#{@pnObj.id}"
  
      @cs.root_admin.update_network_service_provider :id    => "#{@sgsp.first.id}",
                                                     :state => "Enabled" 

      @pnObj.network_service_providers.length.should eq(2)
    end

    it "create network" do
      @cs.zones.each do |k, v|
        if v.name.eql?"testzone"
          @zoneObj = v
        end
      end

      @networkoffering = @cs.network_offerings.choose("DefaultSharedNetworkOfferingWithSGService").first

      @network = @cs.root_admin.create_network :displaytext => "defaultGuestNetwork",
                                               :name        => "defaultGuestNetwork",
                                               :networkofferingid => "#{@networkoffering.id}",
                                               :zoneid      => "#{@zoneObj.id}" 

      @zoneObj.networks.values[0].name.should eq("defaultGuestNetwork")
    end

    it "create pod" do
      @cs.zones.each do |k, v|
        if v.name.eql?"testzone"
          @zoneObj = v
        end
      end
      @podObj = @cs.root_admin.create_pod :name    => "testpod",
                                          :startip => "192.168.56.51",
                                          :endip   => "192.168.56.70",
                                          :netmask => "255.255.255.0",
                                          :gateway => "192.168.56.1",
                                          :zoneid  => "#{@zoneObj.id}"

      @zoneObj.pods.values[0].name.should eq("testpod")
    end

    it "create vlan" do
      @cs.zones.each do |k, v|
        if v.name.eql?"testzone"
          @zoneObj = v
        end
      end

      @netObj = @zoneObj.networks.values[0]
      @podObj = @zoneObj.pods.values[0]
      
      @vlan = @cs.root_admin.create_vlan_ip_range :podid     => "#{@podObj.id}",
                                                  :networkid => "#{@netObj.id}",
                                                  :forvirtualnetwork => false,
                                                  :gateway   => "192.168.56.1",
                                                  :netmask   => "255.255.255.0",
                                                  :startip   => "192.168.56.71",
                                                  :endip     => "192.168.56.100"

      @podObj.vlans.values[0].should_not be_nil
    end

    it "add cluster" do
      @cs.zones.each do |k, v|
        if v.name.eql?"testzone"
          @zoneObj = v
        end
      end
      @podObj = @zoneObj.pods.values[0]

      @cluster = @cs.root_admin.add_cluster :zoneid      => "#{@zoneObj.id}",
                                            :podid       => "#{@podObj.id}",
                                            :hypervisor  => "XenServer",
                                            :clustertype => "CloudManaged",
                                            :clustername => "testcluster"

      @podObj.clusters.values[0].should_not be_nil
    end

    it "add host" do
      @cs.zones.each do |k, v|
        if v.name.eql?"testzone"
          @zoneObj = v
        end
      end
      @podObj = @zoneObj.pods.values[0]
      @clusterObj = @podObj.clusters.values[0]

      @host = @cs.root_admin.add_host :zoneid => "#{@zoneObj.id}",
                                      :podid  => "#{@podObj.id}",
                                      :clusterid => "#{@clusterObj.id}",
                                      :hypervisor => "XenServer",
                                      :clustertype => "CloudManaged",
                                      :username => "root",
                                      :password => "password",
                                      :url => "http://192.168.56.10"

      @clusterObj.hosts.values[0].should_not be_nil
    end

    it "add secondary storage" do
      @cs.zones.each do |k, v|
        if v.name.eql?"testzone"
          @zoneObj = v
        end
      end
      @sc = @cs.root_admin.add_secondary_storage :zoneid => "#{@zoneObj.id}",
                                                 :url    => "nfs://192.168.56.10/opt/storage/secondary/"

      @zoneObj.secondary_storages.values[0].should_not be_nil
    end

    # it "delete secondary storage" do
    #   @cs.zones.each do |k, v|
    #     if v.name.eql?"testzone"
    #       @zoneObj = v
    #     end
    #   end
    #   @sc = @zoneObj.secondary_storages.values[0]
    # 
    #   resultObj = @cs.root_admin.delete_host :id => "#{@sc.id}"
    # 
    #   @zoneObj.secondary_storages.values[0].should be_nil
    # end
    # 
    # it "delete host" do
    #   @cs.zones.each do |k, v|
    #     if v.name.eql?"testzone"
    #       @zoneObj = v
    #     end
    #   end
    #   @podObj = @zoneObj.pods.values[0]
    #   @clusterObj = @podObj.clusters.values[0]
    #   @hostObj = @clusterObj.hosts.values[0]
    #   resultObj = @cs.root_admin.delete_host :id => "#{@hostObj.id}"
    #   @clusterObj.hosts.values[0].should be_nil
    # end
    # 
    # it "delete cluster" do
    #   @cs.zones.each do |k, v|
    #     if v.name.eql?"testzone"
    #       @zoneObj = v
    #     end
    #   end
    #   @podObj = @zoneObj.pods.values[0]
    #   @clusterObj = @podObj.clusters.values[0]
    #   resultObj = @cs.root_admin.delete_cluster :id => "#{@clusterObj.id}"
    #   @podObj.clusters.values[0].should be_nil
    # end
    # 
    # it "delete vlan" do
    #   @cs.zones.each do |k, v|
    #     if v.name.eql?"testzone"
    #       @zoneObj = v
    #     end
    #   end
    # 
    #   @netObj  = @zoneObj.networks.values[0]
    #   @podObj  = @zoneObj.pods.values[0]
    #   @vlanObj = @podObj.vlans.values[0]
    #   
    #   resultObj = @cs.root_admin.delete_vlan_ip_range :id => "#{@vlanObj.id}"
    #   @podObj.vlans.values[0].should be_nil
    # end
    # 
    # it "delete pod" do
    #   @cs.zones.each do |k, v|
    #     if v.name.eql?"testzone"
    #       @zoneObj = v
    #     end
    #   end
    #   @podObj = @zoneObj.pods.values[0]
    #   resultObj = @cs.root_admin.delete_pod :id => "#{@podObj.id}"
    #   @zoneObj.pods.values[0].should be_nil
    # end
    # 
    # it "delete network" do
    #   @cs.zones.each do |k, v|
    #     if v.name.eql?"testzone"
    #       @zoneObj = v
    #     end
    #   end
    #   @net = @zoneObj.networks.values[0]
    #   resultObj = @cs.root_admin.delete_network :id => "#{@net.id}"
    #   @zoneObj.networks.values[0].should be_nil
    # end
    # 
    # it "delete physical network" do
    #   @cs.zones.each do |k, v|
    #     if v.name.eql?"testzone"
    #       @zoneObj = v
    #     end
    #   end
    # 
    #   @pnObj = @zoneObj.physical_networks.values[0]
    # 
    #   resultObj = @cs.root_admin.delete_physical_network :id => "#{@pnObj.id}"
    # 
    #   @zoneObj.physical_networks["#{@pnObj.id}"].should be_nil
    # end
    # 
    # it "delete zone" do
    #   @cs.zones.each do |k, v|
    #     if v.name.eql?"testzone"
    #       @zoneObj = v
    #     end
    #   end
    # 
    #   resultObj = @cs.root_admin.delete_zone :id => "#{@zoneObj.id}"
    # 
    #   @cs.zones["#{@zoneObj.id}"].should be_nil
    # end
    # 
    # it "create zone (OO)" do 
    #   zoneObj = @cs.create_zone :name => "testzone",
    #                             :dns1 => "8.8.8.8",
    #                             :internaldns1 => "8.8.8.8",
    #                             :networktype => "Basic",
    #                             :localstorageenabled => true
    # 
    #   @cs.zones["#{zoneObj.id}"].name.should eql("testzone")
    # end
    # 
    # it "create physical network" do
    #   @cs.zones.each do |k, v|
    #     if v.name.eql? "testzone"
    #       @zoneObj = v
    #     end
    #   end
    #   respObj = @zoneObj.create_physical_network :name => "test physical network" 
    # 
    #   @zoneObj.physical_networks["#{respObj.id}"].name.should eq("test physical network")
    # end
    # 
    # 
    # it "add traffic type (guest)" do
    #   @cs.zones.each do |k, v|
    #     if v.name.eql? "testzone"
    #       @zoneObj = v
    #     end
    #   end
    #   resultObj = @zoneObj.physical_networks.values[0].add_traffic_type :traffictype => "Guest"
    #   @zoneObj.physical_networks.values[0].traffic_types.values[0].should_not be_nil
    #   @zoneObj.physical_networks.values[0].traffic_types.values[0].traffictype.should eql("Guest")
    # end
    # 
    # it "delete traffic type (guest)" do
    #   @cs.zones.each do |k, v|
    #     if v.name.eql? "testzone"
    #       @zoneObj = v
    #     end
    #   end
    #   @zoneObj.physical_networks.values[0].traffic_types.values[0].delete
    # end
    # 
    # it "add traffic type (management)" do
    #   @cs.zones.each do |k, v|
    #     if v.name.eql? "testzone"
    #       @zoneObj = v
    #     end
    #   end
    #   
    #   resultObj = @zoneObj.physical_networks.values[0].add_traffic_type :traffictype => "Guest"
    #   resultObj = @zoneObj.physical_networks.values[0].add_traffic_type :traffictype => "Management"
    #   resultObj = @zoneObj.physical_networks.values[0].add_traffic_type :traffictype => "Storage"
    # end
    # 
    # it "update physical_networks" do
    #   @cs.zones.each do |k, v|
    #     if v.name.eql? "testzone"
    #       @zoneObj = v
    #     end
    #   end
    # 
    #   @cs.physical_networks.each do |k, v|
    #     if v.name.eql? "test physical network"
    #       @pnObj = v
    #     end
    #   end
    #   @pnObj.update :state => "Enabled"
    #   @zoneObj.physical_networks["#{@pnObj.id}"].state.should eq("Enabled")
    # end
    # 
    # 
    # it "setup network service provider" do
    #   @cs.physical_networks.each do |k, v|
    #     if v.name.eql? "test physical network"
    #       @pnObj = v
    #     end
    #   end
    # 
    #   @pnObj.network_service_providers.choose("VirtualRouter")[0].virtual_router_elements.values.to_a[0].enable
    # 
    #   @pnObj.network_service_providers.choose("VirtualRouter")[0].enable
    # 
    #   @pnObj.network_service_providers.choose("SecurityGroupProvider")[0].enable
    # 
    #   @pnObj.network_service_providers.choose("VirtualRouter")[0].virtual_router_elements.values.to_a[0].enabled.should eql(true)
    # 
    #   @pnObj.network_service_providers.choose("SecurityGroupProvider")[0].state.should eql("Enabled")
    # 
    #   @pnObj.network_service_providers.choose("VirtualRouter")[0].state.should eql("Enabled")
    # end
    # 
    # it "create network" do
    #   @cs.zones.each do |k, v|
    #     if v.name.eql? "testzone"
    #       @zoneObj = v
    #     end
    #   end
    # 
    #   @networkoffering = @cs.network_offerings.choose("DefaultSharedNetworkOfferingWithSGService").first
    # 
    #   @zoneObj.create_network :name              => "DefaultGuestNetwork",
    #                           :displaytext       => "DefaultGuestNetwork" ,
    #                           :networkofferingid => "#{@networkoffering.id}"
    # 
    #   @zoneObj.networks.choose("DefaultGuestNetwork").first.name.should eq("DefaultGuestNetwork")
    # end
    # 
    # it "create pod and corresponding vlan ip range" do
    #   @cs.zones.each do |k, v|
    #     if v.name.eql? "testzone"
    #       @zoneObj = v
    #     end
    #   end
    #   networkObj = @zoneObj.networks.choose("DefaultGuestNetwork").first
    # 
    #   podObj = @zoneObj.create_pod :name    => "testpod",
    #                                :netmask => "255.255.255.0",
    #                                :gateway => "192.168.56.1",
    #                                :startip => "192.168.56.51",
    #                                :endip   => "192.168.56.70"
    # 
    #   @zoneObj.pods.choose("testpod")[0].name.should eq("testpod")
    # 
    #   vlanObj = podObj.create_vlan_ip_range :gateway           => "192.168.56.1",
    #                                         :netmask           => "255.255.255.0",
    #                                         :networkid         => "#{networkObj.id}",
    #                                         :forvirtualnetwork => "false",
    #                                         :startip           => "192.168.56.71",
    #                                         :endip             => "192.168.56.100"
    # 
    #   podObj.vlans["#{vlanObj.id}"].should_not be_nil
    # end
    # 
    # 
    # it "add cluster" do
    #   @cs.zones.each do |k, v|
    #     if v.name.eql? "testzone"
    #       @zoneObj = v
    #     end
    #   end
    #   
    #   @podObj =  @zoneObj.pods.choose("testpod")[0]
    # 
    #   clusterObjList = @podObj.add_cluster :clustername => "testcluster",
    #                                        :clustertype => "CloudManaged",
    #                                        :hypervisor  => "XenServer"
    # 
    #   @zoneObj.pods["#{@podObj.id}"].clusters["#{clusterObjList[0].id}"].should_not be_nil
    # end
    # 
    # 
    # it "add host" do
    #   @cs.zones.each do |k, v|
    #     if v.name.eql? "testzone"
    #       @zoneObj = v
    #     end
    #   end
    #   
    #   @podObj  = @zoneObj.pods.choose("testpod")[0]
    #   @cluster = @podObj.clusters.choose("testcluster")[0]
    # 
    #   # DevCloud2 testing 
    #   hostObjList = @cluster.add_host :hypervisor  => "XenServer",
    #                                   :clustertype => "CloudManaged",
    #                                   :hosttags    => "xen1",
    #                                   :username    => "root",
    #                                   :password    => "password",
    #                                   :url         => "http://192.168.56.10"
    # 
    #   @zoneObj.pods["#{@podObj.id}"].clusters["#{@cluster.id}"].hosts["#{hostObjList[0].id}"].should_not be_nil
    # end
    # 
    # it "add secondary storage" do
    #   @cs.zones.each do |k, v|
    #     if v.name.eql? "testzone"
    #       @zoneObj = v
    #     end
    #   end
    #   scObj = @zoneObj.add_secondary_storage :url => "nfs://192.168.56.10/opt/storage/secondary" 
    #   @zoneObj.secondary_storages["#{scObj.id}"].should_not be_nil
    # end
    # 
    # # it "update zone (OO)" do
    # #   @cs.zones.each do |k, v|
    # #     if v.name.eql? "testzone"
    # #       @zoneObj = v
    # #     end
    # #   end
    # #   @zoneObj.update :allocationstate => "Enabled"
    # # end
    # 
    # it "delete secondary storage" do
    #   @cs.zones.each do |k, v|
    #     if v.name.eql? "testzone"
    #       @zoneObj = v
    #     end
    #   end
    #   
    #   @scObj  = @zoneObj.secondary_storages.values[0]
    #   resultObj = @scObj.delete
    #   @zoneObj.secondary_storages.values[0].should be_nil
    # end
    # 
    # it "delete host" do
    #   @cs.zones.each do |k, v|
    #     if v.name.eql? "testzone"
    #       @zoneObj = v
    #     end
    #   end
    #   
    #   @podObj  = @zoneObj.pods.choose("testpod")[0]
    #   @cluster = @podObj.clusters.choose("testcluster")[0]
    #   resultObj = @cluster.hosts.values[0].delete
    #   @cluster.hosts.values[0].should be_nil
    # end
    # 
    # it "delete cluster" do
    #   @cs.zones.each do |k, v|
    #     if v.name.eql? "testzone"
    #       @zoneObj = v
    #     end
    #   end
    #   
    #   @podObj =  @zoneObj.pods.choose("testpod")[0]
    # 
    #   resultObj = @podObj.clusters.values[0].delete
    # 
    #   @podObj.clusters.values[0].should be_nil
    # end
    # 
    # it "delete pod" do
    #   @cs.zones.each do |k, v|
    #     if v.name.eql? "testzone"
    #       @zoneObj = v
    #     end
    #   end
    #   resultObj = @zoneObj.pods.values[0].delete
    #   @zoneObj.pods.values[0].should be_nil
    # end
    # 
    # it "delete network" do
    #   @cs.zones.each do |k, v|
    #     if v.name.eql? "testzone"
    #       @zoneObj = v
    #     end
    #   end
    # 
    #   @zoneObj.networks.choose("DefaultGuestNetwork").first.delete 
    #   
    #   @zoneObj.networks.choose("DefaultGuestNetwork").first.should be_nil
    # end
    # 
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
    # 
    # 
    # it "delete zone (OO)" do
    #   @cs.zones.each do |k, v|
    #     if v.name.eql? "testzone"
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
