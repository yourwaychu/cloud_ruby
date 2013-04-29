require 'rest_client'
require 'json'
require_relative 'utils/config'
require_relative 'api/config'
require_relative 'obsvr_helper/config'
require_relative 'model_helper/config'
require_relative 'model/config'



module CloudStack
  class CloudStack
    include AccountsApiHelper::Domain
    include AccountsApiHelper::Account
    include AccountsApiHelper::User

    include InfraApiHelper::Zone
    include InfraApiHelper::Pod
    include InfraApiHelper::Cluster
    include InfraApiHelper::Host
    include InfraApiHelper::SystemVm
    include InfraApiHelper::StoragePool
    include NetworkApiHelper::Network
    include NetworkApiHelper::TrafficType
    include NetworkApiHelper::PhysicalNetwork
    include ServiceOfferingApiHelper::DiskOffering
    include ServiceOfferingApiHelper::ServiceOffering
    include ServiceOfferingApiHelper::NetworkOffering

    include Observable
    include CloudStackObserver
    include CloudStackMainHelper
    include MainModelHelper

    include AccountsObsvrHelper::Domain
    include AccountsObsvrHelper::Account
    include AccountsObsvrHelper::User
    include InfraObsvrHelper::Zone
    include InfraObsvrHelper::Network
    include InfraObsvrHelper::Pod
    include InfraObsvrHelper::Cluster
    include InfraObsvrHelper::Host
    # include NetworkObsvrHelper::Vlan
    # include NetworkObsvrHelper::PhysicalNetwork
    # include NetworkObsvrHelper::TrafficType
    # include NetworkObsvrHelper::Network
    # include NetworkObsvrHelper::NetworkServiceProvider
    # include ServiceOfferingObsvrHelper::ServiceOffering
    # include ServiceOfferingObsvrHelper::DiskOffering
    # include ServiceOfferingObsvrHelper::NetworkOffering
    # include InfraObsvrHelper::Zone
    # include InfraObsvrHelper::Pod
    # include InfraObsvrHelper::Cluster
    # include InfraObsvrHelper::Host
    # include InfraObsvrHelper::StoragePool
    # include InfraObsvrHelper::SecondaryStorage

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
                :storage_pools,
                :secondary_storages,
                :cs_agent


  
    def initialize(ip, port, i_port)
      @agent = CloudStackAgent.instance
      @logger   = Logger.new('cloudstack.sdk.log')
      @logger.level = Logger::WARN
      @obsvr        = EnvObserver.new(self)
      @request_url       = "http://#{ip}:#{port}/client/api"
      @admin_request_url = "http://#{ip}:#{i_port}/client/api"
      @domains      = {}
      @accounts     = {}
      @users        = {}
      @zones        = {}
      @pods         = {}
      @clusters     = {}
      @hosts        = {}
      @system_vms   = {}
      @networks     = {}
      @vlans        = {}
      @physical_networks  = {}
      @network_offerings  = {}
      @compute_offerings  = {}
      @system_offerings   = {}
      @storage_pools      = {}
      @secondary_storages = {}
      @disk_offerings     = {}
      @storage_vlans      = {}
      @network_service_providers = {}

      register_root_admin

      self.add_observer @obsvr

      @agent.api_url    = "http://#{ip}:#{port}/client/api"
      @agent.api_caller = @root_admin
      @agent.response   = "json"

      update_env
    end
  end
end
