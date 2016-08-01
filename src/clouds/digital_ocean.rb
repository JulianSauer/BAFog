require '../../src/clouds/cloud_provider'
require 'fog/digitalocean/compute_v2'
require 'fog'
class DigitalOcean < CloudProvider

  def initialize
    super('doUser', 'doPassword', 'DigitalOcean')
  end

  def get_connection
    @connection = Fog::Compute.new({
                                       :provider => 'DigitalOcean',
                                       :version => 'V2',
                                       :digitalocean_token => '2f1573cb2355bf24e27460831b5f8b901e3bb6197f0b11d6ba78e98d22b0b0a1',
                                   })
  end

  def create_node
    puts 'Creating node...'
    @connection.servers.create({:name => get_node_name, :image => get_image, :size => get_size, :region => get_region})
    puts 'done.'
  end

  def get_image
    @connection.images[1].id
  end

  def get_size
    @connection.flavors.each do |size|
      if size.slug.eql? '512mb'
        return size.slug
      end
    end
  end

  def get_region
    @connection.regions.first.slug
  end

end