module CloudStack
  module Model
    class AsyncJob < Raw

      cattr_accessor :attr_list

      attr_accessor :accountid,
                    :userid,
                    :cmd,
                    :jobstatus,
                    :jobprocstatus,
                    :jobresultcode,
                    :jobresulttype,
                    :jobresult,
                    :jobid

      @@attr_list = [:accountid,
                    :userid,
                    :cmd,
                    :jobstatus,
                    :jobprocstatus,
                    :jobresultcode,
                    :jobresulttype,
                    :jobresult,
                    :jobid]

    end
  end
end
