require "spec_helper"

describe Konstant::Runner do

  it "should pass the project root in an environment variable", :fixture_projects => true do
    project = Konstant::Project.new "test_project_02"
    build = Konstant::Build.new project, Time.now.strftime("%Y%m%d%H%M%S")
    runner = described_class.new build, :build
    runner.run

    expect(build.stdout.strip).to eq("#{Konstant.config['data_dir']}/projects/test_project_02")
  end

end