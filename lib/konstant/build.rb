class Konstant::Build

  def initialize(project, timestamp)
    @project = project
    @timestamp = timestamp
  end

  attr_reader :project, :timestamp

  def human
    Time.parse(timestamp).strftime("%Y-%m-%d %H:%M:%S")
  end

  def ok?
    status == 0
  end

  def path
    "#{project.path}/builds/#{timestamp}"
  end

  def status
    File.read("#{path}/build.status").strip.to_i
  rescue Errno::ENOENT => e
    nil
  end

  def stdout
    File.read "#{path}/build.stdout"
  rescue Errno::ENOENT => e
    nil
  end

  def stderr
    File.read "#{path}/build.stderr"
  rescue Errno::ENOENT => e
    nil
  end

  def as_json(*)
    return {
      "project_id" => project.id,
      "timestamp" => timestamp,
      "human" => human,
      "stdout" => stdout,
      "stderr" => stderr,
      "status" => status,
      "ok" => ok?
    }
  end

  def to_json(*args)
    as_json.to_json(*args)
  end

end