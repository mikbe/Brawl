module Brawl
  module Communications
    class NullModem
      def link_method(client, server, method)
        client.class.send :define_method, method do |*params, &block|
          server.send method, *params, &bloc
        end
      end
    end
  end
end