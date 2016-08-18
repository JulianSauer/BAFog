require '../../src/clouds/cloud_provider'

class GoogleComputeEngine < CloudProvider

  def initialize
    super('gceUser', 'gcePassword')
  end

  def create_node
    puts 'Creating node...'
    disk = get_disk
    disk.wait_for { ready? }

    username = 'ubuntu'
    server = @connection.servers.bootstrap(:name => get_node_name, :machine_type => 'f1-micro',
                                           :zone_name => 'us-central1-a', :disks => [disk.get_as_boot_disk],
                                           :private_key_path => '~/.ssh/id_rsa',
                                           :public_key_path => '~/.ssh/id_rsa.pub',
                                           :username => username)

    host = server.public_ip_address
    init_script(host, username)
    puts 'done.'
  end

  def get_connection
    @connection = Fog::Compute.new({
                                       :provider => 'google',
                                       :google_project => 'jclouds-1376',
                                       :google_client_email => @user,
                                       :google_json_key_location => @password
                                   })
  end

  def get_disk
    @connection.disks.create({
                                 :name => get_node_name,
                                 :zone_name => "us-central1-a",
                                 :size_gb => 10,
                                 :source_image => "ubuntu-1404-trusty-v20150316"})
  end

end