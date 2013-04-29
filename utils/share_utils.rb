class SharedFunction
  def SharedFunction.update_object(targetObj, newObj)
    targetObj.class.attr_list.each do |attr|
       tmp_m1 = targetObj.method "#{attr}="    
       tmp_m2 = newObj.method "#{attr}"
       tmp_m1.call tmp_m2.call
    end
  end
end


class Hash
  def exist?(*args)
    self.values.each do |v|
      if v.name.eql? args[0]
          return true
      end
    end
    return false
  end

  def choose(*args)
    result = []
    self.values.each do |v|

      if (v.class.method_defined?("name")) && v.name && (/#{args[0]}/i.match(v.name))
        result << v
      elsif (v.class.method_defined?("username")) && v.username && (/#{args[0]}/i.match(v.username))
        result << v
      end
    end
    return result
  end
end




class Module
  def sync_cmd_processor(*args)
    args.each do |arg|
      arga = arg.to_s.split('_')

      meta_method = %Q{
        def #{arga[0]+"_"+arga[1]}#{('_'+arga[2]) unless arga[2].nil?}#{('_'+arga[3]) unless arga[3].nil?}#{('_'+arga[4]) unless arga[4].nil?}(args={}, isRoot=false);
          success_cmds = ["deleteVlanIpRange",
                          "deleteHost",
                          "deleteZone",
                          "deleteUser",
                          "deleteCluster",
                          "deletePod",
                          "deleteDiskOffering",
                          "deleteServiceOffering",
                          "deleteNetwork",
                          "deleteStoragePool"];

          command = "#{arga[0]}#{arga[1].capitalize}#{arga[2].capitalize unless arga[2].nil?}#{arga[3].capitalize unless arga[3].nil?}#{arga[4].capitalize unless arga[4].nil?}";

          params = {:command => command};
          params.merge! args unless args.empty?;

          _responseObj = '#{arga[1].capitalize unless arga[1].nil?}#{arga[2].capitalize unless arga[2].nil?}#{arga[3].capitalize unless arga[3].nil?}#{arga[4].capitalize unless arga[4].nil?}'

          if /vlan/i =~ command
            _responseObj = 'Vlan'
          end

          if /secondary/i =~ command
            _responseObj = 'Host'
          end

          if /list/i.match command;
            _responseObj.chomp! 's';
          end;

          api_caller = self unless !(self.kind_of?(CloudStack::Model::User)) || isRoot ==true

          response = CloudStackAgent.instance.get params, api_caller;

          if response[command.downcase+'response'] && 
             response[command.downcase+'response']['errorcode'] != nil

            raise response[command.downcase+'response']['errortext']
          end

          result = nil;

          if (/list/i.match command) ||
             (/(addcluster|addhost)/i.match command);
            result = [];
            if response[command.downcase+'response'][_responseObj.downcase] != nil;
              response[command.downcase+'response'][_responseObj.downcase].each do |item|;
                result << CloudStack::Model.const_get(_responseObj).new(item, @obsvr);
              end;
            end;
          elsif success_cmds.include? command 
            result = CloudStack::Model.const_get("Success").new(response[command.downcase+'response'])
          else
            result = CloudStack::Model.const_get(_responseObj).new(response[command.downcase+'response'][_responseObj.downcase], @obsvr)
          end

                    
          if result && 
             (/(add|create|update|delete|register|enable|disable).*/i.match command);
            
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
        def #{arga[0]+"_"+arga[1]}#{('_'+arga[2]) unless arga[2].nil?}#{('_'+arga[3]) unless arga[3].nil?}#{('_'+arga[4]) unless arga[4].nil?}(args={}, isRoot=false);

          success_cmds = ["deleteNetwork",
                          "deleteTrafficType",
                          "deletePhysicalNetwork",
                          "deleteAccount",
                          "deleteDomain"];

          command = "#{arga[0]}#{arga[1].capitalize}#{arga[2].capitalize unless arga[2].nil?}#{arga[3].capitalize unless arga[3].nil?}#{arga[4].capitalize unless arga[4].nil?}";

          params = {:command => command};

          params.merge! args unless args.empty?;

          _responseObj = '#{arga[1].capitalize unless arga[1].nil?}#{arga[2].capitalize unless arga[2].nil?}#{arga[3].capitalize unless arga[3].nil?}#{arga[4].capitalize unless arga[4].nil?}';

          api_caller = self unless !(self.kind_of?(CloudStack::Model::User)) || isRoot == true

          response = CloudStackAgent.instance.get params, api_caller;

          if response[command.downcase+'response'] && 
             response[command.downcase+'response']['errorcode'] != nil;

            raise response[command.downcase+'response']['errortext'];
          end;

          result = nil;

          jobstatus = 0;
          asyncjobresponse = nil;

          while jobstatus == 0;
            asyncjobresponse = CloudStackAgent.instance.get({:command => 'queryAsyncJobResult',
                                                             :jobid   =>  response[command.downcase+'response']['jobid']}, 
                                                            api_caller);

            jobstatus = asyncjobresponse["queryasyncjobresultresponse"]["jobstatus"].to_i;
            sleep 0.5;
          end;

          if jobstatus == 2;
            raise asyncjobresponse['queryasyncjobresultresponse']['jobresult']['errortext'];
          end;

          if success_cmds.include? command;
            result = CloudStack::Model.const_get("Success").new(asyncjobresponse['queryasyncjobresultresponse']['jobresult']);
          else;
            result = CloudStack::Model.const_get(_responseObj).new(asyncjobresponse['queryasyncjobresultresponse']['jobresult'][_responseObj.downcase], @obsvr);
          end;

          if result && 
             (/(add|create|update|delete|register|disable|enable|configure).*/i.match command);
            changed;
            notify_observers('#{arg}', params, result);
          end;

          return result;
        end;
      }
      
      self.class_eval meta_method
    end
  end
end
