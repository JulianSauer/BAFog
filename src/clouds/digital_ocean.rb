class DigitalOcean < CloudProvider

  def initialize
    super('doUser', 'doPassword', 'DigitalOcean')
  end

  def get_connection
    @connection = Fog::Compute.new({
                                       :provider => @provider,
                                       :version => 'V2',
                                       :digitalocean_token => @password
                                   })
  end

  def create_node
    @connection.servers.create(:name => get_node_name,
                               :image => get_image,
                               :size => get_size,
                               :region => get_region)
  end

  def get_image
    @connection.images.each do |image|
      if image.distribution.eql? 'Ubuntu'
        return image.id
      end
    end
  end

  def get_size
    @connection.flavors.each do |size|
      if size.slug.eql? '512mb'
        return size
      end
    end
  end

  def get_region
    @connection.regions.first.slug
  end

end