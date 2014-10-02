require "spec_helper"

describe Konstant::Runner do

  it "should pass the project root in an environment variable", :fixture_projects => true do
    runner = described_class.new "test_project_02", Time.now.strftime("%Y%m%d%H%M%S"), :build
    runner.run
    expect(File.read(runner.stdout_file).strip).to eq("#{Konstant.config['data_dir']}/projects/test_project_02")
  end

end