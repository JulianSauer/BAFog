require 'fog'

class CloudProvider

  @user
  @password
  @provider

  @connection

  def initialize(user_key, password_key, provider)
    @user = get_value(user_key)
    @password = get_value(password_key)
    @provider = provider
    @connection = get_connection
  end

  def get_connection
    puts 'Not implemented'
  end

  def create_node
    @connection.servers.create(:name => 'fog' + Time.now.strftime('%d%m%y-%H%M'))
  end

  def destroy_nodes
    for server in @connection.servers
      server.destroy
    end
  end

  def list_nodes
    puts @connection.servers.to_s
  end

  def get_value(key)
    file = File.open('../../resources/accounts.txt', 'r')
    file.each_line do |line|
      if line.include? key + ' = '
        value = line
        value.slice! key + ' = '
        return value.chomp
      end
    end
  end

end