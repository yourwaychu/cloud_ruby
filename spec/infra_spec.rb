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

    it "update zone (OO)" do
      @cs.zones.each do |k, v|
        if v.name.eql? "testzone"
          @zoneObj = v
        end
      end
      resultObj = @cs.update_zone :id => "#{@zoneObj.id}", :name => "testzone(updated)"

    end

    it "create_physical_network" do
      @cs.zones.each do |k, v|
        if v.name.eql? "testzone(updated)"
          @zoneObj = v
        end
      end
      @zoneObj.create_physical_network :name => "test physical network"
      
    end



    it "delete zone (OO)" do
      @cs.zones.each do |k, v|
        if v.name.eql? "testzone(updated)"
          @zoneObj = v
        end
        resultObj = @cs.delete_zone :id => "#{@zoneObj.id}", :cleanup => true
        if resultObj.success.eql? "true"
          @cs.zones["#{@zoneObj.id}"].should be_nil
        end
      end
    end
  end 
end
