#cs_domain_spec
require 'yaml'
require_relative '../cloudstack'

module Cloudstack_Domain
  describe CloudStack, "User" do
    before(:all) do
      config = YAML.load_file("spec/config.yml")
      @host = config["development"]["host"]
      @port = config["development"]["port"]
      @apiport = config["development"]["apiport"]
      @cs = CloudStack::CloudStack.new "#{@host}", "#{@port}", "#{@apiport}"
    end  
    
    it "should have a default 'admin' user" do
      @cs.accounts.each do |k, v|
        if v.name.eql? "admin"
          @accObj = v
        end
      end
      @accObj.users.each do |k, v|
        if v.username.eql? "admin"
          @userObj = v
        end
      end
      @userObj.username.should.eql? "admin"
    end
    
    it "should have data for newly created user" do
      @result = @cs.root_admin.create_user :account=>"admin",
                                           :email=>"tester@trend.com",
                                           :firstname=>"tester",
                                           :lastname=>"tester",
                                           :password=>"novirus",
                                           :username=>"tester"
      @userJObj = @result['user']
      @cs.accounts.each do |k, v|
        if v.name.eql? "admin"
          @accObj = v
        end
      end

      @cs.accounts["#{@accObj.id}"].users["#{@userJObj['id']}"]\
                                          .username.should.eql? "tester"
      @cs.users["#{@userJObj['id']}"].username.should.eql? "tester"
    end


    it "should have keys and cs_helper for a user registering keys" do
      @cs.users.each do |k, v|
        if v.username.eql? "tester"
          @userObj = v
          @cs.accounts.each do |k, v|
            if v.name.eql? @userObj.account
              @accObj = v
            end
          end
        end
      end

      @result = @cs.root_admin.register_user_keys :id=>"#{@userObj.id}"

      @keyJObj = @result['userkeys']

      @userObj.apikey.should eq(@keyJObj['apikey'])
      @userObj.secretkey.should eq(@keyJObj['secretkey'])
      @accObj.users["#{@userObj.id}"].apikey.should eq(@keyJObj['apikey'])
      @accObj.users["#{@userObj.id}"].secretkey.should eq(@keyJObj['secretkey'])
      @accObj.users["#{@userObj.id}"].cs_helper.should_not be_nil
    end

    it "should not for a user account's user to create another user" do
      @cs.users.each do |k, v|
        if v.username.eql? "tester"
          @userObj = v
        end
      end
      @domainresp = @cs.root_admin.create_domain :name=>"domainfortesting" 

      @resultObj = @cs.root_admin.create_account :accounttype=>0,
                                                 :email=>"tester@trend.com",
                                                 :firstname=>"tester2",
                                                 :lastname=>"tester2",
                                                 :password=>"novirus",
                                                 :username=>"tester2",
                                                 :domainid=>"#{@domainresp['domain']['id']}"
      
      @cs.root_admin.register_user_keys :id=>"#{@resultObj['account']['user'][0]['id']}"

      @cs.users["#{@resultObj["account"]["user"][0]["id"]}"].create_user\
                                                      :account=>"tester2",
                                                      :email=>"tester3@trend.com",
                                                      :firstname=>"tester3",
                                                      :lastname=>"tester3",
                                                      :password=>"novirus",
                                                      :username=>"tester3",
                                                      :domainid=>"#{@domainresp['domain']['id']}"

      @cs.users.each do |k, v|
        if v.username.eql? "tester3"
          @targetuser = v
        end
      end
      @targetuser.should be_nil
      @cs.root_admin.delete_domain :id=>"#{@domainresp['domain']['id']}",
                                   :cleanup=>true
    end

    it "should clean up the data of recently deleted user" do
      @cs.users.each do |k, v|
        if v.username.eql? "tester"
          @userObj = v
        end
      end

      @cs.domains["#{@userObj.domainid}"].accounts.each do |k, v|
        if v.name.eql? @userObj.account
          @accObj = v
        end
      end

      result = @cs.root_admin.delete_user :id=>@userObj.id

      if result["success"].eql? "true"
        @cs.users["#{@userObj.id}"].should be_nil
        @accObj.users["#{@userObj.id}"].should be_nil
      end
    end

  end 
end
