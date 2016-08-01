require 'fog/profitbricks'
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
    @connection.servers.create(:data_center_id => 'fog', :cores => 1, :ram => 1024, :options => { :serverName => 'FogServer' })
  end

end