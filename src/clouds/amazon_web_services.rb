require '../../src/clouds/cloud_provider'
require 'fog/aws'

class AmazonWebServices < CloudProvider

  def initialize
    super('awsUser', 'awsPassword', 'AWS')
  end

  def get_connection
    @connection = Fog::Compute.new({
                                       :provider => @provider,
                                       :aws_access_key_id => @user,
                                       :aws_secret_access_key => @password
                                   })
  end

  def create_node
    #server = @connection = Fog::Compute.new({:provider => @provider, :aws_access_key_id => @user, :aws_secret_access_key => @password})
    server = @connection.servers.bootstrap(:image_id => 'ami-fc2a2a94', :private_key_path => '~/.ssh/id_rsa', :public_key_path => '~/.ssh/id_rsa.pub', :username => 'ubuntu')

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

  end
end