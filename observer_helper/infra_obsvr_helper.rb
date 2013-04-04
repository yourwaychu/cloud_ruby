module InfraObsvrHelper

  module Zone
  private
    def obsvr_create_zone(params, zone_obj)
      zone_obj.p_node = self
      @zones["#{zone_obj.id}"] = zone_obj
    end

    def obsvr_update_zone(params, zone_obj)
      old_obj = @zones["#{zone_obj.id}"]
      SharedFunction.update_object(old_obj, zone_obj)
    end

    def obsvr_delete_zone(params, resp)
      @zones.delete params[:id]
    end

    def obsvr_model_create_zone(params, zone_obj)
      @zones["#{zone_obj.id}"] = zone_obj
    end

    def obsvr_model_delete_zone(params, resp)
      @zones.delete params[:id]
    end
  end

  module Pod
  private
    def obsvr_create_pod(params, podObj)
      podObj.p_node = @zones["#{podObj.zoneid}"]
      @pods["#{podObj.id}"] = podObj
      @zones["#{podObj.zoneid}"].pods["#{podObj.id}"] = podObj
    end

    def obsvr_update_pod(params, podObj)
      oldObj = @pods["#{podObj.id}"]
      SharedFunction.update_object(oldObj, podObj)
    end

    def obsvr_delete_pod(params, respObj)
      _pod = @pods["#{params[:id]}"]
      @pods.delete _pod.id
      @zones["#{_pod.zoneid}"].pods.delete "#{_pod.id}"
    end

    def obsvr_model_create_pod(params, podObj)
      @pods["#{podObj.id}"] = podObj
    end

    def obsvr_model_delete_pod(params, respObj)
      _pod = @pods["#{params[:id]}"]
      @pods.delete _pod.id
    end
  end

  module Cluster
  private
    def obsvr_add_cluster(params, clusterList)
      _pod = @pods["#{clusterList[0].podid}"]
      clusterList.each do |clusterObj|
        clusterObj.p_node = _pod
        @clusters["#{clusterObj.id}"] = clusterObj
        @zones["#{clusterObj.zoneid}"].pods["#{clusterObj.podid}"].clusters["#{clusterObj.id}"] = clusterObj
      end
    end

    def obsvr_update_cluster(params, respObj)
      old_obj = @clusters["#{respObj.id}"]
      SharedFunction.update_object(old_obj, respObj)
    end

    def obsvr_delete_cluster(params, respObj)
      _cluster = @clusters["#{params[:id]}"]
      @clusters.delete "#{_cluster.id}" 
      @zones["#{_cluster.zoneid}"].pods["#{_cluster.podid}"].clusters.delete "#{_cluster.id}"
    end

    def obsvr_model_add_cluster(params, clusterList)
      clusterList.each do |clusterObj|
        @clusters["#{clusterObj.id}"] = clusterObj
      end
    end

    def obsvr_model_delete_cluster(params, respObj)
      _cluster = @clusters["#{params[:id]}"]
      @clusters.delete "#{_cluster.id}" 
      @zones["#{_cluster.zoneid}"].pods["#{_cluster.podid}"].clusters.delete "#{_cluster.id}"
    end
  end

  module Host
  private
    def obsvr_add_host(params, hostObjList)
      _cluster = @clusters["#{hostObjList[0].clusterid}"]
      hostObjList.each do |hostObj|
        hostObj.p_node = _cluster
        @hosts["#{hostObj.id}"] = hostObj
        @zones["#{hostObj.zoneid}"].pods["#{hostObj.podid}"].clusters["#{hostObj.clusterid}"].hosts["#{hostObj.id}"] = hostObj
      end
    end

    def obsvr_delete_host(params, respObj)
      _host = @hosts["#{params[:id]}"]
      _cluster = @clusters["#{_host.clusterid}"]
      if _cluster
        @hosts.delete "#{_host.id}"
        @zones["#{_host.zoneid}"].pods["#{_host.podid}"].clusters["#{_host.clusterid}"].hosts.delete "#{_host.id}"
      end
      
      # secondary is also a host obj in CS
      if @secondary_storages["#{_host.id}"]
        @secondary_storages.delete "#{_host.id}"
        @zones["#{_host.zoneid}"].secondary_storages.delete "#{_host.id}"
      end
    end

    def obsvr_model_add_host(params, hostLists)
      hostLists.each do |hostObj|
        @hosts["#{hostObj.id}"] = hostObj
      end
    end

    def obsvr_model_delete_host(params, respObj)
      _host = @hosts["#{params[:id]}"]
      @hosts.delete "#{_host.id}"
      @zones["#{_host.zoneid}"].pods["#{_host.podid}"].clusters["#{_host.clusterid}"].hosts.delete "#{_host.id}"

      if @secondary_storages["#{_host.id}"]
        @secondary_storages.delete "#{_host.id}"
        @zones["#{_host.zoneid}"].secondary_storages.delete "#{_host.id}"
      end
    end
  end

  module StoragePool
  private
    def obsvr_create_storage_pool(params, response)
      response.p_node = @zones["#{response.zoneid}"].pods["#{response.podid}"].clusters["#{response.clusterid}"]
      @storage_pools["#{response.id}"] = response
      @zones["#{response.zoneid}"].pods["#{response.podid}"].clusters["#{response.clusterid}"].storage_pools["#{response.id}"] = response
    end

    def obsvr_update_storage_pool(params, response)
      _old_obj = @storage_pools["#{response.id}"]
      SharedFunction.update_object _old_obj, response
    end

    def obsvr_delete_storage_pool(params, response)
      _sp_obj = @storage_pools["#{params[:id]}"]
      @storage_pools.delete "#{_sp_obj.id}"
      @zones["#{_sp_obj.zoneid}"].pods["#{_sp_obj.podid}"].clusters["#{_sp_obj.clusterid}"].storage_pools.delete "#{_sp_obj.id}"
    end

    def obsvr_model_create_storage_pool(params, response)
      @storage_pools["#{response.id}"] = response
    end

    def obsvr_model_delete_storage_pool(params, response)
      _sp_obj = @storage_pools["#{params[:id]}"]
      @storage_pools.delete "#{_sp_obj.id}"
    end
  end

  module SecondaryStorage
  private
    def obsvr_add_secondary_storage(params, stObj)
      stObj.p_node = @zones["#{stObj.zoneid}"]
      @secondary_storages["#{stObj.id}"] = stObj
      @hosts["#{stObj.id}"] = stObj
      @zones["#{stObj.zoneid}"].secondary_storages["#{stObj.id}"] = stObj
    end

    def obsvr_model_add_secondary_storage(params, stObj)
      @secondary_storages["#{stObj.id}"] = stObj
      @hosts["#{stObj.id}"] = stObj
    end

    def obsvr_model_delete_secondary_storage(params, respObj)
      _sc_obj = @secondary_storages["#{params[:id]}"]
      @secondary_storages.delete "#{_sc_obj.id}"
      @hosts.delete "#{_sc_obj.id}"
      @zones["#{_sc_obj.zoneid}"].secondary_storages.delete "#{_sc_obj.id}"
    end
  end
end
