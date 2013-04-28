require 'json'
require 'rubygems'
require 'base64'
require 'rest_client'
require 'openssl'
require 'cgi'
require 'singleton'


class CloudStackAgent

  include Singleton

  @@SYNC_SUCCESSCMDS = ["deleteVlanIpRange",
                        "deleteHost",
                        "deleteZone",
                        "deleteUser",
                        "deleteCluster",
                        "deletePod",
                        "deleteDiskOffering",
                        "deleteServiceOffering",
                        "deleteNetwork",
                        "deleteStoragePool"]
                            
  @@ASYNC_SUCCESSCMDS = ["deleteNetwork",
                         "deleteTrafficType",
                         "deletePhysicalNetwork",
                         "deleteAccount",
                         "deleteDomain"]

  CONFIGURABLE_ATTRIBUTES = [
    :response,
    :api_url,
    :api_caller
  ]

  attr_accessor *CONFIGURABLE_ATTRIBUTES

  def generate_signature(params, secret_key)
    params.each { |k,v| params[k] = CGI.escape(v.to_s).gsub('+', '%20').downcase }
    sorted_params = params.sort_by{|key,value| key.to_s}

    data = parameterize(sorted_params, false)

    hash = OpenSSL::HMAC.digest('sha1', secret_key, data)
    signature = Base64.encode64(hash).chomp
  end

  def parameterize(params, escape=true)
    params = params.collect do |k,v| 
      if escape
        "#{CGI.escape(k.to_s)}=#{CGI.escape(v.to_s)}"
      else
        "#{k}=#{v}"
      end
    end
    params.join('&')
  end

  def generate_params(apikey, secretkey, params)
    unless params[:response]
      params[:response] = @response if @response
    end
    params[:apikey] = apikey
    params[:signature] = generate_signature params.clone, secretkey
    str = parameterize(params)
  end

  def request(api_caller, params, api_url, method = :get)
    if !api_caller.apikey || !api_caller.secretkey
      raise "The user doesnt have registered keys"
    end
    case method
    when :get
      url = api_url + "?" + generate_params(api_caller.apikey.clone,
                                            api_caller.secretkey.clone,
                                            params.clone)

      begin
        response = RestClient.send(method, url)
        return @response == "json" ? JSON.parse(response) : response
      rescue => e
        return JSON.parse e.response
      end
    else
      raise "HTTP method #{method} not supported"
    end
  end
 
  def get(params, api_caller = nil, api_url = nil)
    api_url    ||= @api_url
    api_caller ||= @api_caller
    request(api_caller, params, api_url, :get)
  end
end

