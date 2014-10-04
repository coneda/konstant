class Konstant::Builder

  def initialize(project)
    @project = project
    @timestamp = Time.now.strftime("%Y%m%d%H%M%S")
    @new_build = Konstant::Build.new project, timestamp
  end

  attr_reader :project, :timestamp, :new_build

  def run
    Konstant.logger.info "building project '#{project.id}'"
    puts "asdf"

    if build
      if previous_build_failed?
        Konstant.logger.info "project '#{project.id}' recovered"
        notify :recovery
      else
        Konstant.logger.info "project '#{project.id}' built successfully"
      end

      Konstant.logger.info "deploying project '#{project.id}'"
      unless deploy
        notify :deploy_failed
      end
      Konstant.logger.info "project '#{project.id}' deployed"
    else  
      Konstant.logger.info "project '#{project.id}' failed to build"
      notify :failure
    end

    Konstant.logger.info "cleaning up project '#{project.id}'"
    unless cleanup
      notify :cleanup_failed
    end
    Konstant.logger.info "project '#{project.id}' cleaned up"

    symlink
    Konstant.logger.info "finished building project '#{project.id}'"

    cleanup_old_builds
  end

  def build
    Konstant::Runner.new(new_build, "build").run
  end

  def deploy
    Konstant::Runner.new(new_build, "deploy").run
  end

  def cleanup
    Konstant::Runner.new(new_build, "cleanup").run
  end

  def cleanup_old_builds
    builds = project.builds
    limit = Konstant.config["builds_to_keep"]

    if builds.size > limit
      Konstant.logger.info "removing #{builds.size - limit} build(s) from project '#{project.id}'"
      builds[limit..-1].each do |build|
        build.destroy
      end
    end
  end

  def symlink
    system "ln -sfn #{new_build.path} #{project.path}/current"
  end

  def notify(message)
    unless Konstant.config["notify"].empty?
      Mail.deliver do
        from Konstant.config["mail_sender"]
        to Konstant.config["notify"]

        case message
          when :failure
            subject "Konstant: Project failed: #{project.id}"
          when :recovery
            subject "Konstant: Project recovered: #{project.id}"
          when :cleanup_failed
            subject "Konstant: Project could not be cleaned up: #{project.id}"
          when :deploy_failed
            subject "Konstant: Project could not be deployed: #{project.id}"
        end
      end
    end
  end

  def build_status
    new_build.status
  end

  def build_stdout
    new_build.stdout
  end

  def build_stderr
    new_build.stderr
  end

  def previous_build_failed?
    new_build.previous ? new_build.previous.failure? : false
  end

end