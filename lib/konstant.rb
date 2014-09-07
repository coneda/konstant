require "konstant/version"

require "json"

module Konstant

  autoload :Build, "konstant/build"
  autoload :Cli, "konstant/cli"
  autoload :Scheduler, "konstant/scheduler"
  autoload :Runner, "konstant/runner"
  autoload :Web, "konstant/web"

  def self.config
    @config ||= default_config
  end

  def self.default_config
    return {
      "data_dir" => "/var/lib/konstant",
      "builds_to_keep" => 50
    }
  end

  def self.configure(new_config)
    config.merge! new_config
  end

  def self.reset_config
    @config = default_config
  end

  def self.reset_data_dir
    system "rm -rf #{config['data_dir']}"
  end

  def self.env
    ENV["RUBY_ENV"] || "development"
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

  def self.measure
    started_at = Time.now
    yield
    Time.now - started_at
  end

end
