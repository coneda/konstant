class Konstant::Builder

  def initialize(project_id)
    @project_id = project_id
    @timestamp = Time.now.strftime("%Y%m%d%H%M%S")
  end

  attr_reader :project_id, :timestamp

  def run
    Konstant.logger.info "building project '#{project_id}'"

    if build
      if previous_build_failed?
        Konstant.logger.info "project '#{project_id}' recovered"
        notify :recovery
      else
        Konstant.logger.info "project '#{project_id}' built successfully"
      end

      Konstant.logger.info "deploying project '#{project_id}'"
      deploy
      Konstant.logger.info "project '#{project_id}' deployed"
    else  
      Konstant.logger.info "project '#{project_id}' failed to build"
      notify :failure
    end

    Konstant.logger.info "cleaning up project '#{project_id}'"
    cleanup
    Konstant.logger.info "project '#{project_id}' cleaned up"

    symlink
    Konstant.logger.info "finished building project '#{project_id}'"
  end

  def build
    Konstant::Runner.new(project_id, timestamp, "build").run
  end

  def deploy
    Konstant::Runner.new(project_id, timestamp, "deploy").run
  end

  def cleanup
    project = Konstant::Project.new(project_id)
    timestamps = project.build_timestamps
    limit = Konstant.config["builds_to_keep"]
    

    if timestamps.size > limit
      Konstant.logger.info "removing #{timestamps.size - limit} build(s) from project '#{project_id}'"
      timestamps[limit..-1].each do |ts|
        system "rm -rf #{project.path}/builds/#{ts}"
      end
    end
  end

  def symlink
    system "ln -sfn #{project_path}/builds/#{@timestamp} #{project_path}/current"
  end

  def notify(message)
    project_id = self.project_id

    unless Konstant.config["notify"].empty?
      Mail.deliver do
        from Konstant.config["mail_sender"]
        to Konstant.config["notify"]

        case message
          when :failure
            subject "Konstant: Project failed: #{project_id}"
          when :recovery
            subject "Konstant: Project recovered: #{project_id}"
        end
      end
    end
  end

  def build_status
    File.read("#{project_path}/current/build.status").strip.to_i
  end

  def build_stdout
    File.read("#{project_path}/current/build.stdout")
  end

  def build_stderr
    File.read("#{project_path}/current/build.stderr")
  end

  def project_path
    "#{Konstant.config['data_dir']}/projects/#{project_id}"
  end

  def previous_build_failed?
    build_status == 0
  rescue Errno::ENOENT => e
    # There is no previous build
    false
  end

end