module CloudStack
  module Model
    class Raw
      include Observable
      attr_accessor :cs_helper, :model_observer
      def initialize(*args)
        if args && args[0]
          self.pack args[0]
        end
        
        if args[1]
          @cs_helper = args[1]
        end

        if args[2]
          @model_observer = args[2]
          self.add_observer @model_observer
        end
      end
      
      def pack(j_obj)
        self.class.attr_list.each do |attr|
          self.method(:"#{attr}".to_s.concat("=")).call j_obj[:"#{attr}".to_s]
        end 
        self
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
