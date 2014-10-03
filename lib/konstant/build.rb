class Konstant::Build

  def initialize(project_id)
    @project_id = project_id
    @timestamp = Time.now.strftime("%Y%m%d%H%M%S")
  end

  attr_reader :project_id, :timestamp

  def run
    if build
      if previous_build_failed?
        notify :recovery
      end

      deploy
    else
      notify :failure
    end

    cleanup

    symlink
  end

  def build
    Konstant::Runner.new(project_id, timestamp, "build").run
  end

  def deploy
    Konstant::Runner.new(project_id, timestamp, "deploy").run
  end

  def cleanup
    Konstant::Runner.new(project_id, timestamp, "cleanup").run
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


  protected

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