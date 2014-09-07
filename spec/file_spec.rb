require "spec_helper"

describe File do

  it "should exclusively lock a file" do
    filename = "#{Konstant.root}/tmp/test_file"
    system "touch #{filename}"
    file = File.open(filename)
    file.flock File::LOCK_EX
    acquired_outer = Time.now

    thread = Thread.new do
      tfile = File.open(filename)
      tfile.flock File::LOCK_EX
      Time.now
    end

    sleep 0.1
    file.close

    acquired_thread = thread.value

    expect(acquired_outer).to be_within(0.001).of(acquired_thread - 0.1)

    system "rm #{filename}"
  end

end