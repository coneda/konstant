class Konstant::Project

  def initialize(id)
    @id = id
  end

  attr_reader :id

  def self.all
    Dir["#{Konstant.config['data_dir']}/projects/*"].map do |path|
      new path.split('/').last
    end
  end

  def build!
    system "touch #{path}/run.txt"
  end

  def building?
    File.exists? "#{path}/running.txt"
  end

  def path
    "#{Konstant.config['data_dir']}/projects/#{id}"
  end

  def build_timestamps
    Dir["#{path}/builds/*"].map do |path|
      path.split('/').last
    end.sort.reverse
  end

  def builds
    build_timestamps.map do |ts|
      Konstant::Build.new self, ts
    end
  end

  def last_build
    if ts = build_timestamps.first
      Konstant::Build.new self, ts
    end
  end

  def ok?(task = 'build')
    last_build && last_build.ok?(task)
  end

  def status(task = 'build')
    last_build ? last_build.status(task) : nil
  end

  def stdout(task = 'build')
    last_build ? last_build.stdout(task) : nil
  end

  def stderr(task = 'build')
    last_build ? last_build.stderr(task) : nil
  end

  def as_json(*)
    return {
      "id" => id,
      "ok" => ok?,
      "deploy_ok" => ok?('deploy'),
      "cleanup_ok" => ok?('cleanup'),
      "building" => building?
    }
  end

  def to_json(*args)
    as_json.to_json(*args)
  end
  
end