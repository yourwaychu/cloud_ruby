#cs_domain_spec
require 'yaml'
require_relative '../cloudstack'

module CloudStack_Domain
  describe CloudStack, "Account" do
    before(:all) do
      config = YAML.load_file("spec/config.yml")
      @host = config["development"]["host"]
      @port = config["development"]["port"]
      @apiport = config["development"]["apiport"]
      @cs = CloudStack::CloudStack.new "#{@host}", "#{@port}", "#{@apiport}"
    end  
    
    it "exists admin account" do
      @cs.accounts.each do |k, v|
        if v.name.eql? "admin"
          @accObj = v
        end
      end
      @accObj.name.should.eql? "admin"
    end
    
    it "create" do
      @resultObj = @cs.root_admin.create_account :accounttype=>0,
                                                 :email=>"tester@trend.com",
                                                 :firstname=>"tester",
                                                 :lastname=>"tester",
                                                 :password=>"novirus",
                                                 :username=>"tester"
      @accJObj = @resultObj['account']

      @cs.accounts["#{@accJObj['id']}"].name.should.eql? "tester"
      @cs.accounts["#{@accJObj['id']}"].users["#{@accJObj['user'][0]\
                                       ['id']}"].username.should.eql? "tester"
                                       
      @cs.users["#{@accJObj['user'][0]['id']}"].username.should.eql? "tester"
    end

    it "update" do
      @cs.accounts.each do |k, v|
        if v.name.eql? "tester"
          @accObj = v
        end
      end
      @resultObj = @cs.root_admin.update_account\
                                              :newname=> "tester_updated",
                                              :account=> "tester",
                                              :domainid=> "#{@accObj.domainid}"
      @accJObj = @resultObj['account']
      @cs.accounts["#{@accObj.id}"].name.should.eql? "tester_updated"
    end

    it "delete" do
      @cs.accounts.each do |k, v|
        if v.name.eql? "tester_updated"
          @accObj = v
        end
      end
      @resultObj = @cs.root_admin.delete_account :id=>@accObj.id

      @cs.domains["#{@accObj.domainid}"].accounts["#{@accObj.id}"]\
                                                                .should be_nil
                                                                
      @cs.accounts["#{@accObj.id}"].should be_nil
      @accObj.users.each do |k, v|
        @cs.users["#{v.id}"].should be_nil
      end
    end

  end 
end
