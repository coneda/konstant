class Konstant::Build

  def initialize(project_name)
    @project_name = project_name
    @timestamp = Time.now.strftime("%Y%m%d%H%M%S")
  end

  attr_reader :project_name, :timestamp

  def run
    if build.run
      deploy.run
    end

    cleanup.run
  end

  def build
    @build ||= Konstant::Runner.new(project_name, timestamp, "build")
  end

  def deploy
    @deploy ||= Konstant::Runner.new(project_name, timestamp, "deploy")
  end

  def cleanup
    @cleanup ||= Konstant::Runner.new(project_name, timestamp, "cleanup")
  end

end