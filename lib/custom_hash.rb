class CustomHash

    def initialize
      @hash = Hash.new
    end
  
    def get(key)
      return nil if @hash[key].nil?
      return @hash[key] = nil if (Time.now - @hash[key][2] > @hash[key][1])
      return @hash[key][0]
    end
  
    def set(key, value, expiry, user)
      @hash[key] = [value, expiry, Time.now, user]
    end
  
end