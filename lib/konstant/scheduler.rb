class Konstant::Scheduler

  def run
    @threads = {}

    until Konstant.shutdown? do
      Dir["#{Konstant.config['data_dir']}/projects/*"].each do |path|
        project_id = path.split("/").last

        @threads[project_id] ||= Thread.new do
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

      sleep 5
    end
  end

  def self.run(build)

  end

end