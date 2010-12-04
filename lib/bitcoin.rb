require 'json'

# == The Bitcoin module is an abstraction of the bitcoind CLI
# To send calls to bitcoind simply call a method on Bitcoin directly e.g.
#  Bitcoin.getinfo # => {'version' => 31700, ... }
# 
# Whilst I had considered cleaning the keys and method calls up to 
# match typical Ruby formatting I decided to keep it as is to try
# to accommodate other methods of interfacing with the client.
module Bitcoin
  
  # Used by method calls to access the client. This should be configurable in later versions.
  EXECUTABLE = %{/Applications/Bitcoin.app/Contents/MacOS/bitcoin}
  
  # == Initiate a call to bitcoind getinfo
  # === Returns: 
  #  { 'version' => Fixnum,        # The version of the client. 31700 implies 0.3.17
  #    'balance' => Float,         # The current total balance in the wallet
  #    'blocks' => Fixnum,         # The total numbers of blocks that has been downloaded
  #    'connections' => Fixnum,    # Number of peers the client is connected to
  #    'proxy' => String,          # The proxy the client is using, or empty if none.
  #    'generate' => Boolean,      # True if the client is mining, false otherwise.
  #    'genproclimit' => Fixnum,   # Number of processors being used for mining. -1 means all available processors.
  #    'difficulty' => Float,      # Current difficulty used by the network to adjust the rate at which blocks are mined.
  #    'hashespersec' => Fixnum,   # How many hashes your computer is generating each second.
  #    'testnet' => Boolean,       # True means your client operates on the test network, false means you are on the 'real' netowrk.
  #    'keypoololdest' => Fixnum,  # The time when the oldest key in the keypool was generated.
  #    'paytxfee' => Float,        # The trannsaction fee the cient is currently set to pay.
  #    'errors' => String }        # Warnings returned by the client. Haven't had any yet.
  def self.getinfo
    JSON.parse `#{EXECUTABLE} getinfo`
  end
  
end