require "mixlib/cli"

class Konstant::Cli

  include Mixlib::CLI

  option(:config_file,
    :short => "-c FILE",
    :long => "--config-file FILE",
    :default => "konstant.js"
  )

  option(:web,
    :short => "-w",
    :long => "--web",
    :default => false
  )

  option(:scheduler,
    :short => "-s",
    :long => "--scheduler",
    :default => false
  )

  option(:host,
    :short => "-h HOST",
    :long => "--host HOST",
    :default => "0.0.0.0"
  )

  option(:port,
    :short => "-p PORT",
    :long => "--port PORT",
    :default => "9105"
  )

end