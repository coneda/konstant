ENV["RUBY_ENV"] = "test"

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'konstant'

require "debugger"

RSpec.configure do |config|
  config.before :each do |example|
    Konstant.reset_config

    Konstant.configure "data_dir" => "#{Konstant.root}/tmp/test_data"
    Konstant.reset_data_dir

    if example.metadata[:fixture_projects]
      Konstant.copy_fixture_projects
    end
  end
end