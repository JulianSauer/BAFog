require '../../src/clouds/cloud_provider'
require 'fog'
require 'fog/digitalocean'

class DigitalOcean < CloudProvider

  def initialize
    super('doUser', 'doPassword')
  end

  def create_node
    puts 'Creating node...'
    server = @connection.servers.create({:name => get_node_name, :image => get_image, :size => get_size, :region => get_region, :private_key_path => '~/.ssh/id_rsa', :public_key_path => '~/.ssh/id_rsa.pub', :username => 'ubuntu', :password => ''})
    server.wait_for { ready? } # Not working as expected

    host = server.public_ip_address
    user = 'ubuntu'
    pass = 'password'

    Net::SSH.start(host, user, :password => pass) do |ssh|
      puts ssh.exec!('sudo apt-get update')
      puts ssh.exec!('sudo apt-get install maven git openjdk-7-jdk -y')
      puts ssh.exec!('sudo git clone https://github.com/ewolff/user-registration.git /home/app/')
      puts ssh.exec!('sudo mvn -f /home/app/user-registration-application/pom.xml spring-boot:run')
    end
    puts 'done.'
  end

  def get_connection
    @connection = Fog::Compute.new({
                                       :provider => 'DigitalOcean',
                                       :version => 'V2',
                                       :digitalocean_token => '2f1573cb2355bf24e27460831b5f8b901e3bb6197f0b11d6ba78e98d22b0b0a1',
                                   })
  end

  def get_image
    id = 16082940 # Ubuntu 14.04
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