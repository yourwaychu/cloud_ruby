#cs_domain_spec
require_relative '../cloudstack'

module Cloudstack_Domain
  describe CloudStack, "Network" do
    before(:all) do
      config = YAML.load_file("spec/config.yml")
      @host = config["development"]["host"]
      @port = config["development"]["port"]
      @apiport = config["development"]["apiport"]
      @cs = CloudStack::CloudStack.new "#{@host}", "#{@port}", "#{@apiport}"
    end  

    it "should have newly created data in the cloudstack env" do

      @resp = @cs.root_admin.create_network_offering\
                                             :name=>"TestNetworkOffering",
                                             :displaytext=>"test",
                                             :traffictype=>"GUEST",
                                             :guestiptype=>"Isolated",
                                             :supportedservices=>"Dhcp"
      

      @netofferJObj = @resp['networkoffering']

      @cs.networkofferings["#{@netofferJObj['id']}"].should_not be_nil
    end

    it "should have new data for updated networkoffering" do

      @cs.networkofferings.each do |k, v|
        if v.name.eql? "TestNetworkOffering"
          @netofferObj = v
        end
      end

      @resp = @cs.root_admin.update_network_offering :id=>"#{@netofferObj.id}",
                                                     :state=>"Enabled"

      @cs.networkofferings["#{@netofferObj.id}"].state.should eq("Enabled")

    end

    it "should no have data for removed networkoffering" do
      @cs.networkofferings.each do |k, v|
        if v.name.eql? "TestNetworkOffering"
          @netofferObj = v
        end
      end
      @resp = @cs.root_admin.delete_network_offering :id=>"#{@netofferObj.id}"
      @cs.networkofferings["#{@netofferObj.id}"].should be_nil
    end 
  end
end

