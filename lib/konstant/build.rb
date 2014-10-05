class Konstant::Build

  def initialize(project, timestamp)
    @project = project
    @timestamp = timestamp
  end

  attr_reader :project, :timestamp

  def create
    system "mkdir -p #{path}"
  end

  def destroy
    system "rm -rf #{path}"
  end

  def human
    Time.parse(timestamp).strftime("%Y-%m-%d %H:%M:%S")
  end

  def ok?(task = 'build')
    status(task) == nil ? nil : (status(task) == 0)
  end

  def failure?
    !ok?
  end

  def path
    "#{project.path}/builds/#{timestamp}"
  end

  def status(task = 'build')
    File.read("#{path}/#{task}.status").strip.to_i
  rescue Errno::ENOENT => e
    nil
  end

  def stdout(task = 'build')
    File.read "#{path}/#{task}.stdout"
  rescue Errno::ENOENT => e
    nil
  end

  def stderr(task = 'build')
    File.read "#{path}/#{task}.stderr"
  rescue Errno::ENOENT => e
    nil
  end

  def previous
    timestamps = project.build_timestamps
    index = timestamps.index(timestamp)
    if index <= timestamps.size - 1
      project.builds[index + 1]
    end
  end

  def as_json(*)
    return {
      "project_id" => project.id,
      "timestamp" => timestamp,
      "human" => human,
      "stdout" => stdout,
      "stderr" => stderr,
      "status" => status,
      "ok" => ok?,
      "deploy" => {
        "stdout" => stdout('deploy'),
        "stderr" => stderr('deploy'),
        "status" => status('deploy')
      },
      "cleanup" => {
        "stdout" => stdout('cleanup'),
        "stderr" => stderr('cleanup'),
        "status" => status('cleanup')
      }
    }
  end

  def to_json(*args)
    as_json.to_json(*args)
  end

end