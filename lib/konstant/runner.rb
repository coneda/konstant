class Konstant::Runner

  def initialize(build, task)
    @build = build
    @task = task
  end

  attr_reader :build, :task

  def run
    if task == "build" || File.exists?("#{build.project.path}/#{task}")
      duration = Konstant.measure do
        build.create
        File.open status_file, "w" do |f|
          Bundler.with_clean_env do
            system environment, "#{build.project.path}/#{task} > #{stdout_file} 2> #{stderr_file}"
            f.puts $?.exitstatus
          end
        end
      end
      File.open "#{build.path}/#{task}.duration", "w" do |f|
        f.puts duration
      end

      build.status(task) == 0
    else
      false
    end
  end

  def environment
    return {
      "KONSTANT_PROJECT_ROOT" => File.expand_path(build.project.path),
      "KONSTANT_TIMESTAMP" => build.timestamp
    }
  end

  def stdout_file
    "#{build.path}/#{task}.stdout"
  end

  def stderr_file
    "#{build.path}/#{task}.stderr"
  end

  def status_file
    "#{build.path}/#{task}.status"
  end

end