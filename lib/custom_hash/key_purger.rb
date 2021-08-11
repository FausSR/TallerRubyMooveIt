require_relative 'custom_hash'

class KeyPurger

    def initialize(store)
        @store = store   
    end

    def purge_keys
        @store.keys.each do |key| 
            delete_key(key)
        end
    end

    private

    def delete_key(key)
        value = @store.get(key)
        if value.nil?
            @store.delete(key)
        end
    end
  
end