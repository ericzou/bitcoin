$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'rspec'

# Code coverage reporting
require 'simplecov'
SimpleCov.start

# Stub out the bitcoind client with the stubcoin client emulator
BITCOIN_EXECUTABLE = File.join(File.dirname(__FILE__), '..', 'bin', 'stubcoin')
require 'bitcoin'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|
  
end
