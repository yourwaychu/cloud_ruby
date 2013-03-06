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
      if v.name.eql? args[0]
        result << v
      end
    end
    return result
  end
end

