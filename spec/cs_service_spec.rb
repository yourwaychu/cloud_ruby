#cs_service_spec
require 'yaml'
require_relative '../cloudstack'

module CloudStack_Service
  describe CloudStack, "Service" do
    before(:all) do
      config = YAML.load_file("spec/config.yml")
      @host = config["development"]["host"]
      @port = config["development"]["port"]
      @apiport = config["development"]["apiport"]
      @cs = CloudStack::CloudStack.new "#{@host}", "#{@port}", "#{@apiport}"
    end

    it "should have data for newly created service offering" do
      @result = @cs.root_admin.create_service_offering\
                                          :name=>"testserviceoffering",
                                          :displaytext=>"testserviceoffering",
                                          :storagetype=>"shared",
                                          :cpunumber=>"4",
                                          :cpuspeed=>"2000",
                                          :memory=>"2000",
                                          :networkrate=>"10",
                                          :offerha=>"false",
                                          :tags=>"testserviceoffering",
                                          :hosttags=>"test",
                                          :limitscpuuse=>"false"
                                          
      @serviceOfferJObj = @result['serviceoffering']
      @cs.serviceofferings["#{@serviceOfferJObj['id']}"].should_not be_nil
    end

    it "should have new data for updated service offering" do
      @cs.serviceofferings.each do |k, v|
        if v.name.eql? "testserviceoffering"
          @serviceOfferObj = v
        end
      end
      @cs.root_admin.update_service_offering :id=>"#{@serviceOfferObj.id}",\
                                             :displaytext=>"for testing only"
      @cs.serviceofferings["#{@serviceOfferObj.id}"].displaytext.should eq("for testing only")
    end

    it "should have no data for deleted service offering" do
      @cs.serviceofferings.each do |k, v|
        if v.name.eql? "testserviceoffering"
          @serviceOfferObj = v
        end
      end
      @result = @cs.root_admin.delete_service_offering :id=>"#{@serviceOfferObj.id}"
      if @result['success'].eql? "true"
        @cs.serviceofferings["#{@serviceOfferObj.id}"].should be_nil
      end
    end
  end
end
