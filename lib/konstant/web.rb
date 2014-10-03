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
    if request.path.match(/^\/projects$/)
      [200, {"Content-type" => "application/json"}, [Konstant::Project.all.to_json]]
    elsif m = request.path.match(/^\/projects\/([^\/]+)\/builds\/(\d+)$/)
      project = Konstant::Project.new m[1]
      build = Konstant::Build.new project, m[2]
      [200, {"Content-type" => "application/json"}, [build.to_json]]
    elsif request.path.match(/^\/config$/)
      [200, {"Content-type" => "application/json"}, [Konstant.config.to_json]]
    elsif m = request.path.match(/^\/projects\/([^\/]+)\/builds$/)
      project = Konstant::Project.new m[1]
      [200, {"Content-type" => "application/json"}, [project.builds.to_json]]
    elsif m = request.path.match(/^\/projects\/([^\/]+)\/build$/)
      project = Konstant::Project.new m[1]
      project.build!
      message = {"message" => "ok"}
      [200, {"Content-type" => "application/json"}, [message.to_json]]
    else
      [404, {"Content-type" => "text/plain"}, ["not found"]]
    end
  end

end