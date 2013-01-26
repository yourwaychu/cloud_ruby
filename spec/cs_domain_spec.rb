#cs_domain_spec
require 'yaml'
require_relative '../cloudstack'

module Cloudstack_Domain
  describe CloudStack, "Domain" do
    before(:all) do
      config = YAML.load_file("spec/config.yml")
      @host = config["development"]["host"]
      @port = config["development"]["port"]
      @apiport = config["development"]["apiport"]
      @cs = CloudStack::CloudStack.new "#{@host}", "#{@port}", "#{@apiport}"
    end  
    
    it "should have a default 'ROOT' domain" do
      @cs.domains.each do |k, v|
        if v.name.eql? "ROOT"
          @domainObj = v
        end
      end
      @domainObj.name.should.eql? "ROOT"
    end
    

    it "should return the domain object when root_admin is calling \
                              create_domain with correct parameters" do
        
    end
    
    it "should have data for newly created domain" do
      @domainJObj = @cs.root_admin.create_domain :name=>"testdomain"
      @cs.domains["#{@domainJObj['domain']['id']}"].name.should.eql? "testdomain"
    end

      
    it "should have new data for recently updated domain" do
      @cs.domains.each do |k, v|
        if v.name.eql? "testdomain"
          @domainJObj = v
        end

      end

      @domainJObj = @cs.root_admin.update_domain :id=>@domainJObj.id,
                                            :name=>"testdomain_updated"
      @cs.domains["#{@domainJObj['domain']['id']}"].name.should.eql? "testdomain_updated"
    end

    it "should have no data for deleted domain" do
      @cs.domains.each do |k, v|
        if v.name.eql? "testdomain_updated"
          @domainJObj = v
        end
      end

      result = @cs.root_admin.delete_domain :id=>@domainJObj.id,
                                                          :cleanup=>true
      if result == 1
        @cs.domains["#{@domainJObj.id}"].should be_nil
      end
    end

  end 
end
