require 'json'

module Bitcoin
  
  # == The Bitcoin::Client class is an abstraction of the bitcoind CLI
  # To send calls to bitcoind simply call a method on Bitcoin::Client directly e.g.
  #  Bitcoin::Client.getinfo # => {'version' => 31700, ... }
  # 
  # Whilst I had considered cleaning the keys and method calls up to 
  # match typical Ruby formatting I decided to keep it as is to try
  # to accommodate other methods of interfacing with the client.
  class Client
    
    # Used by method calls to access the client. This should be configurable in later versions.
    EXECUTABLE = %{/Applications/Bitcoin.app/Contents/MacOS/bitcoin}
    
    # == Initiate a call to bitcoind getinfo
    # === Returns: A Hash with the following key/value pairs.
    #  { 'version' => Fixnum,        # The version of the client. 31700 implies 0.3.17.
    #    'balance' => Float,         # The current total balance in the wallet.
    #    'blocks' => Fixnum,         # The total numbers of blocks that has been downloaded.
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
    def self.getinfo
      JSON.parse `#{EXECUTABLE} getinfo`
    end
    
    # == Initiate a call to bitcoind gethashespersec
    # === Returns: A recent hashes per second performance measurement while generating as a Fixnum.
    def self.gethashespersec
      `#{EXECUTABLE} gethashespersec`.to_i
    end
    
    # == Initiate a call to bitcoind getbalance
    # === Returns: The server's available balance as a Float.
    def self.getbalance
      `#{EXECUTABLE} getbalance`.to_f
    end
    
    # == Initiate a call to bitcoind getblockcount
    # == Returns: The number of blocks in the longest block chain as a Fixnum.
    def self.getblockcount
      `#{EXECUTABLE} getblockcount`.to_i
    end
    
    # == Initiate a call to bitcoind getconnectioncount
    # == Returns: The number of peers the server is connected to as a Fixnum.
    def self.getconnectioncount
      `#{EXECUTABLE} getconnectioncount`.to_i
    end
    
    # == Initiate a call to bitcoind getdifficulty
    # == Returns: The difficulty factor of generating a block as a Float.
    def self.getdifficulty
      `#{EXECUTABLE} getdifficulty`.to_f
    end
    
    # == Initiate a call to bitcoind getgenerate
    # === Returns: True if the server is generating bitcoins, false if not.
    def self.getgenerate
      `#{EXECUTABLE} getgenerate` == 'true'
    end
    
    # == Initiate a call to bitcoind validateaddress
    # === Returns: A Hash with the following key/value pairs.
    #  { 'isvalid' => Boolean,        # True if the address is valid, false otherwise.
    #    'ismine'  => Boolean,        # True if the address is in the wallet, false if it as valid but not in the wallet or missing otherwise.
    #    'address' => String }        # The address passed in if it is valid, otehrwise this key will be missing.
    def self.validateaddress(address)
      JSON.parse `#{EXECUTABLE} validateaddress #{address}`
    end
    
  end
  
end