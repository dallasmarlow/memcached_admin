require 'memcached'

class MemcachedAdmin
  attr_accessor :config, :clients

  def initialize config
    @config  = config
    @clients = {}

    setup :clients
  end

  def setup resource
    case resource
    when :clients
      config[:pools].each do |pool, nodes|
        clients[pool] = []

        nodes.each do |node|
          clients[pool] << [node, Memcached.new(node)]
        end
      end
    end
  end

  def stats
    stats = {}

    clients.each do |pool, nodes|
      stats[pool] = {}

      nodes.each do |node, client|
        stats[pool][node] = client.stats rescue :failed
      end
    end

    stats
  end
end