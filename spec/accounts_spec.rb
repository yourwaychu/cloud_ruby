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
    
    it "exists admin account" do
      @cs.accounts.each do |k, v|
        if v.name.eql? "admin"
          @accObj = v
        end
      end

      @accObj.name.should.eql? "admin"
    end


    it "create domains" do
      resultObj1 = @cs.root_admin.create_domain :name => "testdomain1"  

      resultObj2 = @cs.root_admin.create_domain :name => "testdomain2"  

      resultObj3 = @cs.root_admin.create_domain :name           => "testdomain1-1",
                                                :parentdomainid => "#{resultObj1.id}"

      resultObj4 = @cs.root_admin.create_domain :name           => "testdomain2-1",
                                                :parentdomainid => "#{resultObj2.id}"

      resultObj5 = @cs.root_admin.create_domain :name           => "testdomain1-1-1",
                                                :parentdomainid => "#{resultObj3.id}"


      @cs.domains["#{resultObj1.id}"].name.should eql("testdomain1")
      @cs.domains["#{resultObj2.id}"].name.should eql("testdomain2")
      @cs.domains["#{resultObj3.id}"].name.should eql("testdomain1-1")

      @cs.domains["#{resultObj1.id}"].domains["#{resultObj3.id}"].should_not be_nil
      @cs.domains["#{resultObj1.id}"].domains["#{resultObj3.id}"].name.should eq("testdomain1-1")
    end
    
    it "create accounts" do
      @cs.domains.each do |k, v|
        if v.name.eql? "testdomain1"
          @domainObj1 = v
        end
      end
      @cs.domains.each do |k, v|
        if v.name.eql? "testdomain2"
          @domainObj2 = v
        end
      end
      @cs.domains.each do |k, v|
        if v.name.eql? "testdomain1-1"
          @domainObj3 = v
        end
      end
      @cs.domains.each do |k, v|
        if v.name.eql? "testdomain2-1"
          @domainObj4 = v
        end
      end
      @cs.domains.each do |k, v|
        if v.name.eql? "testdomain1-1-1"
          @domainObj5 = v
        end
      end

      resultObj1 = @cs.root_admin.create_account :accounttype => 2,
                                                 :email       => "admintester1_1@testdomain.tw",
                                                 :firstname   => "admintester1_1",
                                                 :lastname    => "admintester1_1",
                                                 :username    => "admintester1_1",
                                                 :account     => "admintester1",
                                                 :password    => "novirus",
                                                 :domainid    => "#{@domainObj1.id}"

      resultObj2 = @cs.root_admin.create_account :accounttype => 0,
                                                 :email       => "usertester1_1@testdomain.tw",
                                                 :firstname   => "usertester1_1",
                                                 :lastname    => "usertester1_1",
                                                 :username    => "usertester1_1",
                                                 :account     => "usertester1",
                                                 :password    => "novirus",
                                                 :domainid    => "#{@domainObj1.id}"

      resultObj3 = @cs.root_admin.create_account :accounttype => 2,
                                                 :email       => "admintester2_1@testdomain.tw",
                                                 :firstname   => "admintester2_1",
                                                 :lastname    => "admintester2_1",
                                                 :username    => "admintester2_1",
                                                 :account     => "admintester2",
                                                 :password    => "novirus",
                                                 :domainid    => "#{@domainObj2.id}"
                                                                                           
      resultObj4 = @cs.root_admin.create_account :accounttype => 0,
                                                 :email       => "usertester2_1@testdomain.tw",
                                                 :firstname   => "usertester2_1",
                                                 :lastname    => "usertester2_1",
                                                 :username    => "usertester2_1",
                                                 :account     => "usertester2",
                                                 :password    => "novirus",
                                                 :domainid    => "#{@domainObj2.id}"

      resultObj5 = @cs.root_admin.create_account :accounttype => 2,
                                                 :email       => "admintester1-1_1@testdomain.tw",
                                                 :firstname   => "admintester1-1_1",
                                                 :lastname    => "admintester1-1_1",
                                                 :username    => "admintester1-1_1",
                                                 :account     => "admintester1-1",
                                                 :password    => "novirus",
                                                 :domainid    => "#{@domainObj3.id}"
                                                                                           
      resultObj6 = @cs.root_admin.create_account :accounttype => 0,
                                                 :email       => "usertester1-1_1@testdomain.tw",
                                                 :firstname   => "usertester1-1_1",
                                                 :lastname    => "usertester1-1_1",
                                                 :username    => "usertester1-1_1",
                                                 :account     => "usertester1-1",
                                                 :password    => "novirus",
                                                 :domainid    => "#{@domainObj3.id}"

      resultObj7 = @cs.root_admin.create_account :accounttype => 2,
                                                 :email       => "admintester2-1_1@testdomain.tw",
                                                 :firstname   => "admintester2-1_1",
                                                 :lastname    => "admintester2-1_1",
                                                 :username    => "admintester2-1_1",
                                                 :account     => "admintester2-1",
                                                 :password    => "novirus",
                                                 :domainid    => "#{@domainObj4.id}"
                                                                                           
      resultObj8 = @cs.root_admin.create_account :accounttype => 0,
                                                 :email       => "usertester2-1_1@testdomain.tw",
                                                 :firstname   => "usertester2-1_1",
                                                 :lastname    => "usertester2-1_1",
                                                 :username    => "usertester2-1_1",
                                                 :account     => "usertester2-1",
                                                 :password    => "novirus",
                                                 :domainid    => "#{@domainObj4.id}"

      resultObj9 = @cs.root_admin.create_account :accounttype => 2,
                                                 :email       => "admintester1-1-1_1@testdomain.tw",
                                                 :firstname   => "admintester1-1-1_1",
                                                 :lastname    => "admintester1-1-1_1",
                                                 :username    => "admintester1-1-1_1",
                                                 :account     => "admintester1-1-1",
                                                 :password    => "novirus",
                                                 :domainid    => "#{@domainObj5.id}"
                                                                                           
      resultObj10 = @cs.root_admin.create_account :accounttype => 0,
                                                  :email       => "usertester1-1-1_1@testdomain.tw",
                                                  :firstname   => "usertester1-1-1_1",
                                                  :lastname    => "usertester1-1-1_1",
                                                  :username    => "usertester1-1-1_1",
                                                  :account     => "usertester1-1-1",
                                                  :password    => "novirus",
                                                  :domainid    => "#{@domainObj5.id}"

      @cs.accounts["#{resultObj1.id}"].should_not be_nil
      @cs.accounts["#{resultObj1.id}"].name.should eq("admintester1")
      @cs.accounts["#{resultObj1.id}"].domainid.should eq("#{@domainObj1.id}")
      @cs.accounts["#{resultObj1.id}"].accounttype.should eq(2)
      @cs.users["#{resultObj1.users.values[0].id}"].should_not be_nil
      @cs.users["#{resultObj1.users.values[0].id}"].username.should eq("admintester1_1")
      @domainObj1.accounts["#{resultObj1.id}"].should_not be_nil
      @domainObj1.accounts["#{resultObj1.id}"].name.should eq("admintester1")
      @domainObj1.accounts["#{resultObj1.id}"].accounttype.should eq(2)

      @cs.accounts["#{resultObj2.id}"].should_not be_nil
      @cs.accounts["#{resultObj2.id}"].name.should eq("usertester1")
      @cs.accounts["#{resultObj2.id}"].domainid.should eq("#{@domainObj1.id}")
      @cs.accounts["#{resultObj2.id}"].accounttype.should eq(0)
      @cs.users["#{resultObj2.users.values[0].id}"].should_not be_nil
      @cs.users["#{resultObj2.users.values[0].id}"].username.should eq("usertester1_1")
      @domainObj1.accounts["#{resultObj2.id}"].should_not be_nil
      @domainObj1.accounts["#{resultObj2.id}"].name.should eq("usertester1")
      @domainObj1.accounts["#{resultObj2.id}"].accounttype.should eq(0)


      @cs.accounts["#{resultObj3.id}"].should_not be_nil
      @cs.accounts["#{resultObj3.id}"].name.should eq("admintester2")
      @cs.accounts["#{resultObj3.id}"].domainid.should eq("#{@domainObj2.id}")
      @cs.accounts["#{resultObj3.id}"].accounttype.should eq(2)
      @cs.users["#{resultObj3.users.values[0].id}"].should_not be_nil
      @cs.users["#{resultObj3.users.values[0].id}"].username.should eq("admintester2_1")
      @domainObj2.accounts["#{resultObj3.id}"].should_not be_nil
      @domainObj2.accounts["#{resultObj3.id}"].name.should eq("admintester2")
      @domainObj2.accounts["#{resultObj3.id}"].accounttype.should eq(2)

      @cs.accounts["#{resultObj4.id}"].should_not be_nil
      @cs.accounts["#{resultObj4.id}"].name.should eq("usertester2")
      @cs.accounts["#{resultObj4.id}"].domainid.should eq("#{@domainObj2.id}")
      @cs.accounts["#{resultObj4.id}"].accounttype.should eq(0)
      @cs.users["#{resultObj4.users.values[0].id}"].should_not be_nil
      @cs.users["#{resultObj4.users.values[0].id}"].username.should eq("usertester2_1")
      @domainObj2.accounts["#{resultObj4.id}"].should_not be_nil
      @domainObj2.accounts["#{resultObj4.id}"].name.should eq("usertester2")
      @domainObj2.accounts["#{resultObj4.id}"].accounttype.should eq(0)

      @cs.accounts["#{resultObj5.id}"].should_not be_nil
      @cs.accounts["#{resultObj5.id}"].name.should eq("admintester1-1")
      @cs.accounts["#{resultObj5.id}"].domainid.should eq("#{@domainObj3.id}")
      @cs.accounts["#{resultObj5.id}"].accounttype.should eq(2)
      @cs.users["#{resultObj5.users.values[0].id}"].should_not be_nil
      @cs.users["#{resultObj5.users.values[0].id}"].username.should eq("admintester1-1_1")
      @domainObj3.accounts["#{resultObj5.id}"].should_not be_nil
      @domainObj3.accounts["#{resultObj5.id}"].name.should eq("admintester1-1")
      @domainObj3.accounts["#{resultObj5.id}"].accounttype.should eq(2)

      @cs.accounts["#{resultObj6.id}"].should_not be_nil
      @cs.accounts["#{resultObj6.id}"].name.should eq("usertester1-1")
      @cs.accounts["#{resultObj6.id}"].domainid.should eq("#{@domainObj3.id}")
      @cs.accounts["#{resultObj6.id}"].accounttype.should eq(0)
      @domainObj3.accounts["#{resultObj6.id}"].should_not be_nil
      @domainObj3.accounts["#{resultObj6.id}"].name.should eq("usertester1-1")
      @domainObj3.accounts["#{resultObj6.id}"].accounttype.should eq(0)

      @cs.accounts["#{resultObj7.id}"].should_not be_nil
      @cs.accounts["#{resultObj7.id}"].name.should eq("admintester2-1")
      @cs.accounts["#{resultObj7.id}"].domainid.should eq("#{@domainObj4.id}")
      @cs.accounts["#{resultObj7.id}"].accounttype.should eq(2)
      @cs.users["#{resultObj7.users.values[0].id}"].should_not be_nil
      @cs.users["#{resultObj7.users.values[0].id}"].username.should eq("admintester2-1_1")
      @domainObj4.accounts["#{resultObj7.id}"].should_not be_nil
      @domainObj4.accounts["#{resultObj7.id}"].name.should eq("admintester2-1")
      @domainObj4.accounts["#{resultObj7.id}"].accounttype.should eq(2)

      @cs.accounts["#{resultObj8.id}"].should_not be_nil
      @cs.accounts["#{resultObj8.id}"].name.should eq("usertester2-1")
      @cs.accounts["#{resultObj8.id}"].domainid.should eq("#{@domainObj4.id}")
      @cs.accounts["#{resultObj8.id}"].accounttype.should eq(0)
      @cs.users["#{resultObj8.users.values[0].id}"].should_not be_nil
      @cs.users["#{resultObj8.users.values[0].id}"].username.should eq("usertester2-1_1")
      @domainObj4.accounts["#{resultObj8.id}"].should_not be_nil
      @domainObj4.accounts["#{resultObj8.id}"].name.should eq("usertester2-1")
      @domainObj4.accounts["#{resultObj8.id}"].accounttype.should eq(0)

      @cs.accounts["#{resultObj9.id}"].should_not be_nil
      @cs.accounts["#{resultObj9.id}"].name.should eq("admintester1-1-1")
      @cs.accounts["#{resultObj9.id}"].domainid.should eq("#{@domainObj5.id}")
      @cs.accounts["#{resultObj9.id}"].accounttype.should eq(2)
      @cs.users["#{resultObj9.users.values[0].id}"].should_not be_nil
      @cs.users["#{resultObj9.users.values[0].id}"].username.should eq("admintester1-1-1_1")
      @domainObj5.accounts["#{resultObj9.id}"].should_not be_nil
      @domainObj5.accounts["#{resultObj9.id}"].name.should eq("admintester1-1-1")
      @domainObj5.accounts["#{resultObj9.id}"].accounttype.should eq(2)

      @cs.accounts["#{resultObj10.id}"].should_not be_nil
      @cs.accounts["#{resultObj10.id}"].name.should eq("usertester1-1-1")
      @cs.accounts["#{resultObj10.id}"].domainid.should eq("#{@domainObj5.id}")
      @cs.accounts["#{resultObj10.id}"].accounttype.should eq(0)
      @cs.users["#{resultObj10.users.values[0].id}"].should_not be_nil
      @cs.users["#{resultObj10.users.values[0].id}"].username.should eq("usertester1-1-1_1")
      @domainObj5.accounts["#{resultObj10.id}"].should_not be_nil
      @domainObj5.accounts["#{resultObj10.id}"].name.should eq("usertester1-1-1")
      @domainObj5.accounts["#{resultObj10.id}"].accounttype.should eq(0)

    end

    it "create users" do
      @cs.accounts.each do |k, v|
        if v.name.eql? "admintester1"
          @acc1 = v
        end
      end
      @cs.accounts.each do |k, v|
        if v.name.eql? "usertester1"
          @acc2 = v
        end
      end
      @cs.accounts.each do |k, v|
        if v.name.eql? "admintester2"
          @acc3 = v
        end
      end
      @cs.accounts.each do |k, v|
        if v.name.eql? "usertester2"
          @acc4 = v
        end
      end
      @cs.accounts.each do |k, v|
        if v.name.eql? "admintester1-1"
          @acc5 = v
        end
      end
      @cs.accounts.each do |k, v|
        if v.name.eql? "usertester1-1"
          @acc6 = v
        end
      end
      @cs.accounts.each do |k, v|
        if v.name.eql? "admintester2-1"
          @acc7 = v
        end
      end
      @cs.accounts.each do |k, v|
        if v.name.eql? "usertester2-1"
          @acc8 = v
        end
      end
      @cs.accounts.each do |k, v|
        if v.name.eql? "admintester1-1-1"
          @acc9 = v
        end
      end
      @cs.accounts.each do |k, v|
        if v.name.eql? "usertester1-1-1"
          @acc10 = v
        end
      end

      resultObj1 = @cs.root_admin.create_user :username  => "admintester1_2",
                                              :email     => "admintester1_2@testdomain.tw",
                                              :firstname => "admintester1_2",
                                              :lastname  => "admintester1_2",
                                              :password  => "novirus",
                                              :domainid  => "#{@acc1.domainid}",
                                              :account   => "#{@acc1.name}"

      resultObj2 = @cs.root_admin.create_user :username  => "usertester1_2",
                                              :email     => "usertester1_2@testdomain.tw",
                                              :firstname => "usertester1_2",
                                              :lastname  => "usertester1_2",
                                              :password  => "novirus",
                                              :domainid  => "#{@acc2.domainid}",
                                              :account   => "#{@acc2.name}"

      resultObj3 = @cs.root_admin.create_user :username  => "admintester2_2",
                                              :email     => "admintester2_2@testdomain.tw",
                                              :firstname => "admintester2_2",
                                              :lastname  => "admintester2_2",
                                              :password  => "novirus",
                                              :domainid  => "#{@acc3.domainid}",
                                              :account   => "#{@acc3.name}"

      resultObj4 = @cs.root_admin.create_user :username  => "usertester2_2",
                                              :email     => "usertester2_2@testdomain.tw",
                                              :firstname => "usertester2_2",
                                              :lastname  => "usertester2_2",
                                              :password  => "novirus",
                                              :domainid  => "#{@acc4.domainid}",
                                              :account   => "#{@acc4.name}"

      resultObj5 = @cs.root_admin.create_user :username  => "admintester1-1_2",
                                              :email     => "admintester1-1_2@testdomain.tw",
                                              :firstname => "admintester1-1_2",
                                              :lastname  => "admintester1-1_2",
                                              :password  => "novirus",
                                              :domainid  => "#{@acc5.domainid}",
                                              :account   => "#{@acc5.name}"

      resultObj6 = @cs.root_admin.create_user :username  => "usertester1-1_2",
                                              :email     => "usertester1-1_2@testdomain.tw",
                                              :firstname => "usertester1-1_2",
                                              :lastname  => "usertester1-1_2",
                                              :password  => "novirus",
                                              :domainid  => "#{@acc6.domainid}",
                                              :account   => "#{@acc6.name}"

      resultObj7 = @cs.root_admin.create_user :username  => "admintester2-1_2",
                                              :email     => "admintester2-1_2@testdomain.tw",
                                              :firstname => "admintester2-1_2",
                                              :lastname  => "admintester2-1_2",
                                              :password  => "novirus",
                                              :domainid  => "#{@acc7.domainid}",
                                              :account   => "#{@acc7.name}"

      resultObj8 = @cs.root_admin.create_user :username  => "usertester2-1_2",
                                              :email     => "usertester2-1_2@testdomain.tw",
                                              :firstname => "usertester2-1_2",
                                              :lastname  => "usertester2-1_2",
                                              :password  => "novirus",
                                              :domainid  => "#{@acc8.domainid}",
                                              :account   => "#{@acc8.name}"

      resultObj9 = @cs.root_admin.create_user :username  => "admintester1-1-1_2",
                                              :email     => "admintester1-1-1_2@testdomain.tw",
                                              :firstname => "admintester1-1-1_2",
                                              :lastname  => "admintester1-1-1_2",
                                              :password  => "novirus",
                                              :domainid  => "#{@acc9.domainid}",
                                              :account   => "#{@acc9.name}"

      resultObj10 = @cs.root_admin.create_user :username  => "usertester1-1-1_2",
                                               :email     => "usertester1-1-1_2@testdomain.tw",
                                               :firstname => "usertester1-1-1_2",
                                               :lastname  => "usertester1-1-1_2",
                                               :password  => "novirus",
                                               :domainid  => "#{@acc10.domainid}",
                                               :account   => "#{@acc10.name}"

      @cs.users["#{resultObj1.id}"].should_not be_nil
      @cs.users["#{resultObj1.id}"].username.should eq("admintester1_2")
      @cs.accounts["#{resultObj1.accountid}"].users["#{resultObj1.id}"].should_not be_nil
      @cs.accounts["#{resultObj1.accountid}"].users["#{resultObj1.id}"].username.should eq("admintester1_2")

      @cs.users["#{resultObj2.id}"].should_not be_nil
      @cs.users["#{resultObj2.id}"].username.should eq("usertester1_2")
      @cs.accounts["#{resultObj2.accountid}"].users["#{resultObj2.id}"].should_not be_nil
      @cs.accounts["#{resultObj2.accountid}"].users["#{resultObj2.id}"].username.should eq("usertester1_2")

      @cs.users["#{resultObj3.id}"].should_not be_nil
      @cs.users["#{resultObj3.id}"].username.should eq("admintester2_2")
      @cs.accounts["#{resultObj3.accountid}"].users["#{resultObj3.id}"].should_not be_nil
      @cs.accounts["#{resultObj3.accountid}"].users["#{resultObj3.id}"].username.should eq("admintester2_2")

      @cs.users["#{resultObj4.id}"].should_not be_nil
      @cs.users["#{resultObj4.id}"].username.should eq("usertester2_2")
      @cs.accounts["#{resultObj4.accountid}"].users["#{resultObj4.id}"].should_not be_nil
      @cs.accounts["#{resultObj4.accountid}"].users["#{resultObj4.id}"].username.should eq("usertester2_2")

      @cs.users["#{resultObj5.id}"].should_not be_nil
      @cs.users["#{resultObj5.id}"].username.should eq("admintester1-1_2")
      @cs.accounts["#{resultObj5.accountid}"].users["#{resultObj5.id}"].should_not be_nil
      @cs.accounts["#{resultObj5.accountid}"].users["#{resultObj5.id}"].username.should eq("admintester1-1_2")

      @cs.users["#{resultObj6.id}"].should_not be_nil
      @cs.users["#{resultObj6.id}"].username.should eq("usertester1-1_2")
      @cs.accounts["#{resultObj6.accountid}"].users["#{resultObj6.id}"].should_not be_nil
      @cs.accounts["#{resultObj6.accountid}"].users["#{resultObj6.id}"].username.should eq("usertester1-1_2")

      @cs.users["#{resultObj7.id}"].should_not be_nil
      @cs.users["#{resultObj7.id}"].username.should eq("admintester2-1_2")
      @cs.accounts["#{resultObj7.accountid}"].users["#{resultObj7.id}"].should_not be_nil
      @cs.accounts["#{resultObj7.accountid}"].users["#{resultObj7.id}"].username.should eq("admintester2-1_2")

      @cs.users["#{resultObj8.id}"].should_not be_nil
      @cs.users["#{resultObj8.id}"].username.should eq("usertester2-1_2")
      @cs.accounts["#{resultObj8.accountid}"].users["#{resultObj8.id}"].should_not be_nil
      @cs.accounts["#{resultObj8.accountid}"].users["#{resultObj8.id}"].username.should eq("usertester2-1_2")

      @cs.users["#{resultObj9.id}"].should_not be_nil
      @cs.users["#{resultObj9.id}"].username.should eq("admintester1-1-1_2")
      @cs.accounts["#{resultObj9.accountid}"].users["#{resultObj9.id}"].should_not be_nil
      @cs.accounts["#{resultObj9.accountid}"].users["#{resultObj9.id}"].username.should eq("admintester1-1-1_2")

      @cs.users["#{resultObj10.id}"].should_not be_nil
      @cs.users["#{resultObj10.id}"].username.should eq("usertester1-1-1_2")
      @cs.accounts["#{resultObj10.accountid}"].users["#{resultObj10.id}"].should_not be_nil
      @cs.accounts["#{resultObj10.accountid}"].users["#{resultObj10.id}"].username.should eq("usertester1-1-1_2")
  
    end

    it "update user" do
      @cs.users.each do |k, v|
        if v.username.eql? "admintester1_1"
          @user1 = v
        end
      end

      user_obj1 = @cs.root_admin.update_user :id    => "#{@user1.id}",
                                             :email => "update.#{@user1.email}"

      @user1.email.should eq("update.admintester1_1@testdomain.tw")
      @cs.users["#{@user1.id}"].email.should eq("update.admintester1_1@testdomain.tw")
      @cs.accounts["#{@user1.accountid}"].users["#{@user1.id}"].email.should eq("update.admintester1_1@testdomain.tw")
    end

    it "delete domain" do
      @cs.domains.each do |k, v|
        if v.name.eql? "testdomain1"
          @domainObj1 = v
        end
      end
      @cs.domains.each do |k, v|
        if v.name.eql? "testdomain2"
          @domainObj2 = v
        end
      end
      @cs.domains.each do |k, v|
        if v.name.eql? "testdomain1-1"
          @domainObj3 = v
        end
      end
      @cs.domains.each do |k, v|
        if v.name.eql? "testdomain2-1"
          @domainObj4 = v
        end
      end
      @cs.domains.each do |k, v|
        if v.name.eql? "testdomain1-1-1"
          @domainObj5 = v
        end
      end

      resultObj5 = @cs.root_admin.delete_domain :id      => "#{@domainObj5.id}",
                                                :cleanup => true

      @cs.accounts.each do |k, v|
        if v.domainid.eql? "#{@domainObj5.id}"
          @rs5 << v
        end
      end

      @rs5.should be_nil

      if @domainObj5.parentdomainid
        @cs.domains["#{@domainObj5.parentdomainid}"].domains["#{@domainObj5.id}"].should be_nil
      end


      resultObj4 = @cs.root_admin.delete_domain :id      => "#{@domainObj4.id}",
                                                :cleanup => true

      @cs.accounts.each do |k, v|
        if v.domainid.eql? "#{@domainObj4.id}"
          @rs4 << v
        end
      end

      @rs4.should be_nil

      if @domainObj4.parentdomainid
        @cs.domains["#{@domainObj4.parentdomainid}"].domains["#{@domainObj4.id}"].should be_nil
      end

      resultObj3 = @cs.root_admin.delete_domain :id      => "#{@domainObj3.id}",
                                                :cleanup => true

      @cs.accounts.each do |k, v|
        if v.domainid.eql? "#{@domainObj3.id}"
          @rs3 << v
        end
      end

      @rs3.should be_nil

      if @domainObj3.parentdomainid
        @cs.domains["#{@domainObj3.parentdomainid}"].domains["#{@domainObj3.id}"].should be_nil
      end

      resultObj2 = @cs.root_admin.delete_domain :id      => "#{@domainObj2.id}",
                                                :cleanup => true

      @cs.accounts.each do |k, v|
        if v.domainid.eql? "#{@domainObj2.id}"
          @rs2 << v
        end
      end

      @rs2.should be_nil

      if @domainObj2.parentdomainid
        @cs.domains["#{@domainObj2.parentdomainid}"].domains["#{@domainObj2.id}"].should be_nil
      end

      resultObj1 = @cs.root_admin.delete_domain :id      => "#{@domainObj1.id}",
                                                :cleanup => true
      @cs.accounts.each do |k, v|
        if v.domainid.eql? "#{@domainObj1.id}"
          @rs1 << v
        end
      end

      @rs1.should be_nil

      if @domainObj1.parentdomainid
        @cs.domains["#{@domainObj1.parentdomainid}"].domains["#{@domainObj1.id}"].should be_nil
      end

    end

    it "create domain (OO)" do
      resultObj1 = @cs.create_domain :name => "domain1"
      resultObj2 = @cs.create_domain :name => "domain2"
      resultObj3 = @cs.domains["#{resultObj1.id}"].create_domain :name => "domain1-1"

      resultObj4 = @cs.domains["#{resultObj2.id}"].create_domain :name => "domain2-1"
      resultObj5 = @cs.domains["#{resultObj1.id}"].domains["#{resultObj3.id}"].create_domain :name => "domain1-1-1"

      @cs.domains["#{resultObj1.id}"].name.should eql("domain1")
      @cs.domains["#{resultObj2.id}"].name.should eql("domain2")
      @cs.domains["#{resultObj3.id}"].name.should eql("domain1-1")
      @cs.domains["#{resultObj1.id}"].domains["#{resultObj3.id}"].name.should eql("domain1-1")
      @cs.domains["#{resultObj4.id}"].name.should eql("domain2-1")
      @cs.domains["#{resultObj2.id}"].domains["#{resultObj4.id}"].name.should eql("domain2-1")
      @cs.domains["#{resultObj5.id}"].name.should eql("domain1-1-1")
      @cs.domains["#{resultObj1.id}"].domains["#{resultObj3.id}"].domains["#{resultObj5.id}"].name.should eql("domain1-1-1")
    end

    it "create account (OO)" do
      @cs.domains.each do |k, v|
        if v.name.eql? "domain1"
          @dObj1 = v
        end
      end

      @cs.domains.each do |k, v|
        if v.name.eql? "domain2"
          @dObj2 = v
        end
      end

      @cs.domains.each do |k, v|
        if v.name.eql? "domain1-1"
          @dObj3 = v
        end
      end

      @cs.domains.each do |k, v|
        if v.name.eql? "domain2-1"
          @dObj4 = v
        end
      end

      @cs.domains.each do |k, v|
        if v.name.eql? "domain1-1-1"
          @dObj5 = v
        end
      end

      resultObj1 = @dObj1.create_account :accounttype => 2,
                                         :email       => "admintester1_1@testdomain.tw",
                                         :firstname   => "admintester1_1",
                                         :lastname    => "admintester1_1",
                                         :username    => "admintester1_1",
                                         :account     => "admintester1",
                                         :password    => "novirus"

      resultObj2 = @dObj1.create_account :accounttype => 0,
                                         :email       => "usertester1_1@testdomain.tw",
                                         :firstname   => "usertester1_1",
                                         :lastname    => "usertester1_1",
                                         :username    => "usertester1_1",
                                         :account     => "usertester1",
                                         :password    => "novirus"

      resultObj3 = @dObj2.create_account :accounttype => 0,
                                         :email       => "admintester2_1@testdomain.tw",
                                         :firstname   => "admintester2_1",
                                         :lastname    => "admintester2_1",
                                         :username    => "admintester2_1",
                                         :account     => "admintester2",
                                         :password    => "novirus"

      resultObj4 = @dObj2.create_account :accounttype => 0,
                                         :email       => "usertester2_1@testdomain.tw",
                                         :firstname   => "usertester2_1",
                                         :lastname    => "usertester2_1",
                                         :username    => "usertester2_1",
                                         :account     => "usertester2",
                                         :password    => "novirus"


      resultObj5 = @dObj3.create_account :accounttype => 0,
                                         :email       => "admintester1-1_1@testdomain.tw",
                                         :firstname   => "admintester1-1_1",
                                         :lastname    => "admintester1-1_1",
                                         :username    => "admintester1-1_1",
                                         :account     => "admintester1-1",
                                         :password    => "novirus"

      @cs.accounts["#{resultObj1.id}"].name.should eql("admintester1")
      @cs.accounts["#{resultObj1.id}"].domainid.should eql("#{@dObj1.id}")
      @cs.domains["#{@dObj1.id}"].accounts["#{resultObj1.id}"].name.should eql("admintester1")
      @cs.domains["#{@dObj1.id}"].accounts["#{resultObj1.id}"].should equal(@cs.accounts["#{resultObj1.id}"])
      @cs.users["#{resultObj1.users.values[0].id}"].should_not be_nil
      @cs.users["#{resultObj1.users.values[0].id}"].username.should eql("admintester1_1")
    end
    # it "create user (OO)" do
    #   @cs.accounts.each do |k, v|
    #     if v.name.eql? "ootester"
    #       @accObj = v
    #     end
    #   end

    #   userObj = @accObj.create_user :username  => "ootestuser",
    #                                 :password  => "oonovirus",
    #                                 :email     => "ootestuesr@testdomain.tw",
    #                                 :firstname => "ootestuser",
    #                                 :lastname  => "ootestuser"

    #   @cs.users["#{userObj.id}"].username.should eq("ootestuser")
    #   @accObj.users["#{userObj.id}"].username.should eq("ootestuser") 
    #   @accObj.users["#{userObj.id}"].should equal(@cs.users["#{userObj.id}"])


    # end
    # 
    # it "create domain without register keys" do
    #   userObj = @cs.users.choose("ootestuser")[0]
    #   expect {userObj.create_domain :name => "baddomain"}.to raise_error
    # end

    # it "disable user (OO)" do
    #   @cs.users.each do |k, v|
    #     if v.username.eql? "ootestuser"
    #       @userObj = v
    #     end
    #   end
    #   @userObj.disable 
    #   
    #   @userObj.state.should eql("disabled")
    #   @cs.users["#{@userObj.id}"].state.should.eql? "disabled"
    # end

    # it "enable user (OO)" do
    #   @cs.users.each do |k, v|
    #     if v.username.eql? "ootestuser"
    #       @userObj = v
    #     end
    #   end
    #   @userObj.enable 
    #   @userObj.state.should eql("enabled")
    #   @cs.users["#{@userObj.id}"].state.should.eql? "enabled"
    # end

    # it "update user (OO)" do 
    #   @cs.users.each do |k, v|
    #     if v.username.eql? "ootestuser"
    #       @userObj = v
    #     end
    #   end
    #   @userObj.update :username => "ootestuser(updated)"
    #   @userObj.username.should eql("ootestuser(updated)")
    #   @cs.users["#{@userObj.id}"].username.should eq("ootestuser(updated)")
    # end

    # it "delete user (OO)" do
    #   @cs.users.each do |k, v|
    #     if v.username.eql? "ootestuser(updated)"
    #       @userObj = v
    #     end
    #   end
    #   
    #   @userObj.delete
    #   @cs.users["#{@userObj.id}"].should be_nil
    #   @cs.accounts["#{@userObj.accountid}"].users["#{@userObj}"].should be_nil
    # end

    # it "update account (OO)" do
    #   @cs.accounts.each do |k, v|
    #     if v.name.eql? "ootester"
    #       @accObj = v
    #     end
    #   end
    #   
    #   @accObj.update :newname => "ootester(updated)"
    #   @accObj.name.should eq("ootester(updated)")
    #   @cs.accounts["#{@accObj.id}"].name.should eql("ootester(updated)")
    # end

    # it "delete account (OO)" do
    #   @cs.accounts.each do |k, v|
    #     if v.name.eql? "ootester(updated)"
    #       @accObj = v
    #     end
    #   end
    #   resultObj = @accObj.delete
    #   @cs.accounts["#{@accObj.id}"].should be_nil
    # end

    # it "update domain (OO)" do
    #   @cs.domains.each do |k, v|
    #     if v.name.eql? "oo test domain"
    #       @domainObj = v
    #     end
    #   end
    #   @domainObj.update :name => "oo test domain(updated)"
    #   @domainObj.name.should eql("oo test domain(updated)")
    #   @cs.domains["#{@domainObj.id}"].name.should.eql? "oo test domain(updated)"
    #  
    # end

    it "delete domain(oo)" do
      @cs.domains.each do |k, v|
        if v.name.eql? "domain1"
          @dObj1 = v
        end
      end

      @cs.domains.each do |k, v|
        if v.name.eql? "domain2"
          @dObj2 = v
        end
      end

      @cs.domains.each do |k, v|
        if v.name.eql? "domain1-1"
          @dObj3 = v
        end
      end

      @cs.domains.each do |k, v|
        if v.name.eql? "domain2-1"
          @dObj4 = v
        end
      end

      @cs.domains.each do |k, v|
        if v.name.eql? "domain1-1-1"
          @dObj5 = v
        end
      end


      resultObj5 = @dObj5.delete
      @cs.domains["#{@dObj1.id}"].domains["#{@dObj3.id}"].domains["#{@dObj5.id}"].should be_nil
      resultObj4 = @dObj4.delete
      @cs.domains["#{@dObj2.id}"].domains["#{@dObj4.id}"].should be_nil
      resultObj3 = @dObj3.delete
      @cs.domains["#{@dObj1.id}"].domains["#{@dObj3.id}"].should be_nil
      resultObj2 = @dObj2.delete
      resultObj1 = @dObj1.delete

      @cs.domains["#{@dObj1.id}"].should be_nil
      @cs.domains["#{@dObj2.id}"].should be_nil
      @cs.domains["#{@dObj3.id}"].should be_nil
      @cs.domains["#{@dObj4.id}"].should be_nil
      @cs.domains["#{@dObj5.id}"].should be_nil
    end

    after(:all) do
      dobjs = @cs.root_admin.list_domains :listall => true
      dobjs.each do |dobj|
        if !dobj.name.eql? "ROOT"
          @cs.root_admin.delete_domain :id => "#{dobj.id}" 
        end
      end
    end

  end
end
