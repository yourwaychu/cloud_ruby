module CloudStackObserver
  class CloudStackEnvObserver
      def initialize(cs_instance)
        @cs_instance = cs_instance 
      end

      def update(invoking, h_para, j_data) 
        @cs_instance.method("#{invoking}").call(h_para, j_data)
      end
  end
end
