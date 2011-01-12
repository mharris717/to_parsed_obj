$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'rspec'
require 'to_parsed_obj'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|
  
end


RSpec::Matchers.define :parse_to do |expected|
  match do |base_str|
    @base_str = base_str
    @parsed = base_str.to_parsed_obj
    @parsed == expected
  end
  failure_message_for_should do |arg|
    "Expected #{@base_str} to parse to #{expected.inspect}, actually parsed to #{@parsed.inspect}"
  end
end

def mit(name,&b)
  it(name,&b) #if name == "should parse time inspect"
end