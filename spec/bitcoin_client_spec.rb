require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Bitcoin::Client do
  
  describe "calling getinfo" do 
    before(:all) do
      @response = Bitcoin::Client.getinfo
    end
    
    it "returns a Hash" do
      @response.should be_an_instance_of(Hash)
    end
    it "indicates the version of the client" do
      @response.should have_key('version')
      @response['version'].should == 31700
    end
    it "indicates the balance on the client" do
      @response.should have_key('balance')
      @response['balance'].should == 84.0
    end
    it "indicates the number of blocks downloaded" do
      @response.should have_key('blocks')
      @response['blocks'].should == 90000
    end
    it "indicates the current number of connections to peers" do
      @response.should have_key('connections')
      @response['connections'].should == 12
    end
    it "indicates the proxy in use if any" do
      @response.should have_key('proxy')
      @response['proxy'].should be_empty
    end
    it "indicates whether the client is generating blocks" do
      @response.should have_key('generate')
      @response['generate'].should be_true
    end
    it "indicates how many processors the client is allowed to use" do
      @response.should have_key('genproclimit')
      @response['genproclimit'].should == -1
    end
    it "indicates the current difficulty prescribed by the network" do
      @response.should have_key('difficulty')
      @response['difficulty'].should == 8032.0
    end
    it "indicates how many hash operations the client completes every second" do
      @response.should have_key('hashespersec')
      @response['hashespersec'].should == 750000
    end
    it "indicates whether the client is running on the test network" do
      @response.should have_key('testnet')
      @response['testnet'].should be_false
    end
    it "indicates the age of the oldest available address in the key pool" do
      @response.should have_key('keypoololdest')
      @response['keypoololdest'].should == 1291276195
    end
    it "indicates the transaction fee it adds to every transaction" do
      @response.should have_key('paytxfee')
      @response['paytxfee'].should == 0.0
    end
    it "indicates errors if they occur" do
      @response.should have_key('errors')
      @response['errors'].should be_empty
    end
    
  end
  
  describe "calling gethashespersec" do
    before :all do
      @response = Bitcoin::Client.gethashespersec
    end
    
    it "returns a Fixnum" do
      @response.should be_an_instance_of(Fixnum)
    end
    it "returns the number of hashes currently being generated every second" do
      @response.should == 750000
    end
    
  end
  
  describe "calling getbalance" do
    
    describe "without params" do
      before :all do
        @response = Bitcoin::Client.getbalance
      end
      
      it "returns a Float" do
        @response.should be_an_instance_of(Float)
      end
      it "returns the total balance on the client" do
        @response.should == 84.0
      end
      
    end
    
  end
  
  describe "calling getblockcount" do
    before :all do
      @response = Bitcoin::Client.getblockcount
    end
    
    it "returns a Fixnum" do
      @response.should be_an_instance_of(Fixnum)
    end
    it "returns the total block count downloaded" do
      @response.should == 90000
    end
    
  end
  
  describe "calling getconnectioncount" do
    before :all do
      @response = Bitcoin::Client.getconnectioncount
    end
    
    it "returns a Fixnum" do
      @response.should be_an_instance_of(Fixnum)
    end
    it "returns the number of peers the client is currently connected to" do
      @response.should == 12
    end
  end
  
  describe "calling getdifficulty" do
    before :all do
      @response = Bitcoin::Client.getdifficulty
    end
    
    it "returns a Float" do
      @response.should be_an_instance_of(Float)
    end
    it "returns the current proof-of-work difficulty" do
      @response.should == 8032.0
    end
  
  end
  
  describe "calling getgenerate" do
    before :all do
      @response = Bitcoin::Client.getgenerate
    end
    
    it "returns whether or not the server is generating bitcoins" do
      @response.should be_true
    end
  
  end
  
  describe "calling validateaddress" do
    
    describe "with an invalid address" do
      before :all do
        @response = Bitcoin::Client.validateaddress 'abcdefghijklmnpqrstuvwxyzABCDEFGHJ'
      end
      
      it "returns a Hash" do
        @response.should be_an_instance_of(Hash)
      end
      it "specifies that the address is not valid" do
        @response.should have_key('isvalid')
        @response['isvalid'].should be_false
      end
      it "does not return the invalid address" do
        @response.should_not have_key('address')
      end
      
    end
    
    describe "with a valid address" do
      
      describe "that is not in the wallet" do
        before :all do
          @response = Bitcoin::Client.validateaddress '18V4MzDwX7q4548aXQoBeg7kedPzs67FsE'
        end
        
        it "returns a Hash" do
          @response.should be_an_instance_of(Hash)
        end
        it "returns the address" do
          @response.should have_key('address')
          @response['address'].should match('18V4MzDwX7q4548aXQoBeg7kedPzs67FsE')
        end
        it "specifies that the address is valid" do
          @response.should have_key('isvalid')
          @response['isvalid'].should be_true
        end
        it "specifies that the address is not in the wallet" do
          @response.should have_key('ismine')
          @response['ismine'].should be_false
        end
        
      end
      
      describe "that is in the wallet" do
        before :all do
          @response = Bitcoin::Client.validateaddress '1HkiBfDUL1e8Cbb8Q34asW1mUGybNKwkpU'
        end
        
        it "returns a Hash" do
          @response.should be_an_instance_of(Hash)
        end
        it "returns the address" do
          @response.should have_key('address')
          @response['address'].should match('1HkiBfDUL1e8Cbb8Q34asW1mUGybNKwkpU')
        end
        it "specifies that the address is valid" do
          @response.should have_key('isvalid')
          @response['isvalid'].should be_true
        end
        it "specifies that the address is in the wallet" do
          @response.should have_key('ismine')
          @response['ismine'].should be_true
        end
        
      end
      
    end
  
  end
  
end
