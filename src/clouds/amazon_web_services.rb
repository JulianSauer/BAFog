require '../../src/clouds/cloud_provider'
require 'fog/aws'

class AmazonWebServices < CloudProvider

  def initialize
    super('awsUser', 'awsPassword')
  end

  def create_node
    puts 'Creating node...'
    username = 'ubuntu'
    server = @connection.servers.bootstrap(:name => get_node_name, :image_id => 'ami-fc2a2a94',
                                           :private_key_path => '~/.ssh/id_rsa',
                                           :public_key_path => '~/.ssh/id_rsa.pub', :username => username)

    host = server.public_ip_address
    init_script(host, username)
    puts 'done.'
  end

  def get_connection
    @connection = Fog::Compute.new({
                                       :provider => 'AWS',
                                       :aws_access_key_id => @user,
                                       :aws_secret_access_key => @password
                                   })
  end

end