require '../../src/clouds/cloud_provider'
require 'fog/google'

class GoogleComputeEngine < CloudProvider

  def initialize
    super('gceUser', 'gcePassword', 'google')
  end

  def get_connection
    @connection = Fog::Compute.new({
                                       :provider => 'google',
                                       :google_client_email => @user,
                                       :google_json_key_location => @password,
                                       :google_project => 'jclouds-1376'
                                   })
  end

end