module InfraObsvrHelper
  module Zone
  private
    def obsvr_create_zone(params, zoneObj)
      @zones["#{zoneObj.id}"] = zoneObj
    end

    def obsvr_update_zone(params, zoneObj)
      oldObj = @zones["#{zoneObj.id}"]
      SharedFunction.update_object oldObj, zoneObj
    end
    
    def obsvr_delete_zone(params, successObj)
      @zones.delete "#{params[:id]}"
    end
  end

  module Pod
  private
    def obsvr_create_pod(params, podObj)
      @pods["#{podObj.id}"] = podObj
      @zones["#{podObj.zoneid}"].pods["#{podObj.id}"] = podObj
    end

    def obsvr_update_pod(params, podObj)
      oldObj = @pods["#{podObj.id}"]
      SharedFunction.update_object oldObj, podObj
    end
    
    def obsvr_delete_pod(params, successObj)
      _tmp = @pods["#{params[:id]}"]
      @zones["#{_tmp.zoneid}"].pods.delete _tmp.id
      @pods.delete _tmp.id
    end
  end


  module Cluster
  private
    def obsvr_add_cluster(params, clusterList)
      clusterList.each do |cluster|
        @clusters["#{cluster.id}"] = cluster
      end
    end

    def obsvr_delete_cluster(params, successObj)
      @clusters.delete "#{params[:id]}"
    end

    def obsvr_update_cluster(params, clusterObj)
      oldObj = @clusters["#{clusterObj.id}"]
      SharedFunction.update_object oldObj, clusterObj
    end

    def obsvr_create_storage_pool(paramd, storageObj)
      @storage_pools["#{storageObj.id}"] = storageObj
    end
  end

  module Host
  private
    def obsvr_add_host(params, hostList)
      hostList.each do |host|
        @hosts["#{host.id}"] = host
      end
    end

    def obsvr_delete_host(params, successObj)
      _tmp = @hosts["#{params[:id]}"]
      @hosts.delete "#{_tmp.id}"
    end

    def obsvr_update_host(params, hostObj)
      puts "not implemented yet."
    end

    def obsvr_add_secondary_storage(params, hostObj)
      @hosts["#{hostObj.id}"]              = hostObj
      @secondary_storages["#{hostObj.id}"] = hostObj
    end
  end

  module Network
  private
    def obsvr_create_physical_network(params, pnObj)
      virtual_routers = list_network_service_providers :name => "VirtualRouter",
                                                       :physicalnetworkid => "#{pnObj.id}"


      security_groups = list_network_service_providers :name => "SecurityGroupProvider",
                                                       :physicalnetworkid => "#{pnObj.id}"

      virtual_routers.each do |vr|
        vr_elements = list_virtual_router_elements :nspid => "#{vr.id}"
        vr_elements.each do |vr_element|
          vr.virtual_router_elements["#{vr_element.id}"] = vr_element
        end
        @network_service_providers["#{vr.id}"] = vr
        pnObj.network_service_providers["#{vr.id}"] = vr
      end
      
      security_groups.each do |sg|
        pnObj.network_service_providers["#{sg.id}"] = sg
        @network_service_providers["#{sg.id}"] = sg
      end

      @physical_networks["#{pnObj.id}"] = pnObj
      @zones["#{pnObj.zoneid}"].physical_networks["#{pnObj.id}"] = pnObj
    end

    def obsvr_configure_virtual_router_element(params, elementObj)
      oldObj = @network_service_providers["#{elementObj.nspid}"]\
                                    .virtual_router_elements["#{elementObj.id}"]
      SharedFunction.update_object(oldObj, elementObj)
    end

    def obsvr_update_physical_network(params, pnObj)
      oldObj = @physical_networks["#{pnObj.id}"]
      SharedFunction.update_object(oldObj, pnObj)
    end

    def obsvr_delete_physical_network(params, successObj)
      @physical_networks.delete "#{params[:id]}"
    end

    def obsvr_add_traffic_type(params, trafficObj)
      @physical_networks["#{trafficObj.physicalnetworkid}"].traffic_types\
                                                       << trafficObj.traffictype
    end

    def obsvr_create_network(params, netObj)
      @networks["#{netObj.id}"] = netObj
    end

    def obsvr_delete_network(params, successObj)
      @networks.delete "#{params[:id]}"
    end

    def obsvr_update_network_service_provider(params, nspObj)
      oldObj = @network_service_providers["#{nspObj.id}"] 
      SharedFunction.update_object(oldObj, nspObj)
    end

    def obsvr_create_vlan_ip_range(params, vlanObj)
      @vlans["#{vlanObj.id}"] = vlanObj
      @physical_networks["#{vlanObj.physicalnetworkid}"].vlans["#{vlanObj.id}"] = vlanObj
    end

    def obsvr_delete_vlan_ip_range(params, successObj)
      _tmp = @vlans["#{params[:id]}"]
      @physical_networks["#{_tmp.physicalnetworkid}"].delete "#{_tmp.id}"
      @vlans.delete params[:id]
    end
  end
end
