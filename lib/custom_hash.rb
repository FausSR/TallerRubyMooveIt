require 'SecureRandom'

class CustomHash

    def initialize
      @hash = Hash.new
    end
  
    def get(key)
      return nil if @hash[key].nil?
      return @hash[key] = nil if (Time.now - @hash[key][2] > @hash[key][1])
      return @hash[key]
    end
  
    def set(key, value, expiry, user, flags, length, cas=nil)
      @hash[key] = [value, expiry.to_i, Time.now, user, flags, length.to_i, cas]
    end
  
end