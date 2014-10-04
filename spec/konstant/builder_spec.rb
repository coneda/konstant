require "spec_helper"

describe Konstant::Builder do

  it "should handle a missing build script" do
    project = Konstant::Project.new("noexist")
    runner = described_class.new project
    runner.run
    expect(project.status).to eq(127)
  end

  it "should store the build's output and error output", :fixture_projects => true do
    runner = described_class.new Konstant::Project.new("test_project_01")
    runner.run

    expect(runner.build_stdout).to eq("some output\n")
    expect(runner.build_stderr).to eq("some warning\n")
    expect(runner.build_status).to eq(0)
  end

end