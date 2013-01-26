require 'json'
require 'digest/md5'


class SharedFunction

  def SharedFunction.make_request(cs_helper,
                                 params,
                                 responseObjName,
                                 requestObjName)
    logger = Logger.new 'cloudstack.api.log'
    logger.level = Logger::DEBUG
    if cs_helper.nil?
      raise "This user is not register api keys yet."
    end

    result = nil
    params[:response]="json"
    begin
      result = JSON.parse(cs_helper.get(params).body)["#{responseObjName}"]
      logger.warn result
      return result
    rescue => e
      (e && e.response) ? (return JSON.parse(e.response)) : (puts e)
    end
  end

  def SharedFunction.pack_params(targetObj, jsonObj)
    targetObj.class.attr_list.each do |attr|
      tmp_m = targetObj.method "#{attr}="
      tmp_m.call jsonObj[attr]
    end 
    targetObj
 end

 def SharedFunction.update_object(targetObj, newObj)
   targetObj.class.attr_list.each do |attr|
      tmp_m1 = targetObj.method "#{attr}="    
      tmp_m2 = newObj.method "#{attr}"
      tmp_m1.call tmp_m2.call
   end

 end

 def SharedFunction.query_Async_job(cs_helper,
                                    params)
   if cs_helper.nil?
     raise "This user is not register api keys yet."
   end

   params[:response]="json"
   params[:command]="queryAsyncJobResult"
   jobresult=0
   begin
     while jobresult == 0
       @job = JSON.parse(cs_helper.get(params).body)\
                          ["queryasyncjobresultresponse"]
       jobresult = @job["jobstatus"]
       sleep 1
     end 

     (puts "Async job failed for[#{@job['cmd']}]") unless jobresult == 1

     return @job
   rescue => e
     e.response ? (puts e.response) : (puts e)
   end
 end

 

end

class Module

  def sync_cmd_processor(*args)
    args.each do |arg|
      arga = arg.to_s.split('_')

      meta_method = %Q{
        def #{arga[0]+"_"+arga[1]}#{('_'+arga[2]) unless arga[2].nil?}(args={});
          command = "#{arga[0]}#{arga[1].capitalize}#{arga[2].capitalize unless arga[2].nil?}";
          params = {:command => command};
          params.merge! args unless args.empty?;
          result = SharedFunction.make_request(
                              @cs_helper,
                              params,
                              command.downcase+'response',
                              APICOMMAND);

          if result && (/(create|update|delete|register)/i.match command);
            changed;
            notify_observers('#{arg}', params, result);
          end;
          return result;
        end;
      }
      
      self.class_eval meta_method
    end
  end

  def async_cmd_processor(*args)
    args.each do |arg|
      arga = arg.to_s.split('_')

      meta_method = %Q{
        def #{arga[0]+"_"+arga[1]}#{('_'+arga[2]) unless arga[2].nil?}(args={});
          command = "#{arga[0]}#{arga[1].capitalize}#{(arga[2].capitalize) unless arga[2].nil?}";
          params = {:command => command};
          params.merge! args unless args.empty?;
          job = SharedFunction.make_request(
                              @cs_helper,
                              params,
                              command.downcase+'response',
                              'jobid');
          jobresponse = SharedFunction.query_Async_job(
                                       @cs_helper,
                                       {:jobid => job['jobid']});

          if (jobresponse['jobstatus'] == 1) &&
                (/(create|update|delete)/i.match command);
            changed;
            notify_observers('#{arg}', params, jobresponse);
          end;

          return jobresponse;
        end;
      }
      
      self.class_eval meta_method
    end
  end

end
