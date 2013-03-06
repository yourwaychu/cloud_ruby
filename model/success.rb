module CloudStack
  module Model
      class Success < Raw
        cattr_accessor :attr_list

        attr_accessor :success

        @@attr_list = [:success]

      end
  end
end
