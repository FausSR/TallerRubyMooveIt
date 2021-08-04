require 'SecureRandom'

class CustomHash

    def initialize
      @hash = Hash.new
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
    @expiry = expiry.to_i 
    @created_time = Time.now 
    @flags = flags 
    @length = length.to_i 
    @cas = cas
  end

end