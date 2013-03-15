module UserModelHelper

  def registerCSHelper(url, cs_instance)
    if self.apikey && self.secretkey  
      # GitHub CloudStackHelper
      @cs_helper = CloudStackHelper.new :api_key => self.apikey, 
                                        :secret_key => self.secretkey,
                                        :api_url => "#{url}"

      @cs_helper
    end
  end
end

