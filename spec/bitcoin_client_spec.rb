require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Bitcoin::Client" do
  
  it "should call getinfo and return useful information" do
    @response = Bitcoin::Client.getinfo
    @response.should be_an_instance_of(Hash)
    @response.should have_key('version')
    @response['version'].should satisfy {|n| n >= 31700 }
  end
  
  it "should call gethashespersec and return a Fixnum" do
    @response = Bitcoin::Client.gethashespersec
    @response.should be_an_instance_of(Fixnum)
  end
  
  it "should call getbalance without params and return the total balance as a Float" do
    @response = Bitcoin::Client.getbalance
    @response.should be_an_instance_of(Float)
  end
  
  it "should call getblockcount and return the block count as a Fixnum" do
    @response = Bitcoin::Client.getblockcount
    @response.should be_an_instance_of(Fixnum)
  end
  
  it "should call getconnectioncount and return the number of peers as a Fixnum" do
    @response = Bitcoin::Client.getconnectioncount
    @response.should be_an_instance_of(Fixnum)
  end
  
  it "should call getdifficulty and return the current proof-of-work difficulty as a Float" do
    @response = Bitcoin::Client.getdifficulty
    @response.should be_an_instance_of(Float)
    @response.should satisfy { |n| n > 1.0 }
  end
  
  it "should call getgenerate and return whether or not the server is generating bitcoins" do
    @response = Bitcoin::Client.getgenerate
    [true, false].should include(@response)
  end
  
  it "should be able to validate a Bitcoin address" do
    @response = Bitcoin::Client.validateaddress '18V4MzDwX7q4548aXQoBeg7kedPzs67FsE'
    @response.should be_an_instance_of(Hash)
    
    @response.should have_key('isvalid')
    @response.should have_key('address')
    @response.should have_key('ismine')
    
    @response['address'].should match('18V4MzDwX7q4548aXQoBeg7kedPzs67FsE')
    @response['ismine'].should be_false
  end
  
end
