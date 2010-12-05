require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Bitcoin::Client" do
  
  describe "calling getinfo" do 
    
    it "returns useful information" do
      @response = Bitcoin::Client.getinfo
      @response.should be_an_instance_of(Hash)
      
      @response.should have_key('version')
      @response['version'].should == 31700
      
      @response.should have_key('balance')
      @response['balance'].should == 84.0
      
      @response.should have_key('blocks')
      @response['blocks'].should == 90000
      
      @response.should have_key('connections')
      @response['connections'].should == 12
      
      @response.should have_key('proxy')
      @response['proxy'].should be_empty
      
      @response.should have_key('generate')
      @response['generate'].should be_true
      
      @response.should have_key('genproclimit')
      @response['genproclimit'].should == -1
      
      @response.should have_key('difficulty')
      @response['difficulty'].should == 8032.0
      
      @response.should have_key('hashespersec')
      @response['hashespersec'].should == 750000
      
      @response.should have_key('testnet')
      @response['testnet'].should be_false
      
      @response.should have_key('keypoololdest')
      @response['keypoololdest'].should == 1291276195
      
      @response.should have_key('paytxfee')
      @response['paytxfee'].should == 0.0
      
      @response.should have_key('errors')
      @response['errors'].should be_empty
    end
  end
  
  it "should call gethashespersec and return a Fixnum" do
    @response = Bitcoin::Client.gethashespersec
    @response.should be_an_instance_of(Fixnum)
    @response.should == 750000
  end
  
  it "should call getbalance without params and return the total balance as a Float" do
    @response = Bitcoin::Client.getbalance
    @response.should be_an_instance_of(Float)
    @response.should == 84.0
  end
  
  it "should call getblockcount and return the block count as a Fixnum" do
    @response = Bitcoin::Client.getblockcount
    @response.should be_an_instance_of(Fixnum)
    @response.should == 90000
  end
  
  it "should call getconnectioncount and return the number of peers as a Fixnum" do
    @response = Bitcoin::Client.getconnectioncount
    @response.should be_an_instance_of(Fixnum)
    @response.should == 12
  end
  
  it "should call getdifficulty and return the current proof-of-work difficulty as a Float" do
    @response = Bitcoin::Client.getdifficulty
    @response.should be_an_instance_of(Float)
    @response.should == 8032.0
  end
  
  it "should call getgenerate and return whether or not the server is generating bitcoins" do
    @response = Bitcoin::Client.getgenerate
    @response.should be_true
  end
  
  it "should be able to validate a Bitcoin address" do
    @response = Bitcoin::Client.validateaddress '18V4MzDwX7q4548aXQoBeg7kedPzs67FsE'
    @response.should be_an_instance_of(Hash)
    
    @response.should have_key('isvalid')
    @response.should have_key('address')
    @response.should have_key('ismine')
    
    @response['isvalid'].should be_true
    @response['ismine'].should be_false
    @response['address'].should match('18V4MzDwX7q4548aXQoBeg7kedPzs67FsE')
  end
  
end
