require_relative 'custom_hash_value'
require 'Concurrent'

class CustomHash

    def initialize
        @hash = Concurrent::Map.new
        @semaphore = Mutex.new
    end

    def keys
        @semaphore.synchronize do
            return @hash.keys
        end
    end

    def delete(key)
        @semaphore.synchronize do
            return @hash.delete(key)
        end
    end
  
    def get(key)
        @semaphore.synchronize do
            return nil if @hash[key].nil?
            return @hash[key] = nil if ((@hash[key].expiry != 0) && (Time.now - @hash[key].created_time > @hash[key].expiry))
            return @hash[key]
        end
    end
  
    def set(key, value, expiry, flags, length, cas = 1)
        @semaphore.synchronize do
            return @hash[key] = CustomHashValue.new(value, expiry, flags, length, cas)
        end
    end

end