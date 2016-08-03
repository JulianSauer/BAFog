require '../../src/clouds/cloud_provider'

class GoogleComputeEngine < CloudProvider

  def initialize
    super('gceUser', 'gcePassword', 'google')
  end

  def get_connection
    @connection = Fog::Compute.new({
                                       :provider => 'google',
                                       :google_project => 'jclouds-1376',
                                       :google_client_email => @user,
                                       :google_json_key_location => @password
                                   })
  end

  def create_node
    puts 'Creating node...'
    disk = get_disk
    disk.wait_for { ready? }
    server = @connection.servers.bootstrap(:name => get_node_name,
                                           :machine_type => 'f1-micro',
                                           :zone_name => 'us-central1-a',
                                           :disks => [disk.get_as_boot_disk],
                                           :private_key_path => '~/.ssh/id_rsa',
                                           :public_key_path => '~/.ssh/id_rsa.pub',
                                           :username => 'ubuntu')

    host = server.public_ip_address
    user = 'ubuntu'
    pass = ''

    Net::SSH.start(host, user, :password => pass) do |ssh|
      puts ssh.exec!('sudo apt-get update')
      puts ssh.exec!('sudo apt-get install maven git openjdk-7-jdk -y')
      puts ssh.exec!('sudo git clone https://github.com/ewolff/user-registration.git /home/app/')
      puts ssh.exec!('sudo mvn -f /home/app/user-registration-application/pom.xml clean package') # spring-boot:run not working
      puts ssh.exec!('java -jar /home/app/user-registration-application/target/user-registration-application-0.0.1-SNAPSHOT.war')
    end

    puts 'done.'
  end

  def get_disk
    @connection.disks.create({
                                 :name => get_node_name,
                                 :zone_name => "us-central1-a",
                                 :size_gb => 10,
                                 :source_image => "debian-7-wheezy-v20150325"})
  end

end