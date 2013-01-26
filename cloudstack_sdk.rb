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
    include DomainObsvrHelper
    include AccountObsvrHelper
    include UserObsvrHelper
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
      @request_url = "http://#{ip}:#{port}/client/api"
      @admin_request_url = "http://#{ip}:#{i_port}/client/api"
      @domains = {}
      @accounts = {}
      @users = {}
      @networkofferings = {}
      @diskofferings = {}
      @serviceofferings = {}
      @zones = {}
      @pods = {}
      @clusters = {}
      @hosts = {}
      @physical_networks = {}
      @templates = {}
      @observer = CloudStackEnvObserver.new(self)
      register_root_admin
      update_env_domains
      update_env_accounts
      update_env_users
      update_env_network_offerings
      update_env_disk_offerings
      update_env_service_offerings
      update_env_zones
      update_env_pods
      update_env_clusters
      update_env_hosts
      update_env_uservms
      update_env_ssvms
      update_env_pristorages
      update_env_secstorages
      update_env_vrouters
      update_env_templates
    end
  end
end



