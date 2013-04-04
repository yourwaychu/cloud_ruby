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
    include NetworkObsvrHelper::Vlan
    include NetworkObsvrHelper::PhysicalNetwork
    include NetworkObsvrHelper::TrafficType
    include NetworkObsvrHelper::Network
    include NetworkObsvrHelper::NetworkServiceProvider
    include ServiceOfferingObsvrHelper::ServiceOffering
    include ServiceOfferingObsvrHelper::DiskOffering
    include ServiceOfferingObsvrHelper::NetworkOffering
    include InfraObsvrHelper::Zone
    include InfraObsvrHelper::Pod
    include InfraObsvrHelper::Cluster
    include InfraObsvrHelper::Host
    include InfraObsvrHelper::StoragePool
    include InfraObsvrHelper::SecondaryStorage

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
                :storage_pools,
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
      @system_vms   = {}
      @networks     = {}
      @vlans        = {}
      @physical_networks = {}
      @network_offerings = {}
      @compute_offerings = {}
      @system_offerings  = {}
      @storage_pools = {}
      @secondary_storages = {}
      @disk_offerings     = {}

      register_root_admin
      self.add_observer @model_observer
      update_env
    end
  end
end
