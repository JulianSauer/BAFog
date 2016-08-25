require '../../src/clouds/cloud_provider'
require '../../src/clouds/amazon_web_services'
require '../../src/clouds/digital_ocean'
require '../../src/clouds/google_compute_engine'
require '../../src/clouds/profit_bricks'

class Main

  def run
    AmazonWebServices.new.do_test_operations
    #DigitalOcean.new.do_test_operations
    #GoogleComputeEngine.new.do_test_operations
    #ProfitBricks.new.do_test_operations
  end

end

Main.new.run
