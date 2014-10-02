require "rack"

class Konstant::Web

  def self.call(env)
    new(env).route
  end

  def initialize(env)
    @env = env
  end

  def request
    @request ||= Rack::Request.new(@env)
  end

  def route
    if request.path.match(/\//)
      [200, {"Content-type" => "application/json"}, ['{"a": 12}']]
    else
      [404, {"Content-type" => "text/plain"}, ["not found"]]
    end
  end

end