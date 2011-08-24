if RUBY_VERSION =~ /^1.9/ && ENV["COVERAGE"]
  require 'simplecov'
  SimpleCov.start
end

require 'assert'
require 'log4r'
require 'mocha'
require 'yaml'

if RUBY_VERSION =~ /^1.9/
  YAML::ENGINE.yamler= 'syck'
end

# add the current gem root path to the LOAD_PATH
root_path = File.expand_path("../..", __FILE__)
if !$LOAD_PATH.include?(root_path)
  $LOAD_PATH.unshift(root_path)
end
require 'ad-framework'

class Assert::Context
  include Mocha::API
end

require 'test/support/attributes'
require 'test/support/attribute_types'
require 'test/support/auxiliary_classes'
require 'test/support/structural_classes'

root_path = File.expand_path("../..", __FILE__)
ldap_config = YAML.load(File.open(File.join(root_path, "test", "ldap.yml")))

FileUtils.mkdir_p(File.join(root_path, "log"))
logger = Log4r::Logger.new("AD::Framework")
logger.add(Log4r::FileOutputter.new('fileOutputter', {
  :filename => File.join(root_path, "log", "test.log"),
  :trunc => false,
  :formatter => Log4r::PatternFormatter.new(:pattern => "[%l] %d :: %m")
}))

AD::Framework.configure do |config|
  config.ldap do |ldap|
    ldap.host = ldap_config[:host]
    ldap.port = ldap_config[:port]
    ldap.encryption = ldap_config[:encryption]
    ldap.auth = ldap_config[:auth]
  end
  config.treebase = ldap_config[:base]
  config.logger = logger
  config.search_size_supported = false
  config.run_commands = false
end
