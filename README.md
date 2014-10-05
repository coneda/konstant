# Konstant

A simple continuous integration server with a web UI, that allows
you to implement a continuous delivery setup.

Konstant is built with ruby and comes as a ruby gem.

## Installation

Just install the gem like this

    $ gem install konstant

This will provide the `konstant` executable.

## Usage

### Setting up the data directory

    $ mkdir ci
    $ cd ci
    $ konstant init

This will create an empty projects folder and a sample konstant.js config
file within `ci`. The config file contains reasonable defaults for you to get
started with.


### Running the server

The konstant server can be instructed to provide the web UI, the actual build
scheduler or both. The server has to be run from within the directory containing
`konstant.js`

    $ cd ci
    $ konstant run -w # provide the web UI (default http://0.0.0.0:9105)
    $ konstant run -s # provide the CI scheduler
    $ konstant run -w -s # provide both

run `konstant --help` for some additional options.


### Adding projects

Adding projects is done by adding subdirectories under the `ci/projects` folder.
Bash scripts within those subdirectories define how a project is to be built,
deployed and cleaned up. A generator is provided to quickly create new projects:

    $ cd ci
    $ konstant generate project my_app

this will create `ci/projects/my_app` including some sample bash scripts. Modify
them according to your build scenario.


### The scripts

A build is a sequence of jobs:

* `build` is always run
* `deploy` is only run if `build` succeeded
* `cleanup` is always run

Those jobs are represented by bash scripts within each project directory. Only
the `build` script is required, the other jobs are simply not executed
if the files are missing.

The scripts are required to have the executable bit set. Apart from that, it is
recommended to have each script start with `#!/bin/bash -e` so that any
failed command within the script will prevent the execution of any remaining 
commands.

When a project is built, the above jobs are executed while status, stdout and
stderr are recorded within the directory for that build. Build directories are
kept under `ci/projects/my_app/builds` and are named according to the timestamp
when the build was requested.


### Triggering builds

Once the CI scheduler is up and running, building can be triggered in three
ways:

* click a button on the web UI
* create the file `ci/projects/my_app/run.txt`
* make an http request to `/projects/my_app/build` (any http verb works)

You might find the last two ways useful to automate builds after git pushes.


### Sample project

For example, to test the
`carrierwave_backgrounder` ruby gem, you could

    $ cd ci/projects/carrierwave_backgrounder
    $ git clone https://github.com/lardawge/carrierwave_backgrounder.git src

And insert the following code into `ci/projects/carrierwave_backgrounder/build`

```bash
#!/bin/bash -e

cd $KONSTANT_PROJECT_ROOT/src
git pull

bundle install --path=$KONSTANT_PROJECT_ROOT/bundle --quiet

bundle exec rspec --format progress
```

Since we don't want to deploy anything after successful builds and there is
nothing to cleanup, you might want to

    $ cd ci/projects/carrierwave_backgrounder/
    $ rm deploy cleanup


## Contributing

1. Fork it ( https://github.com/coneda/konstant/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
