require 'helper'

class TestBitcoinClient < Test::Unit::TestCase
  
  context "Bitcoin::Client" do
    
    should "call getinfo return useful information" do
      @response = Bitcoin::Client.getinfo
      assert @response
      assert @response.is_a?(Hash), "Response was a #{@response.class.to_s}, not a Hash."
      assert @response['version'] >= 31700
    end
    
    should "call gethashespersec and return a Fixnum" do
      @response = Bitcoin::Client.gethashespersec
      assert @response.is_a?(Fixnum), "Response was a #{@response.class.to_s}, not a Fixnum."
    end
    
    should "call getbalance without params and return the total balance as a Float" do
      @response = Bitcoin::Client.getbalance
      assert @response.is_a?(Float), "Response was a #{@response.class.to_s}, not a Float."
    end
    
    should "call getblockcount and return the block count as a Fixnum" do
      @response = Bitcoin::Client.getblockcount
      assert @response.is_a?(Fixnum), "Response was a #{@response.class.to_s}, not a Fixnum."
    end
    
    should "call getconnectioncount and return the number of peers as a Fixnum" do
      @response = Bitcoin::Client.getconnectioncount
      assert @response.is_a?(Fixnum), "Response was a #{@response.class.to_s}, not a Fixnum."
    end
    
    should "call getdifficulty and return the current proof-of-work difficulty as a Float" do
      @response = Bitcoin::Client.getdifficulty
      assert @response.is_a?(Float), "Response was a #{@response.class.to_s}, not a Float."
      assert @response > 1.0,        "Response was an unreasonable number. It should be greater than 1."
    end
    
    should "call getgenerate and return whether or not the server is generating bitcoins" do
      @response = Bitcoin::Client.getgenerate
      assert @response.is_a?(TrueClass) || @response.is_a?(FalseClass), "Response was a #{@response.class.to_s}, not true or false."
    end
    
    should "be able to validate a Bitcoin address" do
      @response = Bitcoin::Client.validateaddress '18V4MzDwX7q4548aXQoBeg7kedPzs67FsE'
      assert @response.is_a?(Hash), "Response was a #{@response.class.to_s}, not a Hash."
      
      assert @response.has_key?('isvalid'),  "Response is missing the 'isvalid' key."
      assert @response.has_key?('address'), "Response is missing the 'address' key."
      assert @response.has_key?('ismine'),  "Response is missing the 'ismine' key."
      
      assert @response['address'] == '18V4MzDwX7q4548aXQoBeg7kedPzs67FsE'
      assert @response['ismine'] == false, "Response indicated the key is yours, but it should not be."
    end
    
  end
  
end
