class Konstant::Build

  def initialize(project_name)
    @project_name = project_name
    @timestamp = Time.now.strftime("%Y%m%d%H%M%S")
  end

  attr_reader :project_name, :timestamp

  def run
    if build.run
      deploy.run
    else
      notify
    end

    cleanup.run

    symlink
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

  def symlink
    system "ln -sfn #{project_dir}/builds/#{@timestamp} #{project_dir}/current"
  end

  def notify
    
  end


  protected

    def project_dir
      "#{Konstant.config['data_dir']}/projects/#{@project_name}"
    end

end