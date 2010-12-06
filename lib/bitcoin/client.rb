require 'json'

module Bitcoin # :nodoc
  
  # == The Bitcoin::Client class is an abstraction of the bitcoind CLI
  # To send calls to bitcoind simply call a method on Bitcoin::Client directly e.g.
  #  Bitcoin::Client.getinfo # => {'version' => 31700, ... }
  # 
  # Whilst I had considered cleaning the keys and method calls up to 
  # match typical Ruby formatting I decided to keep it as is to try
  # to accommodate other methods of interfacing with the client.
  class Client
    
    # Used by method calls to access the client. This is configurable by defining 
    # BITCOIN_EXECUTABLE before requiring bitcoin.
    # 
    # The default value is '/Applications/Bitcoin.app/Contents/MacOS/bitcoin'
    # 
    EXECUTABLE = BITCOIN_EXECUTABLE || %{/Applications/Bitcoin.app/Contents/MacOS/bitcoin}
    
    # === Initiate a call to bitcoind backupwallet
    # 
    # There is some logic added here to help you determine whether the backup succeeded.
    # The system checks if file was modified since this method was called and that its
    # size is non-zero for good measure.
    # 
    # <b>Arguments</b>: (String) path
    # 
    # <b>Returns</b>: True if the system figures it worked
    #
    def self.backupwallet(path)
      
      # Do some cursory investigation
      start_time = Time.now
      file_existed = File.exists?(path)
      
      # Trigger the backup
      `#{EXECUTABLE} backupwallet #{path}`
      
      # Make an estimation as to whether it succeeded or not
      (File.stat(path).mtime > start_time) && (File.stat(path).directory? || File.stat(path).size > 0)
      
    end
    
    # === Initiate a call to bitcoind getaccount
    # 
    # <em>Take care with this method. It does not identify invalid addresses
    # or those not in the wallet. I recommend using ::validateaddress instead
    # since that also returns the account name.</em>
    # 
    # <b>Arguments</b>: (String) address
    # 
    # <b>Returns</b>: The name of the account the address belongs to as a String
    # 
    def self.getaccount(address)
      `#{EXECUTABLE} getaccount #{address}`.gsub("\n", '')
    end
    
    # === Initiate a call to bitcoind getaccountaddress
    # 
    # This is synonymous with getnewaddress, but since getnewaddress also
    # allows the creation of new addresses on the default account it is the
    # preferred method of achieving this. This may have been deprecated by
    # Bitcoin.
    # 
    # <b>Arguments</b>: (String) account
    # 
    # <b>Returns</b>: The new address as a String
    # 
    def self.getaccountaddress(account)
      `#{EXECUTABLE} getaccountaddress "#{account}"`.gsub("\n", '')
    end
    
    # === Initiate a call to bitcoind getaddressesbyaccount
    # 
    # <b>Arguments</b>: (String) account
    # 
    # <b>Returns</b>: An Array containing the addresses as Strings
    # 
    def self.getaddressesbyaccount(account)
      JSON.parse `#{EXECUTABLE} getaddressesbyaccount "#{account}"`
    end
    
    # === Initiate a call to bitcoind getbalance
    # 
    # <b>Returns</b>: The server's available balance as a Float.
    # 
    def self.getbalance
      `#{EXECUTABLE} getbalance`.to_f
    end
    
    # === Initiate a call to bitcoind getblockcount
    # 
    # <b>Returns</b>: The number of blocks in the longest block chain as a Fixnum.
    # 
    def self.getblockcount
      `#{EXECUTABLE} getblockcount`.to_i
    end
    
    # === Initiate a call to bitcoind getconnectioncount
    # 
    # <b>Returns</b>: The number of peers the server is connected to as a Fixnum.
    # 
    def self.getconnectioncount
      `#{EXECUTABLE} getconnectioncount`.to_i
    end
    
    # === Initiate a call to bitcoind getdifficulty
    # 
    # <b>Returns</b>: The difficulty factor of generating a block as a Float.
    # 
    def self.getdifficulty
      `#{EXECUTABLE} getdifficulty`.to_f
    end
    
    # === Initiate a call to bitcoind getgenerate
    # 
    # <b>Returns</b>: True if the server is generating bitcoins, false if not.
    # 
    def self.getgenerate
      `#{EXECUTABLE} getgenerate` =~ /true/
    end
    
    # === Initiate a call to bitcoind gethashespersec
    # 
    # <b>Returns</b>: A recent hashes per second performance measurement while generating as a Fixnum.
    # 
    def self.gethashespersec
      `#{EXECUTABLE} gethashespersec`.to_i
    end
    
    # === Initiate a call to bitcoind getinfo
    # 
    # <b>Returns</b>: A Hash with the following key/value pairs.
    #  { 'version' => Fixnum,        # The version of the client. 31700 implies 0.3.17.
    #    'balance' => Float,         # The current total balance in the wallet.
    #    'blocks' => Fixnum,         # The total number of blocks that has been downloaded.
    #    'connections' => Fixnum,    # Number of peers the client is connected to.
    #    'proxy' => String,          # The proxy the client is using, or empty if none.
    #    'generate' => Boolean,      # True if the client is mining, false otherwise.
    #    'genproclimit' => Fixnum,   # Number of processors being used for mining. -1 means all available processors.
    #    'difficulty' => Float,      # Current difficulty used by the network to adjust the rate at which blocks are mined.
    #    'hashespersec' => Fixnum,   # How many hashes your computer is generating each second.
    #    'testnet' => Boolean,       # True means your client operates on the test network, false means you are on the 'real' network.
    #    'keypoololdest' => Fixnum,  # The time when the oldest key in the keypool was generated.
    #    'paytxfee' => Float,        # The transaction fee the client is currently set to pay.
    #    'errors' => String }        # Warnings returned by the client. Haven't had any yet.
    # 
    def self.getinfo
      JSON.parse `#{EXECUTABLE} getinfo`
    end
    
    # === Initiate a call to bitcoind getnewaddress
    # 
    # This is the primary method of getting new addresses. If the 
    # account doesn't exist on the server it will be created.
    # 
    # <b>Arguments</b>: (String) account
    # 
    # <b>Returns</b>: The new address as a String
    # 
    def self.getnewaddress(account = nil)
      `#{EXECUTABLE} getnewaddress #{"\"#{account}\"" if account}`.gsub("\n", '')
    end
    
    # === Initiate a call to bitcoind getreceivedbyaccount
    # 
    # <b>Arguments</b>: (String) account
    # 
    # <b>Returns</b>: The account's available balance as a Float.
    #
    def self.getreceivedbyaccount(account)
      `#{EXECUTABLE} getreceivedbyaccount "#{account}"`.to_f
    end
    
    # === Initiate a call to bitcoind setgenerate
    # 
    # <b>Arguments</b>: (Boolean) active, (Fixnum) processors
    # 
    # <b>Returns</b>: Nil
    # 
    def self.setgenerate(active, processors = nil)
      `#{EXECUTABLE} setgenerate #{active} #{processors if processors && processors >= -1}`
    end
    
    # === Initiate a call to bitcoind stop
    # 
    # <b>Returns</b>: True if the server is attempting to stop
    # 
    def self.stop
      `#{EXECUTABLE} stop` =~ /bitcoin server stopping/
    end
    
    # === Initiate a call to bitcoind validateaddress
    # 
    # <b>Arguments</b>: (String) address
    # 
    # <b>Returns</b>: A Hash with the following key/value pairs.
    #  { 'isvalid' => Boolean,        # True if the address is valid, false otherwise.
    #    'ismine'  => Boolean,        # True if the address is in the wallet, false if it is valid but not in the wallet or missing otherwise.
    #    'address' => String }        # The address passed in if it is valid, otherwise this key will be missing.
    # 
    def self.validateaddress(address)
      JSON.parse `#{EXECUTABLE} validateaddress #{address}`
    end
    
  end
  
end