#infra_spec
require 'yaml'
require_relative '../cloudstack'

module CloudRubyTesting
  describe CloudStack, "Infra" do
    before(:all) do
      config        = YAML.load_file("spec/testconfig.yml")
      _host         = config["cloudstack"]["host"]
      _port         = config["cloudstack"]["port"]
      _apiport      = config["cloudstack"]["apiport"]
      _infra_config = config["infrastructure"]
      
      @cs_rspec   = CloudStack::CloudStack.new "#{_host}",
                                               "#{_port}",
                                               "#{_apiport}"
      @cs_rspec.deploy_infra(_infra_config)

      @cs         = CloudStack::CloudStack.new "#{_host}",
                                               "#{_port}",
                                               "#{_apiport}"
    end

    it "exist zone" do
      @cs.zones.each do |k, v|
        if v.name.eql? "testzone"
          @zoneObj = v
        end

        @zoneObj.should_not be_nil
      end
    end

    after(:all) do
      print "\n"
       config        = YAML.load_file("spec/testconfig.yml")
      _host         = config["cloudstack"]["host"]
      _port         = config["cloudstack"]["port"]
      _apiport      = config["cloudstack"]["apiport"]
      _infra_config = config["infrastructure"]
      
      @cs_rspec   = CloudStack::CloudStack.new "#{_host}",
                                               "#{_port}",
                                               "#{_apiport}"
      @cs_rspec.undeploy_infra(_infra_config)
     
    end
  end
end
