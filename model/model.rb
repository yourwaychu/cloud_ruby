module CloudStack
  module Model
    class Raw
      include Observable
      attr_accessor :cs_agent, :model_observer, :p_node
      def initialize(*args)
        @cs_agent
        @model_observer

        
        if args && args[1]
          @cs_agent = args[1]
        end

        if args && args[2]
          @model_observer = args[2]
          self.add_observer @model_observer
        end

        if args && args[0]
          self.pack args[0]
        end

      end
      
      def pack(j_obj)
        self.class.attr_list.each do |attr|
          self.method(:"#{attr}".to_s.concat("=")).call j_obj[:"#{attr}".to_s]
        end 
      end

      def to_s
        resultarray = []
        if self.class.attr_list
          self.class.attr_list.each do |attr|
            v = self.method(attr).call
            resultarray << "#{attr} : #{ v && (!v.eql?("")) ? v : "N/A"}"
          end
        end
        "<[ "+resultarray.join(" , ")+" ]>"
      end
    end
  end
end
