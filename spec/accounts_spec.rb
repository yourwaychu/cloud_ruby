#cs_accounts_spec
require 'yaml'
require_relative '../cloudstack'

module CloudStack_Testing
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

    it "create user" do
      @domain  = @cs.domains.choose("ROOT").first
      @userObj = @cs.root_admin.create_user :username  => "testuser",
                                            :password  => "novirus",
                                            :email     => "testuesr@trend.com.tw",
                                            :firstname => "testuser",
                                            :lastname  => "testuser",
                                            :domainid  => "#{@domain.id}",
                                            :account   => "admin"

      @cs.users["#{@userObj.id}"].username.should.eql? "testuser"
    end

    it "update user" do
      @userObj = @cs.users.choose("testuser").first
      @userObj = @cs.root_admin.update_user :id       => "#{@userObj.id}",
                                            :username => "updatedtestuser"

      @cs.users["#{@userObj.id}"].username.should.eql? "updatedtestuser"
    end

    it "disable user" do
      @userObj = @cs.users.choose("updatedtestuser").first
      @userObj = @cs.root_admin.disable_user :id => "#{@userObj.id}"
      @cs.users["#{@userObj.id}"].state.should.eql? "disabled"
    end

    it "enable user" do
      @userObj = @cs.users.choose("updatedtestuser").first
      @userObj = @cs.root_admin.enable_user :id => "#{@userObj.id}"
      @cs.users["#{@userObj.id}"].state.should.eql? "enabled"
    end
    
    it "register user keys" do
      @userObj = @cs.users.choose("updatedtestuser").first
      @userkeys = @cs.root_admin.register_user_keys :id => "#{@userObj.id}"
      @cs.users["#{@userObj.id}"].apikey.should_not be_nil
      @cs.users["#{@userObj.id}"].secretkey.should_not be_nil
    end

    it "delete user" do
      @cs.users.each do |k, v|
        if v.username.eql? "updatedtestuser"
          @userObj = v
        end
      end
      @resultObj = @cs.root_admin.delete_user :id => "#{@userObj.id}"
      @cs.users["#{@userObj.id}"].should be_nil
    end

    it "create domain (OO)" do
      resultObj = @cs.create_domain :name => "oo test domain"
      @cs.domains["#{resultObj.id}"].name.should eql("oo test domain")
    end

    it "create account (OO)" do
      @cs.domains.each do |k, v|
        if v.name.eql? "oo test domain"
          @domainObj = v
        end
      end

      resultObj = @domainObj.create_account :accounttype => 0,
                                            :email       => "ootester@trend.com",
                                            :firstname   => "ootester",
                                            :lastname    => "ootester",
                                            :password    => "novirus",
                                            :username    => "ootester"

      @cs.accounts["#{resultObj.id}"].name.should eql("ootester")
      @cs.accounts["#{resultObj.id}"].domainid.should eql("#{@domainObj.id}")
      @cs.domains["#{@domainObj.id}"].accounts["#{resultObj.id}"].name.should eql("ootester")
    end

    it "create user (OO)" do
      @cs.accounts.each do |k, v|
        if v.name.eql? "ootester"
          @accObj = v
        end
      end

      resultObj = @accObj.create_user :username  => "ootestuser",
                                      :password  => "oonovirus",
                                      :email     => "ootestuesr@trend.com.tw",
                                      :firstname => "ootestuser",
                                      :lastname  => "ootestuser"

      @cs.users["#{resultObj.id}"].username.should eq("ootestuser")
      @accObj.users["#{resultObj.id}"].username.should eq("ootestuser") 
    end

    it "disable user (OO)" do
      @cs.users.each do |k, v|
        if v.username.eql? "ootestuser"
          @userObj = v
        end
      end
      @userObj.disable 
      
      @userObj.state.should eql("disabled")
      @cs.users["#{@userObj.id}"].state.should.eql? "disabled"
    end

    it "enable user (OO)" do
      @cs.users.each do |k, v|
        if v.username.eql? "ootestuser"
          @userObj = v
        end
      end
      @userObj.enable 
      @userObj.state.should eql("enabled")
      @cs.users["#{@userObj.id}"].state.should.eql? "enabled"
    end

    it "update user (OO)" do 
      @cs.users.each do |k, v|
        if v.username.eql? "ootestuser"
          @userObj = v
        end
      end
      @userObj.update :username => "ootestuser(updated)"
      @userObj.username.should eql("ootestuser(updated)")
      @cs.users["#{@userObj.id}"].username.should eq("ootestuser(updated)")
    end

    it "delete user (OO)" do
      @cs.users.each do |k, v|
        if v.username.eql? "ootestuser(updated)"
          @userObj = v
        end
      end
      
      @userObj.delete
      @cs.users["#{@userObj.id}"].should be_nil
    end

    it "update account (OO)" do
      @cs.accounts.each do |k, v|
        if v.name.eql? "ootester"
          @accObj = v
        end
      end
      
      @accObj.update :newname => "ootester(updated)"
      @accObj.name.should eq("ootester(updated)")
      @cs.accounts["#{@accObj.id}"].name.should eql("ootester(updated)")
    end

    it "delete account (OO)" do
      @cs.accounts.each do |k, v|
        if v.name.eql? "ootester(updated)"
          @accObj = v
        end
      end
      resultObj = @accObj.delete
      @cs.accounts["#{@accObj.id}"].should be_nil
    end

    it "update domain (OO)" do
      @cs.domains.each do |k, v|
        if v.name.eql? "oo test domain"
          @domainObj = v
        end
      end
      @domainObj.update :name => "oo test domain(updated)"
      @domainObj.name.should eql("oo test domain(updated)")
      @cs.domains["#{@domainObj.id}"].name.should.eql? "oo test domain(updated)"
     
    end

    it "delete domain(oo)" do
      @cs.domains.each do |k, v|
        if v.name.eql? "oo test domain(updated)"
          @domainObj = v
        end
      end

      resultObj = @domainObj.delete
      @cs.domains["#{@domainObj.id}"].should be_nil
    end

  end
end
