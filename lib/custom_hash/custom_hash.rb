require_relative 'custom_hash_value'
require 'Concurrent'

class CustomHash

    def initialize
      @hash = Concurrent::Map.new
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