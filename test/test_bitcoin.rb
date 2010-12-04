require 'helper'

class TestBitcoin < Test::Unit::TestCase
  
  context "The Bitcoin library" do
    
    # This is the smallest amount of work the gem can do to be of any use
    context "calling getinfo" do
      setup do
        # Execute a getinfo call
        @reponse = Bitcoin.getinfo
      end
      
      should "be successful" do
        assert @response
      end
      
      # Since the JSON-RPC API returns hashes it makes the most
      # sense to parse the JSON directly into hashes. Plus, I like hashes.
      should "return a Hash" do
        assert @response.is_a?(Hash), "Response was a #{@response.class.to_s}"
      end
      
      # Check the version number (this is arbitrary),
      # 0.3.17 beta was current when the gem was created
      # and the intention is not to support older versions.
      should "indicate a supported version" do
        assert @response['version'] >= 31700
      end
      
    end
    
  end
  
end
