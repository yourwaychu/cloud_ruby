module CloudStackObserver
  class CloudStackEnvObserver
      def initialize(cs_instance)
        @cs_instance = cs_instance 
      end

      def update(invoking, h_para, obj) 
        return @cs_instance.method("#{invoking}").call(h_para, obj)
      end
  end

  class CloudStackAgent
    
  end
end
