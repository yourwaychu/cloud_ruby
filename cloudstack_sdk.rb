require 'rest_client'
require 'json'
require 'cloudstack_helper'
require_relative 'utils/config'
require_relative 'api/config'
require_relative 'observer_helper/config'
require_relative 'model_helper/config'
require_relative 'model/config'



module CloudStack
  class CloudStack
    include Observable
    include CloudStackObserver
    include CloudStackMainHelper
    include AccountsObsvrHelper::Domain
    include AccountsObsvrHelper::Account
    include AccountsObsvrHelper::User
    include NetworkObsvrHelper
    include ServiceOfferingObsvrHelper
    include InfraObsvrHelper
    include MainModelHelper

    attr_reader :request_url,
                :admin_request_url, 
                :root_admin, 
                :accounts,
                :users, 
                :domains, 
                :network_offerings, 
                :disk_offerings,
                :compute_offerings,
                :system_offerings,
                :zones,
                :physical_networks, 
                :templates,
                :pods, 
                :clusters, 
                :hosts, 
                :system_vms, 
                :networks, 
                :vlans, 
                :secondary_storages,
                :cs_helper,
                :cs_agent
  
    def initialize(ip, port, i_port)
      @logger = Logger.new('cloudstack.sdk.log')
      @logger.level      = Logger::WARN
      @model_observer    = CloudStackEnvObserver.new(self)
      @request_url       = "http://#{ip}:#{port}/client/api"
      @admin_request_url = "http://#{ip}:#{i_port}/client/api"
      @domains      = {}
      @accounts     = {}
      @users        = {}
      @zones        = {}
      @pods         = {}
      @clusters     = {}
      @hosts        = {}
      @system_vms    = {}
      @networks     = {}
      @vlans        = {}
      @physical_networks  = {}
      @network_offerings  = {}
      @compute_offerings  = {}
      @system_offerings  = {}
      @secondary_storages = {}
      @disk_offerings     = {}

      register_root_admin
      self.add_observer @model_observer
      update_env
    end
  end
end
