require 'net/ssh'
require 'net/ssh/telnet'
require 'fog'

require '../../src/main/accounts'

class CloudProvider

  @user
  @password

  @connection

  def initialize(user_key, password_key)
    accounts = Accounts.new
    @user = accounts.get_value(user_key)
    @password = accounts.get_value(password_key)
    @connection = get_connection
  end

  def do_test_operations()
    puts 'Removing all nodes...'
    destroy_nodes
    puts 'done.'
    list_nodes
    puts 'Adding a node...'
    create_node
    puts 'done'
    list_nodes
  end

  private

  def create_node
    puts 'Not implemented'
  end

  def destroy_nodes
    begin
      for server in @connection.servers
        server.destroy
      end
    rescue NoMethodError, NameError
      puts 'Cannot delete nodes'
    end
  end

  def get_connection
    puts 'Not implemented'
  end

  def get_node_name
    'fog' + Time.now.strftime('%d%m%y-%H%M')
  end

  def list_nodes
    begin
      puts 'Nodes:'
      for server in @connection.servers
        puts server.id.to_s + ':  ' + server.public_ip_address.to_s
      end
    rescue NameError
      puts 'Cannot list nodes'
    end
  end

  def init_script(host, username)
    Net::SSH.start(host, username) do |ssh|
      puts ssh.exec!('sudo apt-get update')
      puts ssh.exec!('sudo apt-get install maven git openjdk-7-jdk -y')
      puts ssh.exec!('sudo git clone https://github.com/ewolff/user-registration.git /home/app/')
      puts ssh.exec!('sudo mvn -f /home/app/user-registration-application/pom.xml clean package') # spring-boot:run not working
      puts ssh.exec!('java -jar /home/app/user-registration-application/target/user-registration-application-0.0.1-SNAPSHOT.war')
    end
  end

end