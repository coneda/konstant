class Konstant::Scheduler

  def run
    @threads = {}

    until Konstant.shutdown? do
      Dir["#{Konstant.config['data_dir']}/projects/*"].each do |path|
        project_id = path.split("/").last

        @threads[project_id] ||= Thread.new do
          until Konstant.shutdown? do
            puts "started worker for project '#{project_id}'"
            if File.exists?("#{path}/run.txt")
              puts "building project '#{project_id}'"
              system "rm #{path}/run.txt"

              begin
                Konstant::Build.new(project_id).run
              rescue => e
                puts e.message
                puts e.backtrace
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