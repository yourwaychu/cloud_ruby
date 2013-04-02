#cs_service_offering
require 'yaml'
require_relative '../cloudstack'

module CloudStack_Testing
  describe CloudStack, "Service Offerings" do
    before(:all) do
      config   = YAML.load_file("spec/testconfig.yml")
      _host    = config["cloudstack"]["host"]
      _port    = config["cloudstack"]["port"]
      _apiport = config["cloudstack"]["apiport"]
      @cs      = CloudStack::CloudStack.new "#{_host}",
                                            "#{_port}",
                                            "#{_apiport}"
    end  

    it "create service offering" do
      serviceObj = @cs.root_admin.create_service_offering :name => "testserviceoffering",
                                                          :displaytext => "testserviceoffering",
                                                          :issystem => false,
                                                          :storagerttype => "shared",
                                                          :cpunumber => 1,
                                                          :cpuspeed => 512,
                                                          :memory => 240,
                                                          :networkrate => 1,
                                                          :offerha => true,
                                                          :tags => "test storage tag",
                                                          :hosttags => "test host tag",
                                                          :limitcpuuse => true,
                                                          :isvolatile => true

      @cs.compute_offerings["#{serviceObj.id}"].name.should.eql? "testserviceoffering"
    end

    it "update service offering" do
      @cs.compute_offerings.each do |k, v|
        if v.name.eql? "testserviceoffering"
          @serviceObj = v
        end
      end

      serviceObj = @cs.root_admin.update_service_offering :name => "updatedtestserviceoffering",
                                                          :displaytext => "updatedtestserviceoffering",
                                                          :id => "#{@serviceObj.id}"

      @cs.compute_offerings["#{serviceObj.id}"].name.should.eql? "updatedtestserviceoffering"
      @cs.compute_offerings["#{serviceObj.id}"].displaytext.should.eql? "updatedtestserviceoffering"
    end

    it "delete service offering" do
      @cs.compute_offerings.each do |k, v|
        if v.name.eql? "updatedtestserviceoffering"
          @serviceObj = v
        end
      end

      respObj = @cs.root_admin.delete_service_offering :id => "#{@serviceObj.id}"
      @cs.compute_offerings["#{@serviceObj.id}"].should be_nil
    end


    it "create service offering(oo)" do
      serviceObj = @cs.create_service_offering :name => "testserviceoffering",
                                               :displaytext => "testserviceoffering",
                                               :issystem => false,
                                               :storagerttype => "shared",
                                               :cpunumber => 1,
                                               :cpuspeed => 512,
                                               :memory => 240,
                                               :networkrate => 1,
                                               :offerha => true,
                                               :tags => "test storage tag",
                                               :hosttags => "test host tag",
                                               :limitcpuuse => true,
                                               :isvolatile => true

      @cs.compute_offerings["#{serviceObj.id}"].name.should.eql? "testserviceoffering"
    end

    it "update service offering(oo)" do
      @cs.compute_offerings.each do |k, v|
        if v.name.eql? "testserviceoffering"
          @serviceObj = v
        end
      end

      serviceObj = @serviceObj.update :name => "updatedtestserviceoffering",
                                      :displaytext => "updatedtestserviceoffering"

      @cs.compute_offerings["#{@serviceObj.id}"].name.should.eql? "updatedtestserviceoffering"
      @cs.compute_offerings["#{@serviceObj.id}"].displaytext.should.eql? "updatedtestserviceoffering"
    end

    it "delete service offering(oo)" do
      @cs.compute_offerings.each do |k, v|
        if v.name.eql? "updatedtestserviceoffering"
          @serviceObj = v
        end
      end

      respObj = @serviceObj.delete
      @cs.compute_offerings["#{@serviceObj.id}"].should be_nil
    end








    it "create disk offering" do
      diskObj = @cs.root_admin.create_disk_offering :ismirrored  => false,
                                                    :name        => "testdiskoffering",
                                                    :displaytext => "testserviceoffering",
                                                    :storagetype => "shared",
                                                    :customized  => "false",
                                                    :disksize    => 1,
                                                    :tags        => "test" 

      @cs.disk_offerings["#{diskObj.id}"].name.should.eql? "testdiskoffering"
    end

    it "update disk offering" do
      @cs.disk_offerings.each do |k, v|
        if v.name.eql? "testdiskoffering"
          @diskObj = v
        end
      end
      diskObj = @cs.root_admin.update_disk_offering :name        => "updatedtestdiskoffering",
                                                    :displaytext => "updatedtestdiskoffering",
                                                    :id          => "#{@diskObj.id}"

      @cs.disk_offerings["#{diskObj.id}"].name.should.eql? "updatedtestdiskoffering"
    end

    it "delete diskoffering" do
      @cs.disk_offerings.each do |k, v|
        if v.name.eql? "updatedtestdiskoffering"
          @diskObj = v
        end
      end
      resultObj = @cs.root_admin.delete_disk_offering :id => "#{@diskObj.id}" 
      if resultObj.success.eql? "true"
        @cs.disk_offerings["#{@diskObj.id}"].should be_nil
      end
    end
  end 
end
