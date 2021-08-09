require_relative 'custom_hash'

class KeyPurger

    def initialize(store)
        @store = store
        purge_keys()    
    end

    private

    def purge_keys
        loop do
            sleep($ENV["KEYPURGER"])
            @store.keys.each do |x| 
                value = @store.get(x)
                if value.nil?
                    @store.delete(x)
                end
            end
        end
    end
  
end