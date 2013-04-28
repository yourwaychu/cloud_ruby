module AccountsModelHelper
  module Domain
    def create_domain(args={})
      args[:parentdomainid] = self.id
      super(args)
    end

    def update(args={})
      args[:id] = self.id
      update_domain(args)
    end

    def delete(args={})
      args[:id] = self.id
      args[:cleanup] = true
      delete_domain(args)
    end

    def create_account(args={})
      args[:domainid] = self.id
      super(args)
    end
  end

  module Account
    def pack(j_obj)
      super(j_obj)
      user_j_objs = j_obj['user']

      user_j_objs.each do |juser|
        _user_obj = CloudStack::Model::User.new juser, @obsvr
        _user_obj.p_node = self
        self.users["#{_user_obj.id}"] = _user_obj
      end
    end

    def update(args={})
      args[:id] = self.id
      update_account(args)
    end

    def delete(args={})
      args[:id] = self.id
      delete_account(args)
    end

    def create_user(args={})
      args[:domainid] = self.domainid
      args[:account] = self.name
      super(args)
    end
  end

  module User
    def update(args={})
      args[:id] = self.id
      update_user(args, true)
    end

    def disable(args={})
      args[:id] = self.id
      disable_user(args, true)
    end

    def enable(args={})
      args[:id] = self.id
      enable_user(args, true)
    end
  
    def delete(args={})
      args[:id] = self.id
      delete_user(args, true)
    end
  end
end
