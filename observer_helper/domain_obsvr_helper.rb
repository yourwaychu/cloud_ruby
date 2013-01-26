module DomainObsvrHelper

private
  def create_domain(h_para, resp)
    jObj = resp['domain']
    domainObj = SharedFunction.pack_params CloudStack::Model::Domain.new, jObj
    @domains["#{domainObj.id}"]=domainObj
    if domainObj.parentdomainid
      @domains["#{domainObj.parentdomainid}"].domains["#{domainObj.id}"]\
                                                              =domainObj
    end
  end

  def update_domain(h_para, resp)
    jObj = resp['domain']
    domainObj = SharedFunction.pack_params CloudStack::Model::Domain.new, jObj
    SharedFunction.update_object @domains["#{domainObj.id}"], domainObj
  end

  def delete_domain(h_para, resp) # aynchronous
    if resp == 1
      @domains.delete h_para[:id]
    end
  end

end
