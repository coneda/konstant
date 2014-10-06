require "konstant/version"

require "logger"
require "json"
require "mail"

module Konstant

  autoload :Build, "konstant/build"
  autoload :Builder, "konstant/builder"
  autoload :Cli, "konstant/cli"
  autoload :Project, "konstant/project"
  autoload :Scheduler, "konstant/scheduler"
  autoload :Runner, "konstant/runner"
  autoload :Web, "konstant/web"

  def self.config
    @config ||= {}
  end

  def self.configure(new_config)
    case new_config
      when Hash then config.merge! new_config
      when String then config.merge! JSON.parse(File.read new_config)
    end
  end

  def self.reset_config
    @config = nil
  end

  def self.reset_data_dir
    system "rm -rf #{config['data_dir']}"
  end

  def self.copy_fixture_projects
    system "cp -a #{root}/data/templates/data_dir #{config['data_dir']}/"
    system "cp -a #{root}/spec/fixtures/projects/* #{config['data_dir']}/projects/"
  end

  def self.env
    ENV["RUBY_ENV"] || "production"
  end

  def self.root
    File.expand_path(File.dirname(__FILE__) + "/..")
  end

  def self.shutdown!
    @shutdown = true
  end

  def self.shutdown?
    @shutdown
  end

  def self.shutdown_handlers
    @shutdown_handlers ||= [
      Proc.new { Konstant.shutdown! }
    ]
  end

  def self.logger
    @logger ||= begin
      result = Logger.new(STDOUT)
      result.level = Logger::INFO
      result
    end
  end

  def self.logger=(value)
    @logger = value
  end

  def self.measure
    started_at = Time.now
    yield
    Time.now - started_at
  end

end
