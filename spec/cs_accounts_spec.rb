#cs_domain_spec
require 'yaml'
require_relative '../cloudstack'

module CloudStack_Domain
  describe CloudStack, "Account" do
    before(:all) do
      config = YAML.load_file("spec/config.yml")
      @host     = config["development"]["host"]
      @port     = config["development"]["port"]
      @apiport  = config["development"]["apiport"]
      @cs       = CloudStack::CloudStack.new "#{@host}",
                                             "#{@port}",
                                             "#{@apiport}"
    end  

    it "create domain" do
      resultObj = @cs.root_admin.create_domain :name => "testdomain"  

      @cs.domains["#{resultObj.id}"].name.should.eql? "testdomain"
    end
    

    it "update domain" do
      @cs.domains.each do |k, v|
        if v.name.eql? "testdomain"
          @domainObj = v
        end
      end
      resultObj = @cs.root_admin.update_domain :id      => "#{@domainObj.id}",
                                               :name    => "updatedtestdomain"

      @cs.domains["#{resultObj.id}"].name.should.eql? "updatedtestdomain"
    end

    it "delete domain" do
      @cs.domains.each do |k, v|
        if v.name.eql? "updatedtestdomain"
          @domainObj = v
        end
      end
      @cs.root_admin.delete_domain :id      => "#{@domainObj.id}",
                                   :cleanup => true

      @cs.domains["#{@domainObj.id}"].should be_nil
    end

    it "exists admin account" do
      @cs.accounts.each do |k, v|
        if v.name.eql? "admin"
          @accObj = v
        end
      end
      @accObj.name.should.eql? "admin"
    end
    
    it "create account" do
      resultObj = @cs.root_admin.create_account :accounttype=>0,
                                                :email=>"tester@trend.com",
                                                :firstname=>"tester",
                                                :lastname=>"tester",
                                                :password=>"novirus",
                                                :username=>"tester"

      @cs.accounts["#{resultObj.id}"].name.should.eql? "tester"
    end

    it "update account" do
      @cs.accounts.each do |k, v|
        if v.name.eql? "tester"
          @accObj = v
        end
      end
      resultObj = @cs.root_admin.update_account :newname=> "tester_updated",
                                                :account=> "tester",
                                                :domainid=> "#{@accObj.domainid}"

      @cs.accounts["#{@accObj.id}"].name.should.eql? "tester_updated"
    end

    it "delete account" do
      @cs.accounts.each do |k, v|
        if v.name.eql? "tester_updated"
          @accObj = v
        end
      end
      @resultObj = @cs.root_admin.delete_account :id=>@accObj.id

      @cs.accounts["#{@accObj.id}"].should be_nil
    end

  end 
end
