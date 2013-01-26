#cs_disk_spec
require 'yaml'
require_relative '../cloudstack'

module CloudStack_Disk
  describe CloudStack, "Disk" do
    before(:all) do
      config = YAML.load_file("spec/config.yml")
      @host = config["development"]["host"]
      @port = config["development"]["port"]
      @apiport = config["development"]["apiport"]
      @cs = CloudStack::CloudStack.new "#{@host}", "#{@port}", "#{@apiport}"
    end

    it "should have data for newly created diskoffering" do
      @result = @cs.root_admin.create_disk_offering\
                                          :name=>"testdiskoffering",
                                          :displaytext=>"testdiskoffering",
                                          :storagetype=>"Shared",
                                          :customized=>"false",
                                          :disksize=>"100",
                                          :tags=>"test"
      @diskOfferJObj = @result['diskoffering']
      @cs.diskofferings["#{@diskOfferJObj['id']}"].should_not be_nil
    end

    it "should have new data for updated diskofferings" do
      @cs.diskofferings.each do |k, v|
        if v.name.eql? "testdiskoffering"
          @diskOfferObj = v
        end
      end
      @cs.root_admin.update_disk_offering :id=>"#{@diskOfferObj.id}",\
                                          :displaytext=>"for testing only"
      @cs.diskofferings["#{@diskOfferObj.id}"].displaytext.should eq("for testing only")
    end

    it "should have no data for deleted diskoffering" do
      @cs.diskofferings.each do |k, v|
        if v.name.eql? "testdiskoffering"
          @diskOfferObj = v
        end
      end
      @result = @cs.root_admin.delete_disk_offering :id=>"#{@diskOfferObj.id}"
      if @result['success'].eql? "true"
        @cs.diskofferings["#{@diskOfferObj.id}"].should be_nil
      end
    end
  end
end
