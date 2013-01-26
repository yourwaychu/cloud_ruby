require 'active_support/all'

module CloudStack
  module Model
    
    class Domain
      cattr_accessor :attr_list
      attr_accessor :id, :name, :level, :parentdomainid, :path, :accounts,
                    :domains
      @@attr_list=["id", "name", "level" ,"parentdomainid", "path"]

      # def initialize(args={})
      #   args.each do |k,v|
      #     instance_variable_set("@#{k}", v) unless v.nil?
      #   end
      # end
      def initialize
        @accounts={}
        @domains={}
      end
    end # End of class
    
  end # End of module module
end # End of cloudstack module



