module Brawl
  
  class Arena
    
    attr_reader :width, :height, :bots
    
    def initialize(params={})
      @width  = params[:width]
      @height = params[:height]
      @bots   = []
    end

    def add_bot(bot)
      @bots << bot unless @bots.include? bot
    end
    
  end
  
end