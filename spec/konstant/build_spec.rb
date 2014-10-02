require "spec_helper"

describe Konstant::Build do

  it "should handle a missing build script" do
    runner = described_class.new("noexist")
    runner.run
    expect(runner.build.status).to eq(127)
  end

  it "should store the build's output and error output", :fixture_projects => true do
    runner = described_class.new("test_project_01")
    runner.run

    expect(runner.build.stdout).to eq("some output\n")
    expect(runner.build.stderr).to eq("some warning\n")
    expect(runner.build.status).to eq(0)
  end

end