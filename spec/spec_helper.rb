ENV["RUBY_ENV"] = "test"

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'konstant'

require "byebug"

Mail.defaults do
  delivery_method :test
end

RSpec.configure do |config|
  config.before :each do |example|
    Konstant.logger = Logger.new("/dev/null")

    Konstant.reset_config

    Konstant.configure "#{Konstant.root}/data/templates/data_dir/konstant.js"
    Konstant.configure "data_dir" => "#{Konstant.root}/tmp/test_data"

    Konstant.reset_data_dir

    if example.metadata[:fixture_projects]
      Konstant.copy_fixture_projects
    end
  end
end