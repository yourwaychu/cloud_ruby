require 'json'
require 'digest/md5'


class SharedFunction

  def SharedFunction.make_request(cs_helper,
                                  model_observer,
                                  params,
                                  response_name,
                                  rObj_name)
    @command = params[:command]

    logger = Logger.new 'cloudstack.api.log'
    logger.level = Logger::DEBUG
  

    if cs_helper.nil?
      raise "This user is not register api keys yet."
    end

    jObj_name = rObj_name.downcase

    if /vlan/i =~ response_name
      jObj_name = 'vlan'
      rObj_name = 'Vlan'
    end

    params[:response]="json"

    begin
      response = JSON.parse(cs_helper.get(params).body)["#{response_name}"]

      if /(list|addcluster|addhost)/i.match @command
        @result = [] 
        if response["#{jObj_name}"]
          response["#{jObj_name}"].each do |obj|
            @result << CloudStack::Model.const_get(rObj_name).new(obj, cs_helper, model_observer)
          end
        end
      # FIXME : For success responese (Ugly code here, need refactor)
      elsif /(deleteHost|deleteZone|deleteUser|deleteCluster|deletePod|deleteDiskOffering|deleteServiceOffering|deleteNetwork)/i.match @command    # for success response object
          @result = CloudStack::Model.const_get("Success").new(response)
      else
        @result = CloudStack::Model.const_get(rObj_name).new(response["#{jObj_name}"], cs_helper, model_observer)
      end
      return @result
    rescue => e
      (e && e.response) ? (return CloudStack::Model::Error.new(JSON.parse(e.response)["#{response_name}"])) : (puts e)
    end
  end

  def SharedFunction.make_async_request(cs_helper,
                                        params,
                                        responseObjName)
    @command = params[:command]

    logger = Logger.new 'cloudstack.api.log'
    logger.level = Logger::DEBUG
    if cs_helper.nil?
      raise "This user is not register api keys yet."
    end

    params[:response]="json"

    begin
      response = JSON.parse(cs_helper.get(params).body)["#{responseObjName}"]

      logger.warn response
      return response
    rescue => e
      (e && e.response) ? (return CloudStack::Model::Error.new(JSON.parse(e.response)["#{responseObjName}"])) : (puts e)
    end
  end
 
  def SharedFunction.update_object(targetObj, newObj)
    targetObj.class.attr_list.each do |attr|
       tmp_m1 = targetObj.method "#{attr}="    
       tmp_m2 = newObj.method "#{attr}"
       tmp_m1.call tmp_m2.call
    end
  end

  def SharedFunction.query_async_job(cs_helper,
                                     model_observer,
                                     params,
                                     requestCommand,
                                     requestObjName)
    if cs_helper.nil?
      raise "This user is not register api keys yet."
    end

    params[:response]="json"
    params[:command]="queryAsyncJobResult"
    jobstatus = 0

    begin
      while jobstatus == 0
        asyncjobresponse = JSON.parse(cs_helper.get(params).body)["queryasyncjobresultresponse"]
        jobstatus = asyncjobresponse["jobstatus"].to_i
        sleep 1
      end 

      @asyncjob = CloudStack::Model::AsyncJob.new(asyncjobresponse)

      # For asynchronous command with success response 
      if /(deleteNetwork|deleteTrafficType|deletePhysicalNetwork|deleteAccount|deleteDomain)/i.match requestCommand
        @result = CloudStack::Model.const_get("Success").new(@asyncjob.jobresult)
      else
        @result = CloudStack::Model.const_get(requestObjName).new(@asyncjob.jobresult["#{requestObjName.downcase}"], cs_helper, model_observer)
      end

      return @result
    rescue => e
       (e && e.response) ? (return CloudStack::Model::Error.new(JSON.parse(e.response)["#{responseObjName}"])) : (puts e)
    end
  end
end

class Module

  def sync_cmd_processor(*args)
    args.each do |arg|
      arga = arg.to_s.split('_')

      meta_method = %Q{
        def #{arga[0]+"_"+arga[1]}#{('_'+arga[2]) unless arga[2].nil?}#{('_'+arga[3]) unless arga[3].nil?}(args={});
          command = "#{arga[0]}#{arga[1].capitalize}#{arga[2].capitalize unless arga[2].nil?}#{arga[3].capitalize unless arga[3].nil?}";
          params = {:command => command};
          params.merge! args unless args.empty?;
          _responseObj = '#{arga[1].capitalize unless arga[1].nil?}#{arga[2].capitalize unless arga[2].nil?}#{arga[3].capitalize unless arga[3].nil?}'
          if /list/i.match command
            _responseObj.chomp! 's'
          end
          response = SharedFunction.make_request(
                                    @cs_helper,
                                    @model_observer,
                                    params,
                                    command.downcase+'response',
                                    _responseObj);
          
          if response && 
             !response.instance_of?(CloudStack::Model::Error) &&
             (/(create|update|delete|register)/i.match command);

            changed;
            notify_observers('#{arg}', params, response);
          end;
          return response;
        end;
      }
      
      self.class_eval meta_method
    end
  end

  def async_cmd_processor(*args)
    args.each do |arg|
      arga = arg.to_s.split('_')

      meta_method = %Q{
        def #{arga[0]+"_"+arga[1]}#{('_'+arga[2]) unless arga[2].nil?}#{('_'+arga[3]) unless arga[3].nil?}(args={});
          command = "#{arga[0]}#{arga[1].capitalize}#{(arga[2].capitalize) unless arga[2].nil?}#{(arga[3].capitalize) unless arga[3].nil?}";
          params = {:command => command};
          params.merge! args unless args.empty?;
          jJob = SharedFunction.make_async_request(@cs_helper,
                                                   params,
                                                   command.downcase+'response');
          

          responseObj = SharedFunction.query_async_job(
                                       @cs_helper,
                                       @model_observer,
                                       {:jobid => jJob['jobid']},
                                       command,
                                       '#{arga[1].capitalize unless arga[1].nil?}#{arga[2].capitalize unless arga[2].nil?}#{arga[3].capitalize unless arga[3].nil?}');

          if (/(create|update|delete|disable|enable|add)/i.match command);
            changed;
            notify_observers('#{arg}', params, responseObj);
          end;

          return responseObj;
        end;
      }
      
      self.class_eval meta_method
    end
  end

end
