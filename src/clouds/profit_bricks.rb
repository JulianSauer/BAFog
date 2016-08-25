require 'fog/profitbricks'
require '../../src/clouds/cloud_provider'

class ProfitBricks < CloudProvider

  def initialize
    super('pbUser', 'pbPassword')
  end

  private

  def create_node
    puts 'Creating node...'
    datacenter = @connection.datacenters.all.find { |dc| dc.name == 'fog' }
    server = @connection.servers.create(:data_center_id => datacenter.id, :cores => 1, :ram => 1024, :options => {:serverName => get_node_name})
    server.wait_for { ready? }

    image = @connection.images.all.find { |image| image.name =~ /Ubuntu-14.04/ && image.type == "HDD" && image.region == "us/fra" }
    volume = @connection.volumes.create(:data_center_id => datacenter.id, :size => 50, :options => {:storageName => 'FogVolume', :mountImageId => image.id})
    volume.wait_for { ready? }
    volume.attach(server.id)
    server.wait_for { ready? }
    server.reload
    puts 'done.'
  end

  def get_connection
    @connection = Fog::Compute.new({
                                       :provider => 'ProfitBricks',
                                       :profitbricks_username => @user,
                                       :profitbricks_password => @password
                                   })
  end

end