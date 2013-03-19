#!/usr/bin/env ruby
require "yaml"
require_relative "cloudstack"


cs_config = YAML.load_file "#{ARGV[0]}"

def create_user(cs, params) 
  format_logger ["Parsing Infrastructure", "#{params[:username]}","Done"]
  cs.root_admin.create_user params
end

def create_account(cs, params)
  accounttype = params["accounttype"] 
  first_name  = params["first_name"]
  last_name   = params["last_name"]
  username    = params["username"]
  email       = params["email"]
  password    = params["password"]
  domain      = params["domain"] 
  users       = params["users"]
   
  cs.root_admin.create_account :accounttype => "#{accounttype}",
                               :email       => "#{email}",
                               :firstname   => "#{first_name}",
                               :lastname    => "#{last_name}",
                               :password    => "#{password}",
                               :username    => "#{username}",
                               :domainid    => "#{domain.id}"
                               
  format_logger ["Creating Accounts","#{username}","Done"]
  if users
    users.each do |user|
      params = {:account    => "#{username}",
                :email      => "#{user['email']}",
                :username   => "#{user['username']}",
                :firstname  => "#{user['first_name']}",
                :lastname   => "#{user['last_name']}",
                :password   => "#{user['password']}"}
      create_user cs, params
    end
  end

end

def create_domain(cs, params)
  name            = params["name"]
  network_domain  = params["network_domain"]
  subdomains      = params["domains"]
  accounts        = params["accounts"]

  format_logger ["Creating Domain","#{name}","Done"]
  if !cs.domains.exist? "#{name}"
    @domain = cs.root_admin.create_domain :name => "#{name}",
                                          :network_domain=> "#{network_domain}"
  else
    @domain = cs.domains.choose("#{name}").first
  end

  # create domain accounts
  if accounts
    accounts.each do |acc|
      params = {"accounttype" => acc["accounttype"],
                "first_name"  => acc["first_name"],
                "last_name"   => acc["last_name"],
                "password"    => acc["password"],
                "username"    => acc["username"],
                "email"       => acc["email"],
                "users"       => acc["users"],
                "domain"      => @domain}
      create_account cs, params
    end
  end

  # create sub domains
  if subdomains
    subdomains.each do |sub|
        create_domain cs, sub
    end
  end

  return cs
end

