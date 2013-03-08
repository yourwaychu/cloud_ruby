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

    include CloudStackObserver
    include CloudStackMainHelper
    include AccountsObsvrHelper
    include NetworkObsvrHelper
    include DiskOfferingObsvrHelper
    include ServiceOfferingObsvrHelper
    include InfraObsvrHelper

    attr_reader :request_url, :admin_request_url, :root_admin, :accounts,
                :users, :domains, :networkofferings, :diskofferings,
                :serviceofferings, :zones, :physical_networks, :templates,
                :pods, :clusters, :hosts
  
    def initialize(ip, port, i_port)
      logger = Logger.new('cloudstack.sdk.log')
      logger.level = Logger::WARN
      @observer = CloudStackEnvObserver.new(self)
      #@modelobserver = CloudStackModelObserver.new(self)
      @request_url = "http://#{ip}:#{port}/client/api"
      @admin_request_url = "http://#{ip}:#{i_port}/client/api"
      @domains      = {}
      @accounts     = {}
      @users        = {}
      @zones        = {}
      @pods         = {}
      @clusters     = {}
      @hosts        = {}
      @physical_networks = {}
      @networkofferings = {}
      # @diskofferings = {}
      # @serviceofferings = {}
      # @templates = {}
      register_root_admin
      update_env
    end
  end
end
