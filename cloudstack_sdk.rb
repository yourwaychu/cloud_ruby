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
    include AccountsApiHelper::Domain
    include InfraApiHelper::Zone

    attr_reader :request_url, :admin_request_url, :root_admin, :accounts,
                :users, :domains, :network_offerings, :disk_offerings,
                :service_offerings, :zones, :physical_networks, :templates,
                :pods, :clusters, :hosts, :systemvms
  
    def initialize(ip, port, i_port)
      @logger = Logger.new('cloudstack.sdk.log')
      @logger.level = Logger::WARN
      @observer = CloudStackEnvObserver.new(self)
      self.add_observer @observer
      @request_url = "http://#{ip}:#{port}/client/api"
      @admin_request_url = "http://#{ip}:#{i_port}/client/api"
      @domains      = {}
      @accounts     = {}
      @users        = {}
      @zones        = {}
      @pods         = {}
      @clusters     = {}
      @hosts        = {}
      @systemvms    = {}
      @physical_networks = {}
      @network_offerings = {}
      @service_offerings = {}
      @disk_offerings = {}
      register_root_admin
      update_env
    end
  end
end
