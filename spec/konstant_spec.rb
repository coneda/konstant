require 'spec_helper'

describe Konstant do

  it 'has a version number' do
    expect(Konstant::VERSION).not_to be nil
  end

  it "have a basic configuration" do
    expect(described_class.config).not_to be_nil
  end

  it "is configurable" do
    described_class.configure "data_dir" => "/opt/ci", "builds_to_keep" => 25
    expect(described_class.config["data_dir"]).to eq("/opt/ci")
    expect(described_class.config["builds_to_keep"]).to eq(25)
  end
 
  it "should use a default configuration for unspecified values" do
    expect(described_class.config["builds_to_keep"]).to eq(50)
  end

  it "uses an environment" do
    expect(Konstant.env).to eq("test")
  end

end
