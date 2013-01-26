#cs_domain_spec
require 'yaml'
require_relative '../cloudstack'

module Cloudstack_Infra
  describe CloudStack, "zone" do
    before(:all) do
      config = YAML.load_file("spec/config.yml")
      @host = config["development"]["host"]
      @port = config["development"]["port"]
      @apiport = config["development"]["apiport"]
      @cs = CloudStack::CloudStack.new "#{@host}", "#{@port}", "#{@apiport}"
    end  
    
    it "should have data for newly created zone" do
      @result = @cs.root_admin.create_zone :dns1=>"168.95.1.1",
                                           :internaldns1=>"10.1.191.69",
                                           :name=>"testzone",
                                           :networktype=>"Basic"
      @zoneJObj = @result["zone"]  
      @cs.zones["#{@zoneJObj['id']}"].should_not be_nil
    end 

    it "should have newly create physical network in the env" do
      @cs.zones.each do |k, v|
        if v.name.eql? "testzone"
          @zoneObj = v
        end
      end

      @result = @cs.root_admin.create_physical_network :name=>"testphysicalnetwork",
                                                       :zoneid=>"#{@zoneObj.id}"
     
      

      if @result['jobstatus'] == 1
        @cs.physical_networks.each do |k, v|
          if v.name.eql? "testphysicalnetwork"
            @physicalnetworkObj = v
          end
        end
      end
        
      @physicalnetworkObj.should_not be_nil
      @cs.zones["#{@physicalnetworkObj.zoneid}"].should_not be_nil
    end

    it "should have traffic type on on physical networks" do

      
    end


    # it "should have enabled status after update zone status" do
    #   @cs.zones.each do |k, v|
    #     if v.name.eql? "testzone"
    #       @zoneObj = v
    #     end
    #   end
    #   @result = @cs.root_admin.update_zone :id=>"#{@zoneObj.id}",
    #                                        :name=>"testzone_testing"

    #   @cs.zones["#{@zoneObj.id}"].name.should eq("testzone_testing")
    # end

    # it "should not have data for deleted zone" do
    #   @cs.zones.each do |k, v|
    #     if v.name.eql? "testzone_testing"
    #       @zoneObj = v
    #     end
    #   end
    #   @result = @cs.root_admin.delete_zone :id=>"#{@zoneObj.id}"
    #   @cs.zones["#{@zoneObj.id}"].should be_nil
    # end
  end
end
