ENV["RUBY_ENV"] = "test"

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'konstant'

require "debugger"

RSpec.configure do |config|
  config.before :each do
    Konstant.reset_config

    Konstant.configure "data_dir" => "#{Konstant.root}/tmp/test_data"
    Konstant.reset_data_dir
  end
end