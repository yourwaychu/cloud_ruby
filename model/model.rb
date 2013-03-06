module CloudStack
  module Model
    class Raw
      def initialize(*args)
        if args && args[0]
          self.pack args[0]
        end
      end
      
      def pack(j_obj)
        self.class.attr_list.each do |attr|
          self.method(:"#{attr}".to_s.concat("=")).call j_obj[:"#{attr}".to_s]
        end 
        self
      end
    end
  end
end
