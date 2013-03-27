#cs_service_offering
require 'yaml'
require_relative '../cloudstack'

module CloudStack_Testing
  describe CloudStack, "Service Offerings" do
    before(:all) do
      config = YAML.load_file("spec/testconfig.yml")
      @host     = config["development"]["host"]
      @port     = config["development"]["port"]
      @apiport  = config["development"]["apiport"]
      @cs       = CloudStack::CloudStack.new "#{@host}",
                                             "#{@port}",
                                             "#{@apiport}"
    end  

    it "create service offering" do
      serviceObj = @cs.root_admin.create_service_offering :name => "testoffering",
                                                          :displaytext => "testoffering",
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

      @cs.service_offerings["#{serviceObj.id}"].name.should.eql? "testoffering"
    end

    it "update service offering" do
      @cs.service_offerings.each do |k, v|
        if v.name.eql? "testoffering"
          @serviceObj = v
        end
      end

      serviceObj = @cs.root_admin.update_service_offering :name => "updatedtestoffering",
                                                          :displaytext => "updatedtestoffering",
                                                          :id => "#{@serviceObj.id}"

      @cs.service_offerings["#{serviceObj.id}"].name.should.eql? "updatedtestoffering"
      @cs.service_offerings["#{serviceObj.id}"].displaytext.should.eql? "updatedtestoffering"
    end

    it "delete service offering" do
      @cs.service_offerings.each do |k, v|
        if v.name.eql? "updatedtestoffering"
          @serviceObj = v
        end
      end

      respObj = @cs.root_admin.delete_service_offering :id => "#{@serviceObj.id}"
      @cs.service_offerings["#{@serviceObj.id}"].should be_nil
    end

    it "create disk offering" do
      diskObj = @cs.root_admin.create_disk_offering :ismirrored  => false,
                                                    :name        => "testdiskoffering",
                                                    :displaytext => "testoffering",
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
