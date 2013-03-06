module CloudStack
  module Model
      class Error < Raw
        cattr_accessor :attr_list

        attr_accessor :errorcode,
                      :cserrorcode,
                      :errortext

        @@attr_list = [:errorcode,
                       :cserrorcode,
                       :errortext]

        def to_s
          "Error Code : #{errorcode}, CSError Code : #{cserrorcode}, Text : #{errortext}"
        end
      end
  end
end
