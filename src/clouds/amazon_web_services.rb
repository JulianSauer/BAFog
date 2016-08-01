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

end