def create_zone(cs, params)
  networktype             = params["networktype"]
  dns1                    = params["public_dns1"]
  dns2                    = params["public_dns2"]
  internal_dns1           = params["internal_dns1"]
  internal_dns2           = params["internal_dns2"]
  hypervisor              = params["hypervisor"]
  name                    = params["name"]
  local_storage           = params["local_storage"]
  pod                     = params["pods"][0]
  secondary               = params["secondary_storage"][0]
  secondary_storage_ip    = secondary["ip"]
  secondary_storage_path  = secondary["path"]
  pod_name                = pod["name"]
  pod_gateway             = pod["gateway"]
  pod_netmask             = pod["netmask"]
  pod_startip             = pod["startip"]
  pod_endip               = pod["endip"]
  pod_vlan_startip        = pod["vlan_startip"]
  pod_vlan_endip          = pod["vlan_endip"]
  cluster                 = pod["clusters"][0]
  clustertype             = cluster["clustertype"]
  cluster_name            = cluster["name"]
  cluster_hypervisor      = cluster["hypervisor"]
  host                    = cluster["hosts"][0]
  host_url                = host["ip"]
  host_username           = host["username"]
  host_password           = host["password"]
  host_tags               = host["tags"]


  if !cs.zones.exist? "#{name}"
    @zone = cs.root_admin.create_zone :name         => "#{name}",
                                      :dns1         => "#{dns1}",
                                      :internaldns1 => "#{internal_dns1}",
                                      :networktype  => "Basic",
                                      :localstorageenabled => true
  else
    @zone = cs.zones.choose("#{name}").first
  end
  
  format_logger ["Creating Zone","#{name}", "Done"]

  # create physical network
  @physicalnetwork = cs.root_admin.create_physical_network :name    => "Physical Network 1",
                                                           :zoneid  => "#{@zone.id}"
                                                           
  format_logger ["Creating Physical Network","#{@physicalnetwork.name}", "Done"]
  
  cs.root_admin.add_traffic_type :traffictype       =>"Guest",
                                 :physicalnetworkid => "#{@physicalnetwork.id}"
                                 
  format_logger ["Creating Add TrafficType", "Guest", "Done"]

  cs.root_admin.add_traffic_type :traffictype       =>"Management",
                                 :physicalnetworkid => "#{@physicalnetwork.id}"

  format_logger ["Creating Add TrafficType","Management", "Done"]
  
  cs.root_admin.update_physical_network :id     => "#{@physicalnetwork.id}",
                                        :state  => "Enabled"

  format_logger ["Configuring virtual router","","Done"]
  
  @networkserviceproviders = cs.root_admin.list_network_service_providers :name               => "VirtualRouter",
                                                                          :physicalnetworkid  => "#{@physicalnetwork.id}"

  @virtualrouterelements = cs.root_admin.list_virtual_router_elements :nspid => "#{@networkserviceproviders.first.id}"

  cs.root_admin.configure_virtual_router_element :id      => "#{@virtualrouterelements.first.id}",
                                                 :enabled => "true"
  cs.root_admin.update_network_service_provider :id     => "#{@networkserviceproviders.first.id}",
                                                :state  => "Enabled"

  @networkserviceproviders_sg = cs.root_admin.list_network_service_providers :name => "SecurityGroupProvider",
                                                                             :physicalnetworkid => "#{@physicalnetwork.id}"

  
  cs.root_admin.update_network_service_provider :id     => "#{@networkserviceproviders_sg.first.id}",
                                                :state  => "Enabled"
                                                
  format_logger ["Setting up network offering","","Done"]
  
  @networkoffering = cs.network_offerings.choose("DefaultSharedNetworkOfferingWithSGService").first

  @network = cs.root_admin.create_network :displaytext  => "defaultGuestNetwork",
                                          :name         => "defaultGuestNetwork",
                                          :networkofferingid => "#{@networkoffering.id}",
                                          :zoneid       => "#{@zone.id}"

  @pod = cs.root_admin.create_pod :endip    => "#{pod_endip}",
                                  :startip  => "#{pod_startip}",
                                  :gateway  => "#{pod_gateway}",
                                  :name     => "#{pod_name}",
                                  :netmask  => "#{pod_netmask}",
                                  :zoneid   => "#{@zone.id}"

  cs.root_admin.create_vlan_ip_range :endip     => "#{pod_vlan_endip}",
                                     :startip   => "#{pod_vlan_startip}",
                                     :forvirtualnetwork => "false",
                                     :networkid => "#{@network.id}",
                                     :gateway   => "#{pod_gateway}",
                                     :netmask   => "#{pod_netmask}",
                                     :podid     => "#{@pod.id}"

  format_logger ["Creating pod", "#{pod_name}", "Done"]
  
  @clusters = cs.root_admin.add_cluster :zoneid       => "#{@zone.id}",
                                        :hypervisor   => "XenServer",
                                        :clustertype  => "#{clustertype}",
                                        :podid        => "#{@pod.id}",
                                        :clustername  => "#{cluster_name}"
                                        
  format_logger ["Creating cluster", "#{cluster_name}", "Done"]
  
  @host = cs.root_admin.add_host :zoneid      => "#{@zone.id}",
                                 :podid       => "#{@pod.id}",
                                 :clusterid   => "#{@clusters.first.id}",
                                 :hypervisor  => "XenServer",
                                 :clustertype => "#{clustertype}",
                                 :hosttags    => "#{host_tags}",
                                 :username    => "#{host_username}",
                                 :password    => "#{host_password}",
                                 :url         => "http://#{host_url}"
                                 
  format_logger ["Adding host", "#{host_url}", "Done"]

  cs.root_admin.add_secondary_storage :zoneid => "#{@zone.id}",
                                      :url    => "nfs://#{secondary_storage_ip}#{secondary_storage_path}"

  format_logger ["Adding secondary storage","","Done"]
  
  cs.root_admin.update_zone :id => "#{@zone.id}",
                            :allocationstate => "Enabled"
                            
  format_logger ["Enable zone", "#{@zone.name}", "Done"]
  return cs
end

def create_cloudstack(params)
  host    = params[:host]
  port    = params[:port]
  apiport = params[:apiport]

  cs = CloudStack::CloudStack.new "#{host}", "#{port}", "#{apiport}"
  return cs
end

def format_logger(params) 
  # action, action target, in what step
  if params[0] && params[1] && params[2]
    puts "%-40s: %-30s -- %-10s" % params
    puts "%-40s: %-30s" % params
  elsif params[0] && params[1]
    puts "%-40s: %-30s" % params
  elsif params[0]
    puts "%-40s" % params
  end
end


cs_config.each do |config|
  case config[0]
  when /cloudstack/i
    params={}
    params[:host]    = "#{config[1]["host"]}"
    params[:port]    = "#{config[1]["port"]}"
    params[:apiport] = "#{config[1]["apiport"]}"

    @cs = create_cloudstack params
  when /accounts/i
    format_logger ["Parsing Accounts..."]
    config[1]["domains"].each do |domain|
      create_domain @cs, domain 
    end
  when /infrastructure/i
    format_logger ["Parsing Infrastructure..."]
    config[1]["zones"].each do |zone|
      create_zone @cs, zone
    end
  else
    puts "Error!"
  end
end

