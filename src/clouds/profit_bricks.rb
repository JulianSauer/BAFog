require 'fog/profitbricks'
require '../../src/clouds/cloud_provider'

class ProfitBricks < CloudProvider

  def initialize
    super('pbUser', 'pbPassword', 'ProfitBricks')
  end

  def get_connection
    @connection = Fog::Compute.new({
                                       :provider => @provider,
                                       :profitbricks_username => @user,
                                       :profitbricks_password => @password
                                   })
  end

  def create_node
    puts 'Creating node...'
    begin
      datacenter = @connection.datacenters.all.find { |dc| dc.name == 'fog' }
      @connection.servers.create(:data_center_id => datacenter.id, :cores => 1, :ram => 1024, :options => {:serverName => get_node_name})
    rescue NameError
      puts 'Node creation failed.'
      puts '(Some requirements might have bricked this)'
      return
    end
    puts 'done.'
  end

end