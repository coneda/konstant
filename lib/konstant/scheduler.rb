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
        thread = @threads.delete project_id
        thread.kill
        Konstant.logger.info "stopped worker for project '#{project_id}'"
      end

      sleep Konstant.config['new_projects_interval']
    end
  end

  def project_worker(project_id)
    Thread.new do
      project = Konstant::Project.new(project_id)
      Konstant.logger.info "started worker for project '#{project.id}'"

      until Konstant.shutdown? do
        Konstant.logger.debug "polling project '#{project.id}'"
        if File.exists?("#{project.path}/run.txt")
          system "rm #{project.path}/run.txt"

          begin
            system "touch #{project.path}/running.txt"
            Konstant::Builder.new(project).run
          rescue => e
            puts e.message
            puts e.backtrace
          ensure
            system "rm #{project.path}/running.txt"
          end
        else
          sleep Konstant.config["build_check_interval"]
        end
      end
    end
  end

end