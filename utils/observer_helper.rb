module CloudStackObserver
  class CloudStackEnvObserver
      def initialize(cs_instance)
        @cs_instance = cs_instance 
      end

      def update(invoking, h_para, obj) 
        return @cs_instance.method("#{invoking}").call(h_para, obj)
      end
  end
  
  class CloudStackModelObserver
    def initialize(cs_instance)
      @cs_instance = cs_instance
      def update(obj_name) 
        return @cs_instance.method("update_env_#{obj_name}s").call
      end
    end
  end
end
