class CustomHashValue
    attr_reader :value, :expiry, :created_time, :flags, :length, :cas

    def initialize(value, expiry, flags, length, cas)
        @value = value
        @expiry = expiry.to_i 
        @created_time = Time.now 
        @flags = flags.to_i
        @length = length.to_i 
        @cas = cas.to_i
    end
  
end