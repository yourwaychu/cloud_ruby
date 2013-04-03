module NetworkObsvrHelper

  module Vlan
  private
    def obsvr_create_vlan_ip_range(params, vlanObj)
      @vlans["#{vlanObj.id}"] = vlanObj
      _pod = @pods["#{vlanObj.podid}"]
      vlanObj.p_node = _pod
      @zones["#{vlanObj.zoneid}"].pods["#{vlanObj.podid}"].vlans["#{vlanObj.id}"] = vlanObj
    end

    def obsvr_delete_vlan_ip_range(params, respObj)
      _vlan = @vlans["#{params[:id]}"] 
      _pod  = @pods["#{_vlan.podid}"]
      @vlans.delete "#{_vlan.id}"
      _pod.vlans.delete "#{_vlan.id}"
    end
    
    def obsvr_model_delete_vlan_ip_range(params, respObj)
      _vlan = @vlans["#{params[:id]}"] 
      _pod  = @pods["#{_vlan.podid}"]
      @vlans.delete "#{_vlan.id}"
    end

    def obsvr_model_create_vlan_ip_range(params, vlanObj)
      @vlans["#{vlanObj.id}"] = vlanObj
    end
  end

  module PhysicalNetwork
  private
    def obsvr_model_create_physical_network(h_para, pnObj)
      @physical_networks["#{pnObj.id}"] = pnObj
      zoneObj = @zones["#{pnObj.zoneid}"]
      zoneObj.physical_networks.merge!({"#{pnObj.id}" => pnObj})
      @vr_networkserviceproviders = @root_admin.list_network_service_providers :name => "VirtualRouter",
                                                                               :physicalnetworkid  => "#{pnObj.id}"

      @sg_networkserviceproviders = @root_admin.list_network_service_providers :name => "SecurityGroupProvider",
                                                                               :physicalnetworkid  => "#{pnObj.id}"

      @vr_networkserviceproviders.each do |vrsp|

        @virtualrouterelements = @root_admin.list_virtual_router_elements :nspid => "#{vrsp.id}"

        @virtualrouterelements.each do |vre|
          vre.physicalnetworkid = pnObj.id
          vrsp.virtual_router_elements["#{vre.id}"] = vre
        end
          
        pnObj.network_service_providers["#{vrsp.id}"] = vrsp
      end

      @sg_networkserviceproviders.each do |sgsp|
        pnObj.network_service_providers["#{sgsp.id}"] = sgsp
      end
      @physical_networks["#{pnObj.id}"] = pnObj
    end

    def obsvr_create_physical_network(h_para, pnObj)
      @physical_networks["#{pnObj.id}"] = pnObj
      zoneObj = @zones["#{pnObj.zoneid}"]
      pnObj.p_node = zoneObj
      zoneObj.physical_networks.merge!({"#{pnObj.id}" => pnObj})
      @vr_networkserviceproviders = @root_admin.list_network_service_providers :name => "VirtualRouter",
                                                                            :physicalnetworkid  => "#{pnObj.id}"

      @sg_networkserviceproviders = @root_admin.list_network_service_providers :name => "SecurityGroupProvider",
                                                                               :physicalnetworkid  => "#{pnObj.id}"

      @vr_networkserviceproviders.each do |vrsp|


        @virtualrouterelements = @root_admin.list_virtual_router_elements :nspid => "#{vrsp.id}"

        @virtualrouterelements.each do |vre|
          vre.physicalnetworkid = pnObj.id
          vrsp.virtual_router_elements["#{vre.id}"] = vre
        end
          
        pnObj.network_service_providers["#{vrsp.id}"] = vrsp
      end

      @sg_networkserviceproviders.each do |sgsp|
        pnObj.network_service_providers["#{sgsp.id}"] = sgsp
      end
      @physical_networks["#{pnObj.id}"] = pnObj
    end

    def obsvr_delete_physical_network(h_para, pnObj)
      pnObj = @physical_networks["#{h_para[:id]}"] 
      @physical_networks.delete pnObj.id
      @zones["#{pnObj.zoneid}"].physical_networks.delete pnObj.id
    end

    def obsvr_update_physical_network(h_para, pnObj)
      oldObj = @physical_networks["#{h_para[:id]}"]
      SharedFunction.update_object(oldObj, pnObj)
    end
  end

  module TrafficType
  private
    def obsvr_add_traffic_type(params, response)
      _pnObj = @physical_networks["#{response.physicalnetworkid}"]
      response.p_node = _pnObj
      _pnObj.traffic_types["#{response.id}"] = response
    end
  end

  module NetworkServiceProvider
    def obsvr_configure_virtual_router_element(h_para, vreObj)
      oldObj = @physical_networks["#{h_para[:physicalnetworkid]}"].network_service_providers.choose("VirtualRouter")[0].virtual_router_elements.values.to_a[0]

      SharedFunction.update_object(oldObj, vreObj)
    end

    def obsvr_update_network_service_provider(params, obj)
    end

    def obsvr_enable_network_service_provider(h_para, respObj)
      oldObj = @physical_networks["#{respObj.physicalnetworkid}"].network_service_providers["#{respObj.id}"]
      SharedFunction.update_object oldObj, respObj
    end
  end

  module Network
  private
    def obsvr_create_network(h_para, networkObj)
      @networks["#{networkObj.id}"] = networkObj
      @zones["#{networkObj.zoneid}"].networks["#{networkObj.id}"] = networkObj
    end

    def obsvr_model_create_network(params, networkObj)
    end

    def obsvr_delete_network(h_para, networkObj)
      _network = @networks["#{h_para[:id]}"]
      @networks.delete "#{_network.id}"
      @zones["#{_network.zoneid}"].networks.delete "#{_network.id}"
    end
  end
end
