require 'SecureRandom'

class CustomHash

    def initialize
      @hash = Hash.new
    end

    def keys
      return @hash.keys
    end

    def delete(key)
      @hash.delete(key)
    end
  
    def get(key)
      return nil if @hash[key].nil?
      return @hash[key] = nil if (@hash[key].expiry != 0) && (Time.now - @hash[key].created_time > @hash[key].expiry)
      return @hash[key]
    end
  
    def set(key, value, expiry, flags, length, cas = 1)
      @hash[key] = CustomHashValue.new(value, expiry, flags, length, cas)
    end
  
end

class CustomHashValue
  attr_reader :value, :expiry, :created_time, :flags, :length, :cas

  def initialize(value, expiry, flags, length, cas)
    @value = value
    @expiry = expiry.to_int 
    @created_time = Time.now 
    @flags = flags.to_int
    @length = length.to_int
    @cas = cas.to_int
  end

end

class KeyPurger

  def initialize
    purge_keys()    
  end

  def purge_keys
    loop{
      sleep($ENV["KEYPURGER"])
      $store.keys.each{ |x| 
        value = $store.get(x)
        if value.nil?
          $store.delete(x)
        end
      }
    }
  end

end