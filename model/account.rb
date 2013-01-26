require 'active_support/all'

module CloudStack
  module Model
    
    class Account
      include AccountModelHelper
      cattr_accessor :attr_list
      attr_accessor :id, :name, :accounttype, :state, :users, :domainid
      @@attr_list=["id","name", "accounttype", "state", "domainid" ]

      # def initialize(args={})
      #   args.each do |k,v|
      #     instance_variable_set("@#{k}", v) unless v.nil?
      #   end
      # end
      def initialize
        @users={}
      end
    end
    
  end # End of module module
end # End of cloudstack module

