module CloudStackMainHelper

  def deploy_accounts(accounts_config)
    # lamda
    create_user = lambda do |args, accname, did|
      print "%-85s" % "Creating user : #{args["username"]}" 
      _user_obj = create_user({:username  => "#{args['username']}",
                               :email     => "#{args['email']}",
                               :firstname => "#{args['first_name']}",
                               :lastname  => "#{args['last_name']}",
                               :password  => "novirus",
                               :domainid  => "#{did}",
                               :account   => "#{accname}"})
      puts (_user_obj ? "done" : "failed")

    end
    create_account = lambda do |args, did|
      print "%-85s" % "Creating account : #{args["account"]}"
      _acc_obj = create_account({:accounttype => "#{args['accounttype']}",
                                 :email       => "#{args['email']}",
                                 :firstname   => "#{args['first_name']}",
                                 :lastname    => "#{args['last_name']}",
                                 :username    => "#{args['username']}",
                                 :account     => "#{args['account']}",
                                 :password    => "#{args['password']}",
                                 :domainid    => "#{did}"})

      puts (_acc_obj ? "done" : "failed")

      if args["users"]
        args["users"].each do |user|
          create_user.call user, _acc_obj.name, did
        end
      end
    end

    create_domain  = lambda do |args, pid|
      print "%-85s" % "Creating domain : #{args['name']}"
      _dom_obj = create_domain({:name => "#{args["name"]}",
                                :parentdomainid => "#{pid}"})

      puts (_dom_obj ? "done" : "failed")

      if args["accounts"]
        args["accounts"].each do |acc|
          create_account.call acc, _dom_obj.id
        end
      end

      if args["domains"]
        args["domains"].each do |dom|
          create_domain.call dom, _dom_obj.id
        end
      end
    end

    _root_domain = accounts_config["domains"][0]

    if _root_domain["domains"]
      _root_domain["domains"].each do |dom|
        create_domain.call dom, @domains.values[0].id
      end
    end

    if _root_domain["accounts"]
      _root_domain["accounts"].each do |acc|
        create_account.call acc, @domains.values[0].id
      end
    end
  end

  def undeploy_accounts(accounts_config)
    _root_domain = accounts_config["domains"][0]

    delete_account = lambda do |args, did|
      result = nil
      @accounts.each do |k, acc|
        if acc.name.eql? "#{args['account']}"
          print "%-85s" % "Deleting account : #{args['account']}"
          result = delete_account({:id => "#{acc.id}"})
        end
      end
      puts (result ? "done" : "failed")
    end

    delete_domain  = lambda do |args, pid|
      result = nil
      @domains.each do |k, dom|
        if dom.name.eql? "#{args['name']}"
          print "%-85s" % "Deleting domain : #{args['name']}"
          result = delete_domain({:id => "#{dom.id}", :cleanup => true})
        end
      end
      puts (result ? "done" : "failed")
    end

    if _root_domain["domains"]
      _root_domain["domains"].each do |dom|
        delete_domain.call dom, @domains.values[0].id
      end
    end

    if _root_domain["accounts"]
      _root_domain["accounts"].each do |acc|
        delete_account.call acc, @domains.values[0].id
      end
    end
  end

  def deploy_infra(infra_config)
    zones = infra_config["zones"]
    
    zones.each do |zone|
      if zone   # create zone
        print "%-85s" % "Creating zone : #{zone['name']}"
        zone_obj = create_zone({:name                => "#{zone['name']}",
                                :networktype         => "#{zone['networktype']}",
                                :dns1                => "#{zone['public_dns1']}",
                                :internaldns1        => "#{zone['internal_dns1']}"})

        puts (zone_obj ? "done" : "failed")


        physical_network = zone["physicalnetwork"]

        if physical_network     #create physical network
          print "%-85s" % "Creating physical network : #{physical_network['name']}"
          pn_obj = zone_obj.create_physical_network :name => "#{physical_network['name']}"
          puts (pn_obj ? "done" : "failed")

          traffic_types = []

          physical_network['traffictype'].split(',').each do |tt|   # add traffic type

            print "%-85s" % "Adding #{tt} traffic types to physical network"

            traffic_obj = pn_obj.add_traffic_type :traffictype => "#{tt}"
            puts (traffic_obj ? "done" : "failed")
            traffic_types << traffic_obj
          end
          
          print "%-85s" % "Configuring physical network : #{physical_network['name']}"  # configure physical network

          vr_obj = pn_obj.network_service_providers.choose("VirtualRouter")[0].virtual_router_elements.values[0].enable
          vrsp_obj = pn_obj.network_service_providers.choose("VirtualRouter")[0].enable
          sgsp_obj = pn_obj.network_service_providers.choose("SecurityGroupProvider")[0].enable
          puts ( vr_obj && vrsp_obj && sgsp_obj ? "done" : "failed")

          print "%-85s" % "Enabling physical network : #{physical_network['name']}"     # enable physical network

          result = pn_obj.enable
          puts (pn_obj.state == "Enabled" ? "done" : "failed")

        end
        
        network = zone['networks'][0]
        if network
          network_offering_obj = @network_offerings.choose("#{network['networkoffering']}").first   # create network
    
          print "%-85s" % "Creating network : #{network['name']}"
          net_obj = zone_obj.create_network :name              => "#{network['name']}",
                                            :displaytext       => "#{network['name']}" ,
                                            :networkofferingid => "#{network_offering_obj.id}"
          
          puts (net_obj ? "done" : "failed")
        end

        pods = zone["pods"]

        if pods
          pods.each do |pod|
            print "%-85s" % "Creating pod : #{pod['name']}"   # create pod
            pod_obj = zone_obj.create_pod :name    => "#{pod['name']}",
                                          :netmask => "#{pod['netmask']}",
                                          :gateway => "#{pod['gateway']}",
                                          :startip => "#{pod['startip']}",
                                          :endip   => "#{pod['endip']}"

            puts (pod_obj ? "done" : "failed")

            vlans = pod["vlans"]

            if vlans
              vlans.each do |vlan|
                print "%-85s" % "Creating vlan for pod : #{pod['name']}"
                vlan_obj = pod_obj.create_vlan_ip_range :gateway           => "#{pod['gateway']}",
                                                        :netmask           => "#{pod['netmask']}",
                                                        :networkid         => "#{net_obj.id}",
                                                        :forvirtualnetwork => "#{vlan['forvirtual']}",
                                                        :startip           => "#{vlan['startip']}",
                                                        :endip             => "#{vlan['endip']}"

                puts (vlan_obj ? "done" : "failed")
              end
            end


            clusters = pod["clusters"]
            
            if clusters
              clusters.each do |cluster|
                print "%-85s" % "Creating cluster  for pod : #{pod['name']}"  # create cluster
                cluster_obj_list = pod_obj.add_cluster :clustername => "#{cluster['name']}",
                                                       :clustertype => "#{cluster['clustertype']}",
                                                       :hypervisor  => "#{cluster['hypervisor']}"

                puts (cluster_obj_list ? "done" : "failed")

                storage_pools = cluster['storagepools']

                if storage_pools
                  storage_pools.each do |storage_pool|
                    print "%-85s" % "Adding host to cluster : #{cluster['name']}"  # create cluster
                    sp_obj = cluster_obj_list[0].create_storage_pool \
                                                        :name  => "#{storage_pool['name']}",
                                                        :url   => "#{storage_pool['url']}",
                                                        :scope => "#{storage_pool['scope']}",
                                                        :tags  => "#{storage_pool['tags']}"
                    puts (sp_obj ? "done" : "failed")
                  end
                end

                hosts = cluster['hosts']

                if hosts
                  hosts.each do |host|
                    print "%-85s" % "Adding host to cluster : #{cluster['name']}"  # create cluster
                    host_obj_list = cluster_obj_list[0].add_host \
                                                       :hypervisor  => "#{cluster['hypervisor']}",  # add host to cluster
                                                       :clustertype => "#{cluster['clustertype']}",
                                                       :hosttags    => "#{host['tags']}",
                                                       :username    => "#{host['username']}",
                                                       :password    => "#{host['password']}",
                                                       :url         => "#{host['ip']}"

                  end
                end
              end
            end
          end
        end

        secondary_storages = zone['secondarystorages']

        if secondary_storages
          secondary_storages.each do |secondary_storage|
            print "%-85s" % "Adding secondary to host : #{zone['name']}"  # add secondary storage
            sc_obj = zone_obj.add_secondary_storage \
                                :url => "nfs://#{secondary_storage['ip']}#{secondary_storage['path']}" 
          end
        end
      end

      # _ps_yml = _cluster_yml['storagepools'][0]
      # 
      # ps_obj = cluster_obj.create_storage_pool :name  => "#{_ps_yml['name']}",
      #                                          :scope => "#{_ps_yml['scope']}",
      #                                          :url   => "#{_ps_yml['url']}",
      #                                          :tags  => "#{_ps_yml['tags']}"
    end
  end

  def undeploy_infra(infra_config)
    zones = infra_config["zones"]

    zone = zones[0]

    print "%-85s" % "Deleting cluster of pod : #{zone['pods'][0]['name']}"
    cluster_obj = @clusters.choose("#{zone['pods'][0]['clusters'][0]['name']}")[0]
    result = cluster_obj.delete
    puts (result ? "done" : "failed")

    print "%-85s" % "Deleting pod of zone : #{zone['pods'][0]['name']}"
    pod_obj = @pods.choose("#{zone['pods'][0]['name']}")[0]
    result = pod_obj.delete
    puts (result ? "done" : "failed")

    print "%-85s" % "Deleting network of zone : #{zone['networks'][0]['name']}"
    net_obj = @networks.choose(zone['networks'][0]['name'])[0]
    result = net_obj.delete
    puts (result ? "done" : "failed")

    print "%-85s" % "Deleting vlans"     
    vlan_obj = @vlans.each do |vlan|
      result = vlan.delete
    end
    puts (@vlans.values.length == 0 ? "done" : "failed")    

    print "%-85s" % "Deleting physical network of zone : #{zone['name']}"
    pnnet_obj = @physical_networks.choose(zone['physicalnetwork']['name'])[0]
    result = pnnet_obj.delete
    puts (result ? "done" : "failed")
     
    print "%-85s" % "Deleting zone : #{zone['name']}"
    zone_obj = @zones.choose(zone['name'])[0]
    result = zone_obj.delete
    puts (result ? "done" : "failed")
  end

 	private
  def register_root_admin
    listuserresponse = RestClient.send(:get,
                                       "#{@admin_request_url}?" +
                                       "command=listUsers&" +
                                       "username=admin&response=json")

    _admin = JSON.parse(listuserresponse)['listusersresponse']['user'][0]

    @root_admin = CloudStack::Model::Admin.new(_admin, @obsvr)


    if !@root_admin.apikey
      _registeruserkeyresponse = RestClient.send(:get,
                                                 "#{@admin_request_url}?" +
                                                 "command=registerUserKeys&"+
                                                 "id=#{@root_admin.id}&"+
                                                 "response=json")

      _keys = JSON.parse(_registeruserkeyresponse)\
                                        ['registeruserkeysresponse']['userkeys']

      adminkeyObj = CloudStack::Model::UserKeys.new _keys

      @root_admin.apikey      = adminkeyObj.apikey.clone
      @root_admin.secretkey   = adminkeyObj.secretkey.clone
    end
  end

  def update_env
    update_env_accounts
    update_env_infra
    # update_env_system_vms
    update_env_service_offerings
  end

  def update_env_accounts
    domains = list_domains({:listall => true})
    domains.each do |dom|
      accounts = list_accounts :domainid => dom.id
      accounts.each do |acc|
        users = list_users :accountid => acc.id
        users.each do |user|
          user.p_node = acc
          acc.users["#{user.id}"] = user
          @users["#{user.id}"] = user
        end
        acc.p_node = dom
        dom.accounts["#{acc.id}"] = acc
        @accounts["#{acc.id}"] = acc
      end
      @domains["#{dom.parentdomainid}"].domains["#{dom.id}"] = dom \
                                                unless dom.parentdomainid == nil
      @domains["#{dom.id}"] = dom
    end
  end

  def update_env_infra
    zones = list_zones({:listall => true})
    zones.each do |zo|  #zones
      physical_networks = list_physical_networks({:zoneid => "#{zo.id}"})
      physical_networks.each do |pn|    #physical networks
        traffic_types = list_traffic_types({:physicalnetworkid => "#{pn.id}"})  #traffic types
        traffic_types.each do |tt|
          pn.traffic_types << tt.traffictype
        end

        virtual_router_providers = list_network_service_providers({:name              => "VirtualRouter",   #virtual router providers
                                                                   :physicalnetworkid => "#{pn.id}"})

        security_group_providers = list_network_service_providers({:name              => "SecurityGroup",   #security group providers
                                                                   :physicalnetworkid => "#{pn.id}"}) 
        virtual_router_providers.each do |vr|
          virtual_router_elements = list_virtual_router_elements({:nspid => "#{vr.id}"})    #virtual router elements

          virtual_router_elements.each do |vre|
            vr.virtual_router_elements["#{vre.id}"] = vre
          end

          pn.network_service_providers["#{vr.id}"] = vr
        end

        security_group_providers.each do |sg_sp|
          pn.network_service_providers["#{sg_sp.id}"] = sg_sp
        end

        @physical_networks["#{pn.id}"] = pn
        zo.physical_networks["#{pn.id}"] = pn
      end

      networks = list_networks({:zoneid => "#{zo.id}"}) #networks
      networks.each do |net|
        @networks["#{net.id}"] = net
        zo.networks["#{net.id}"] = net
      end

      pods = list_pods({:zoneid => "#{zo.id}"}) #pods
      pods.each do |pod|
        clusters = list_clusters({:podid => "#{pod.id}"})   #clusters

        clusters.each do |cluster|
          hosts = list_hosts({:clusterid => "#{cluster.id}"})   #hosts
          hosts.each do |host|
            @hosts["#{host.id}"] = host
            cluster.hosts["#{host.id}"] = host
          end

          @clusters["#{cluster.id}"] = cluster
          pod.clusters["#{cluster.id}"] = cluster
        end

        @pods["#{pod.id}"] = pod
        zo.pods["#{pod.id}"] = pod
      end


      system_vms = list_system_vms({:zoneid => "#{zo.id}"})
      system_vms.each do |ssvm|
        @system_vms["#{ssvm.id}"] = ssvm
        zo.system_vms["#{ssvm.id}"] = ssvm
      end

      @zones["#{zo.id}"] = zo
    end
  end

  def update_env_service_offerings
    resultObjs0 = list_service_offerings({:issystem => false, :listall => true})
    resultObjs0.each do |obj|
      obj.p_node = self
      @compute_offerings["#{obj.id}"] = obj
    end

    resultObjs1 = list_service_offerings({:issystem => true, :listall => true})
    resultObjs1.each do |obj|
      obj.p_node = self
      @system_offerings["#{obj.id}"] = obj
    end

    resultObjs2 = list_disk_offerings({:listall => true})
    resultObjs2.each do |obj|
      obj.p_node = self
      @disk_offerings["#{obj.id}"] = obj
    end

    resultObjs3 = list_network_offerings({:listall => true})
    resultObjs3.each do |obj|
      obj.p_node = self
      @network_offerings["#{obj.id}"] = obj
    end
  end
end
