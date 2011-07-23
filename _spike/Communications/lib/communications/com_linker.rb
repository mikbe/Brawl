module Brawl
  module Communications
    class ProxyGenerator
      def self.link(com_layer, server)
        client.public_methods(false).each do |method|
          com_layer.link_method(client, server, method)
        end
      end
    end
  end
end