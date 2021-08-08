require_relative 'custom_hash'

class KeyPurger

    def initialize(store)
      @store = store
      purge_keys()    
    end

    private
  
    def purge_keys
      loop{
        sleep($ENV["KEYPURGER"])
        @store.keys.each{ |x| 
          value = @store.get(x)
          if value.nil?
            @store.delete(x)
          end
        }
      }
    end
  
  end