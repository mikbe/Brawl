module Brawl
  
  # The arena proxy allows limited acces to an arena for less privilaged
  # objects. For instance a battle controller needs full access to the arena but
  # a bot should not be allowed to directly place objects.
  class ArenaProxy
    
    private
    def self.read_only(*properties)
      properties.each do |property|
        define_method property do
          value = @arena.send property
        end
      end
    end
    
    public 

    def initialize(arena)
      @arena = arena
    end
    
    read_only :height, :width
    
    
    
  end

end