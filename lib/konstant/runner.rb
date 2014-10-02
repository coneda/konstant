class Konstant::Runner

  def initialize(project_name, timestamp, task)
    @project_name = project_name
    @timestamp = timestamp
    @task = task
  end

  attr_reader :project_name, :timestamp, :task

  def run
    duration = Konstant.measure do
      system "mkdir -p #{build_dir}"
      File.open status_file, "w" do |f|
        system environment, "#{project_dir}/#{task} > #{stdout_file} 2> #{stderr_file}"
        f.puts $?.exitstatus
      end
    end

    File.open "#{build_dir}/#{task}.duration", "w" do |f|
      f.puts duration
    end

    status == 0
  end

  def environment
    return {
      "KONSTANT_PROJECT_ROOT" => project_dir,
      "KONSTANT_TIMESTAMP" => @timestamp
    }
  end

  def build_dir
    "#{project_dir}/builds/#{timestamp}"
  end

  def project_dir
    "#{Konstant.config['data_dir']}/projects/#{project_name}"
  end

  def stdout_file
    "#{build_dir}/#{task}.stdout.log"
  end

  def stderr_file
    "#{build_dir}/#{task}.stderr.log"
  end

  def status_file
    "#{build_dir}/#{task}.status"
  end

  def status
    File.read(status_file).to_i if File.exists? status_file
  end

  def stdout
    File.read(stdout_file) if File.exists? stdout_file
  end

  def stderr
    File.read(stderr_file) if File.exists? stderr_file
  end

end