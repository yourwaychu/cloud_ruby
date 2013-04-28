#cs_accounts_spec
require 'yaml'
require_relative '../cloudstack'

module CloudRubyTesting
  describe CloudStack, "Account" do
    before(:all) do
      config      = YAML.load_file("spec/testconfig.yml")
      _host       = config["cloudstack"]["host"]
      _port       = config["cloudstack"]["port"]
      _apiport    = config["cloudstack"]["apiport"]
      _acc_config = config["accounts"]
      
      @cs_rspec   = CloudStack::CloudStack.new "#{_host}",
                                               "#{_port}",
                                               "#{_apiport}"
      @cs_rspec.deploy_accounts(_acc_config)

      @cs         = CloudStack::CloudStack.new "#{_host}",
                                               "#{_port}",
                                               "#{_apiport}"
    end

    it "exists ROOT domain" do
      @cs.domains.each do |k, v|
        if v.name.eql? "ROOT"
          @domObj = v
        end
      end

      @domObj.name.should.eql? "ROOT"
    end

    it "exists admin account" do
      @cs.accounts.each do |k, v|
        if v.name.eql? "admin"
          @accObj = v
        end
      end

      @accObj.name.should.eql? "admin"
    end

    it "disable exists account" do
      @cs.users.each do |k, v|
        if v.username.eql? "rootuser1"
          @userObj = v
        end
      end

      resultObj = @userObj.disable

      @cs.users["#{@userObj.id}"].state.should eql("disabled")
    end

    it "enable exists account" do
      @cs.users.each do |k, v|
        if v.username.eql? "rootuser1"
          @userObj = v
        end
      end

      resultObj = @userObj.enable

      @cs.users["#{@userObj.id}"].state.should eql("enabled")
    end

    it "exists domain1 domain" do
      @cs.domains.each do |k, v|
        if v.name.eql? "domain1"
          @domObj = v
        end
      end

      @domObj.name.should eql("domain1")
    end

    it "exists domain2 domain" do
      @cs.domains.each do |k, v|
        if v.name.eql? "domain2"
          @domObj = v
        end
      end

      @domObj.name.should eql("domain2")
    end

    it "exists domain1-1 domain" do
      @cs.domains.each do |k, v|
        if v.name.eql? "domain1-1"
          @domObj = v
        end
      end

      @domObj.name.should eql("domain1-1")
      @cs.domains["#{@domObj.parentdomainid}"].domains["#{@domObj.id}"].name.should eql("domain1-1")
    end

    it "create new domain" do
      @cs.domains.each do |k, v|
        if v.name.eql? "domain2"
          @domObj = v
        end
      end
      resultObj = @cs.root_admin.create_domain :name => "domain2-1", :parentdomainid => "#{@domObj.id}"

      @cs.domains["#{resultObj.id}"].name.should eql("domain2-1")
      @cs.domains["#{resultObj.parentdomainid}"].domains["#{resultObj.id}"].name.should eql("domain2-1")
    end

    it "create new account" do
      @cs.domains.each do |k, v|
        if v.name.eql? "domain2-1"
          @domObj = v
        end
      end

      resultObj = @cs.root_admin.create_account :accounttype => 2,
                                                :email       => "domain2-1admin1@test.com",
                                                :firstname   => "domain2-1admin1",
                                                :lastname    => "domain2-1admin1", 
                                                :username    => "domain2-1admin1", 
                                                :account     => "domain2-1admin", 
                                                :password    => "novirus", 
                                                :domainid    => "#{@domObj.id}" 

      @cs.domains["#{@domObj.id}"].accounts["#{resultObj.id}"].name.should eql("domain2-1admin")
      @cs.accounts["#{resultObj.id}"].name.should eql("domain2-1admin")
    end

    it "create new user" do
      @cs.accounts.each do |k, v|
        if v.name.eql? "domain2-1admin"
          @accObj = v
        end
      end

      resultObj = @cs.root_admin.create_user :username  => "domain2-1admin2", 
                                             :email     => "domain2-1admin2@test.com", 
                                             :firstname => "domain2-1admin2", 
                                             :lastname  => "domain2-1admin2", 
                                             :password  => "novirus", 
                                             :domainid  => "#{@accObj.domainid}", 
                                             :account   => "#{@accObj.name}"
      
      @cs.users["#{resultObj.id}"].username.should eql("domain2-1admin2")
      @cs.users["#{resultObj.id}"].should eq(@cs.accounts["#{@accObj.id}"].users["#{resultObj.id}"])
    end

    it "update user" do
      @cs.users.each do |k, v|
        if v.username.eql? "domain2-1admin2"
          @userObj = v
        end
      end

      resultObj = @cs.root_admin.update_user :id    => "#{@userObj.id}",
                                             :email => "domain2-1admin2updated@test.com"

      @cs.users["#{resultObj.id}"].email.should eql("domain2-1admin2updated@test.com")
      @cs.users["#{resultObj.id}"].should eq(@cs.accounts["#{@userObj.accountid}"].users["#{resultObj.id}"])
    end

    it "request user with no keys" do
      @cs.users.each do |k, v|
        if v.username.eql? "domain2-1admin2"
          @userObj = v
        end
      end
      expect {
        resultObj = @userObj.list_domains
      }.to raise_error
    end

    it "register user keys" do
      @cs.users.each do |k, v|
        if v.username.eql? "domain2-1admin2"
          @userObj = v
        end
      end
      resultObj = @cs.root_admin.register_user_keys :id => "#{@userObj.id}"

      @cs.users["#{@userObj.id}"].apikey.should eql(resultObj.apikey)
    end

    it "request user with keys" do
      @cs.users.each do |k, v|
        if v.username.eql? "domain2-1admin2"
          @userObj = v
        end
      end

      resultObj = @userObj.list_domains

      resultObj.length.should eql(1) # show it's own domain
      resultObj[0].name.should eql("domain2-1")
    end

    it "disable user" do
      @cs.users.each do |k, v|
        if v.username.eql? "domain2-1admin2"
          @userObj = v
        end
      end
      resultObj = @cs.root_admin.disable_user :id => "#{@userObj.id}"
      @userObj.state.should eql("disabled")
    end

    it "enable user" do
      @cs.users.each do |k, v|
        if v.username.eql? "domain2-1admin2"
          @userObj = v
        end
      end
      resultObj = @cs.root_admin.enable_user :id => "#{@userObj.id}"
      @userObj.state.should eql("enabled")
    end

    it "delete user" do
      @cs.users.each do |k, v|
        if v.username.eql? "domain2-1admin2"
          @userObj = v
        end
      end
      resultObj = @cs.root_admin.delete_user :id => "#{@userObj.id}"
      
      @cs.users["#{@userObj.id}"].should be_nil
      @cs.accounts["#{@userObj.accountid}"].users["#{@userObj.id}"].should be_nil
    end

    it "update account" do
      @cs.accounts.each do |k, v|
        if v.name.eql? "domain2-1admin"
          @accObj = v
        end
      end

      resultObj = @cs.root_admin.update_account :id      => "#{@accObj.id}",
                                                :newname => "domain2-1admin(updated)"
      @cs.domains["#{@accObj.domainid}"].accounts["#{resultObj.id}"].name.should eql("domain2-1admin(updated)")
      @cs.accounts["#{resultObj.id}"].name.should eql("domain2-1admin(updated)")
    end

    it "delete account" do
      @cs.accounts.each do |k, v|
        if v.name.eql? "domain2-1admin(updated)"
          @accObj = v
        end
      end
      resultObj = @cs.root_admin.delete_account :id => "#{@accObj.id}"
      @cs.domains["#{@accObj.domainid}"].accounts["#{@accObj.id}"].should be_nil
      @cs.accounts["#{@accObj.id}"].should be_nil
    end

    it "update domain" do
      @cs.domains.each do |k, v|
        if v.name.eql? "domain2"
          @domObj = v
        end
      end
      resultObj = @cs.root_admin.update_domain :id => "#{@domObj.id}",
                                               :name => "domain2-1(updated)"

      @cs.domains["#{resultObj.id}"].name.should eql("domain2-1(updated)")
      @cs.domains["#{resultObj.parentdomainid}"].domains["#{resultObj.id}"].name.should eql("domain2-1(updated)")
    end

    it "delete new domain" do
      @cs.domains.each do |k, v|
        if v.name.eql? "domain2-1(updated)"
          @domObj = v
        end
      end
      resultObj = @cs.root_admin.delete_domain :id => "#{@domObj.id}", :cleanup => true

      @cs.domains["#{@domObj.id}"].should be_nil
      @cs.domains["#{@domObj.parentdomainid}"].domains["#{@domObj.id}"].should be_nil
    end

    it "create domain(object-oriented)" do
      @cs.domains.each do |k, v|
        if v.name.eql? "domain1"
          @domObj = v
        end
      end

      resultObj = @domObj.create_domain :name => "domain1-2"
      @cs.domains["#{resultObj.id}"].name.should eql("domain1-2")
      @cs.domains["#{resultObj.id}"].should eq(@cs.domains["#{resultObj.parentdomainid}"].domains["#{resultObj.id}"])
    end

    it "udpate domain (object-oriented)" do
      @cs.domains.each do |k, v|
        if v.name.eql? "domain1-2"
          @domObj = v
        end
      end

      resultObj = @domObj.update :name => "domain1-2(updated)"
      @cs.domains["#{resultObj.id}"].name.should eql("domain1-2(updated)")
    end

    it "create account (object-oriented)" do
      @cs.domains.each do |k, v|
        if v.name.eql? "domain1-2(updated)"
          @domObj = v
        end
      end
      resultObj = @domObj.create_account :accounttype => 2,
                                         :email       => "domain1-2admin1@test.com",
                                         :firstname   => "domain1-2admin1",
                                         :lastname    => "domain1-2admin1", 
                                         :username    => "domain1-2admin1", 
                                         :account     => "domain1-2admin", 
                                         :password    => "novirus"

      @domObj.accounts["#{resultObj.id}"].name.should eql("domain1-2admin")
    end

    it "create user (object-oriented)" do
      @cs.accounts.each do |k, v|
        if v.name.eql? "domain1-2admin"
          @accObj = v
        end
      end
      resultObj = @accObj.create_user :username  => "domain1-2admin2", 
                                      :email     => "domain1-2admin2@test.com", 
                                      :firstname => "domain1-2admin2", 
                                      :lastname  => "domain1-2admin2", 
                                      :password  => "novirus"

      @cs.users["#{resultObj.id}"].username.should eql("domain1-2admin2")
    end

    it "update user (object-oriented)" do
      @cs.users.each do |k, v|
        if v.username.eql? "domain1-2admin2"
          @userObj = v
        end
      end

      resultObj = @userObj.update :email => "domain1-2admin2updated@test.com"
      @cs.users["#{resultObj.id}"].email.should eql("domain1-2admin2updated@test.com")
    end

    it "diable user (object-oriented)" do
      @cs.users.each do |k, v|
        if v.username.eql? "domain1-2admin2"
          @userObj = v
        end
      end
      resultObj = @userObj.disable
      @cs.users["#{resultObj.id}"].state.should eql("disabled")
    end

    it "enable user (object-oriented)" do
      @cs.users.each do |k, v|
        if v.username.eql? "domain1-2admin2"
          @userObj = v
        end
      end
      resultObj = @userObj.enable
      @cs.users["#{resultObj.id}"].state.should eql("enabled")
    end

    it "delete user (object-oriented)" do
      @cs.users.each do |k, v|
        if v.username.eql? "domain1-2admin2"
          @userObj = v
        end
      end
      resultObj = @userObj.delete
      @cs.users["#{@userObj.id}"].should be_nil
    end

    it "update account (object-oriented)" do
      @cs.accounts.each do |k, v|
        if v.name.eql? "domain1-2admin"
          @accObj = v
        end
      end

      resultObj = @accObj.update :newname => "domain1-2admin(updated)"

      @cs.accounts["#{resultObj.id}"].name.should eql("domain1-2admin(updated)")
    end


    it "delete account (object-oriented)" do
      @cs.accounts.each do |k, v|
        if v.name.eql? "domain1-2admin(updated)"
          @accObj = v
        end
      end
      resultObj = @accObj.delete

      @cs.accounts["#{@accObj.id}"].should be_nil
    end

    it "delete domain (object-oriented)" do
      @cs.domains.each do |k, v|
        if v.name.eql? "domain1-2(updated)"
          @domObj = v
        end
      end
      resultObj = @domObj.delete
      @cs.domains["#{@domObj.id}"].should be_nil
      @cs.domains["#{@domObj.parentdomainid}"].domains["#{@domObj.id}"].should be_nil
    end

    after(:all) do
      print "\n"
      config      = YAML.load_file("spec/testconfig.yml")
      _host       = config["cloudstack"]["host"]
      _port       = config["cloudstack"]["port"]
      _apiport    = config["cloudstack"]["apiport"]
      _acc_config = config["accounts"]
      
      @cs_rspec   = CloudStack::CloudStack.new "#{_host}",
                                               "#{_port}",
                                               "#{_apiport}"
      @cs_rspec.undeploy_accounts(_acc_config)
    end
  end
end
