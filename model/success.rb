module CloudStack
  module Model
      class Success < Raw
        cattr_accessor :attr_list

        attr_accessor :success

        @@attr_list = [:success]

        # override
        def pack(j_obj)
          self.class.attr_list.each do |attr|
            self.method(:"#{attr}".to_s.concat("=")).call j_obj[:"#{attr}".to_s].to_s
          end 
        end

      end
  end
end
