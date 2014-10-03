class Konstant::Scheduler

  def run
    @threads = {}

    until Konstant.shutdown? do
      project_paths = Dir["#{Konstant.config['data_dir']}/projects/*"]
      project_ids = project_paths.map{|path| path.split('/').last}

      (project_ids - @threads.keys).each do |project_id|
        @threads[project_id] = project_worker(project_id)
      end

      (@threads.keys - project_ids).each do |project_id|
        thread = @thread.delete project_id
        thread.kill
      end

      sleep 5
    end
  end

  def project_worker(project_id)
    Thread.new do
      path = "#{Konstant.config['data_dir']}/#{project_id}"
      Konstant.logger.info "started worker for project '#{project_id}'"

      until Konstant.shutdown? do
        Konstant.logger.debug "polling project '#{project_id}'"
        if File.exists?("#{path}/run.txt")
          Konstant.logger.info "building project '#{project_id}'"
          system "rm #{path}/run.txt"

          begin
            system "touch #{path}/running.txt"
            Konstant::Build.new(project_id).run
          rescue => e
            puts e.message
            puts e.backtrace
          ensure
            system "rm #{path}/running.txt"
          end
        else
          sleep 1
        end
      end
    end
  end

  def self.run(build)

  end

end