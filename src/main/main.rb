require '../../src/clouds/cloud_provider'
require '../../src/clouds/amazon_web_services'
require '../../src/clouds/digital_ocean'
require '../../src/clouds/google_compute_engine'
require '../../src/clouds/profit_bricks'

class Main

  def run
    test(AmazonWebServices.new)
    test(DigitalOcean.new)
    test(GoogleComputeEngine.new)
    test(ProfitBricks.new)
  end

  def test(cloud)
    puts cloud.to_s
    cloud.destroy_nodes
    cloud.list_nodes
    cloud.create_node
    cloud.list_nodes
    puts ''
  end

end

Main.new.run
