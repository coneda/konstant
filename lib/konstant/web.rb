class Konstant::Web

  def self.call(env)
    new(env).route
  end

  def initialize(env)
    @env = env
  end

  def route
    [200, {"Content-type" => "text/plain"}, ["hello world"]]
  end

end