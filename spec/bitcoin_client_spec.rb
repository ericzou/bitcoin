require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Bitcoin::Client do
  
  describe "::backupwallet" do
    
    it "requires a path" do
      lambda { Bitcoin::Client.backupwallet }.should raise_error
    end
    it "with a directory path returns true" do
      Bitcoin::Client.backupwallet('.').should be_true
      FileUtils.rm_f(File.join '.', 'wallet.dat')
    end
    it "with a file path returns true" do
      Bitcoin::Client.backupwallet('wallet.dat').should be_true
      FileUtils.rm_f('wallet.dat')
    end
    
  end
  
  describe "::getaccount" do
    
    describe "with an address that is in the wallet" do
      before :all do
        @response = Bitcoin::Client.getaccount '1HkiBfDUL1e8Cbb8Q34asW1mUGybNKwkpU'
      end
      
      it "returns a String" do
        @response.should be_an_instance_of(String)
      end
      it "returns the name of the account" do
        @response.should == 'Michael Prins'
      end
      
    end
    
    describe "with an address that is not in the wallet but valid" do
      before :all do
        @response = Bitcoin::Client.getaccount '18V4MzDwX7q4548aXQoBeg7kedPzs67FsE'
      end
      
      it "returns an empty string" do
        @response.should be_an_instance_of(String)
        @response.should be_empty
      end
      
    end
    
    describe "with an address that is not valid" do
      before :all do
        @response = Bitcoin::Client.getaccount 'abcdefghijklmnpqrstuvwxyzABCDEFGHJ'
      end
      
      it "returns an empty string" do
        @response.should be_an_instance_of(String)
        @response.should be_empty
      end
      
    end
    
  end
  
  describe "::getaccountaddress" do
    
    describe "with an account name" do
      before :all do
        @response = Bitcoin::Client.getaccountaddress 'Michael Prins'
      end
      
      it "returns a String" do
        @response.should be_an_instance_of(String)
      end
      it "returns a new address assigned to this account" do
        @response.should == '1ESbthp2rPbyNgiASRMFWpRb2HtpvtYtmE'
      end
      
    end
    
    describe "with an acount name that doesn't exist" do
      before :all do
        @response = Bitcoin::Client.getaccountaddress 'New Account'
      end
      
      it "returns a String" do
        @response.should be_an_instance_of(String)
      end
      it "returns a new address assigned to a newly created account" do
        @response.should == '1Fs9Uxy2nBtAR7GQLB23JXCyuSLAYY4ACS'
      end
    end
    
    it "without an account name raises an error" do
      lambda { Bitcoin::Client.getaccountaddress }.should raise_error
    end
    
  end
  
  describe "::getaddressesbyaccount" do
    
    describe "with an account name that has an address" do
      before :all do
        @response = Bitcoin::Client.getaddressesbyaccount 'Michael Prins'
      end
      
      it "returns an Array containing Strings" do
        @response.should be_an_instance_of(Array)
        @response.first.should be_an_instance_of(String)
      end
      it "returns the addresses associated to that account" do
        @response.should include('1HkiBfDUL1e8Cbb8Q34asW1mUGybNKwkpU')
      end
      
    end
    
    describe "with an account name that doesn't exist" do
      before :all do
        @response = Bitcoin::Client.getaddressesbyaccount 'Kung Fu Panda'
      end
      
      it "returns an empty Array" do
        @response.should be_an_instance_of(Array)
        @response.should be_empty
      end
      
    end
    
    it "without an account name raises an error" do
      lambda { Bitcoin::Client.getaddressesbyaccount }.should raise_error
    end
    
  end
  
  describe "::getbalance" do
    
    describe "without any arguments" do
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
  
  describe "::getblockcount" do
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
  
  describe "::getconnectioncount" do
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
  
  describe "::getdifficulty" do
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
  
  describe "::getgenerate" do
    before :all do
      @response = Bitcoin::Client.getgenerate
    end
    
    it "returns whether or not the server is generating bitcoins" do
      @response.should be_true
    end
  
  end
  
  describe "::gethashespersec" do
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
  
  describe "::getinfo" do 
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
  
  describe "::getnewaddress" do
    
    describe "with an account name" do
      before :all do
        @response = Bitcoin::Client.getnewaddress 'Michael Prins'
      end
      
      it "returns a String" do
        @response.should be_an_instance_of(String)
      end
      it "returns a new address assigned to this account" do
        @response.should == '1ESbthp2rPbyNgiASRMFWpRb2HtpvtYtmE'
      end
      
    end
    
    describe "with an account name that doesn't exist" do
      before :all do
        @response = Bitcoin::Client.getnewaddress 'New Account'
      end
      
      it "returns a String" do
        @response.should be_an_instance_of(String)
      end
      it "returns a new address assigned to a newly created account" do
        @response.should == '1Fs9Uxy2nBtAR7GQLB23JXCyuSLAYY4ACS'
      end
    end
    
    describe "without an account name" do
      before :all do
        @response = Bitcoin::Client.getnewaddress
      end
      
      it "returns a String" do
        @response.should be_an_instance_of(String)
      end
      it "returns a new address assigned to the default account" do
        @response.should == '12kkn4wkDjDYr69Z27DFmWeMGe927YnZuj'
      end
      
    end
    
  end
  
  describe "::getreceivedbyaccount" do
    
    it "requires an account name" do
      lambda { Bitcoin::Client.getreceivedbyaccount }.should raise_error
    end
    it "does not take an optional minumum confirmations parameter" do
      # This functionality seems to be broken in 0.3.17 beta
      lambda { Bitcoin::Client.getreceivedbyaccount 'Michael Prins' }.should_not raise_error
      lambda { Bitcoin::Client.getreceivedbyaccount 'Michael Prins', 1 }.should raise_error
    end
    
    describe "with an account that has received and made transactions" do
      before :all do
        @response = Bitcoin::Client.getreceivedbyaccount 'Michael Prins'
      end
      
      it "returns a Float" do
        @response.should be_an_instance_of(Float)
      end
      it "returns the difference between transactions received and paid" do
        @response.should == 45.0
      end
      
    end
    
    describe "with an account that has no transactions" do
      before :all do
        @response = Bitcoin::Client.getreceivedbyaccount 'Bitcoin Faucet'
      end
      
      it "returns a Float" do
        @response.should be_an_instance_of(Float)
      end
      it "returns the difference between transactions received and paid" do
        @response.should == 0.0
      end
      
    end
    
  end
  
  describe ":getreceivedbyaddress" do
    
    it "requires an address" do
      lambda { Bitcoin::Client.getreceivedbyaddress }.should raise_error
    end
    it "takes an optional minimum confirmations parameter" do
      lambda { Bitcoin::Client.getreceivedbyaddress '1HkiBfDUL1e8Cbb8Q34asW1mUGybNKwkpU' }.should_not raise_error
      lambda { Bitcoin::Client.getreceivedbyaddress '1HkiBfDUL1e8Cbb8Q34asW1mUGybNKwkpU', 1 }.should_not raise_error
    end
    
    describe "with an address that has received and made transactions" do
      before :all do
        @response = Bitcoin::Client.getreceivedbyaddress '1HkiBfDUL1e8Cbb8Q34asW1mUGybNKwkpU'
      end
      
      it "returns a Float" do
        @response.should be_an_instance_of(Float)
      end
      it "returns the sum of the received transactions" do
        @response.should == 50.0
      end
      
    end
    
    describe "with an address that has received transactions and a minimum confirmation threshold" do
      before :all do
        @response = Bitcoin::Client.getreceivedbyaddress '1HkiBfDUL1e8Cbb8Q34asW1mUGybNKwkpU', 5
      end
      
      it "returns a Float" do
        @response.should be_an_instance_of(Float)
      end
      it "returns the total of all received transactions with at least the specified number of confirmations" do
        @response.should == 40.0
      end
      
    end
    
    describe "with an address that has not received transactions" do
      before :all do
        @response = Bitcoin::Client.getreceivedbyaddress '1ESbthp2rPbyNgiASRMFWpRb2HtpvtYtmE'
      end
      
      it "returns a Float" do
        @response.should be_an_instance_of(Float)
      end
      it "returns zero" do
        @response.should == 0.0
      end
      
    end
    
  end
  
  describe "::setgenerate" do
    
    it "requires a parameter to turn generation on or off" do
      lambda {
        Bitcoin::Client.setgenerate
      }.should raise_error
    end
    it "returns an empty string" do
      Bitcoin::Client.setgenerate(true).should be_empty
      Bitcoin::Client.setgenerate(false).should be_empty
    end
    it "optionally sets the number of processors to use" do
      lambda { Bitcoin::Client.setgenerate(true, 1) }.should_not raise_error
      lambda { Bitcoin::Client.setgenerate(true, -1) }.should_not raise_error
      lambda { Bitcoin::Client.setgenerate(true, -10) }.should_not raise_error
    end
    
  end
  
  describe "::stop" do
    before :all do
      @response = Bitcoin::Client.stop
    end
    
    it "returns true if the server is trying to stop" do
      @response.should be_true
    end
    
  end
  
  describe "::validateaddress" do
    
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
