# Custom tags: strange, error
#   Description: 
#   ・strange・・・tag means the example tests strange behavior of code
#   ・error・・・tag means the example only has code that raises an error, but does not tests it
#   Filtering:
#     For example, if you want to run a test with an error tag:
#     rspec --tag error

require 'debug'
Dir[File.expand_path('app/*.rb')].each { |file| require file }

RSpec.configure do |config|
  # for rspec --only-failures flag
  # see 「effective testing with rspec3」 P.23
  config.example_status_persistence_file_path = "spec/examples.txt"
  config.filter_run_when_matching :focus
end