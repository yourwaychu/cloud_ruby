module UserModelHelper

  def registerCSHelper(url, cs_instance)
    if self.apikey && self.secretkey  
      @cs_helper = CloudStackHelper.new(:api_key => self.apikey, 
                                        :secret_key => self.secretkey,
                                        :api_url => "#{url}")
      @cs_instance = cs_instance
    end
  end
end

