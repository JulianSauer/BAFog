require '../../src/clouds/cloud_provider'
require 'fog'
require 'fog/digitalocean'

class DigitalOcean < CloudProvider

  def initialize
    super('doUser', 'doPassword')
  end

  def create_node
    puts 'Creating node...'
    image = 0
    @connection.images.each do |i|
      if i.name.include? '1404'
        image = i.id
      end
    end
    @connection.servers.create({:name => get_node_name, :image => image, :size => get_size,
                                :region => @connection.regions.first.slug})
    puts 'done.'
  end

  def get_connection
    @connection = Fog::Compute.new({
                                       :provider => 'DigitalOcean',
                                       :version => 'V2',
                                       :digitalocean_token => '2f1573cb2355bf24e27460831b5f8b901e3bb6197f0b11d6ba78e98d22b0b0a1',
                                   })
  end

  def get_size
    @connection.flavors.each do |size|
      if size.slug.eql? '512mb'
        return size.slug
      end
    end
  end

end