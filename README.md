#Absolute

[![Build Status](https://travis-ci.org/KelvinSmithLibrary/absolute.png?branch=master)](https://travis-ci.org/KelvinSmithLibrary/absolute)
[![Coverage Status](https://coveralls.io/repos/KelvinSmithLibrary/absolute/badge.png)](https://coveralls.io/r/KelvinSmithLibrary/absolute)
[![Dependency Status](https://gemnasium.com/KelvinSmithLibrary/absolute.png)](https://gemnasium.com/KelvinSmithLibrary/absolute)
[![Code Climate](https://codeclimate.com/github/KelvinSmithLibrary/absolute/badges/gpa.svg)](https://codeclimate.com/github/KelvinSmithLibrary/absolute)

## Prerequisites
* [ImageMagick](http://www.imagemagick.org/)
* [ffmpeg](http://www.ffmpeg.org/)
* [fits](https://code.google.com/p/fits)
* [ghostscript](http://ghostscript.com)
* [Oracle instant client](http://www.oracle.com/technetwork/database/features/instant-client/index-097480.html)

ImageMagick, ffmpeg, and ghostscript can be installed using

```bash
sudo apt-get -y install imagemagick ffmpeg ghostscript
```

Fits can be installed using the following commands

```bash
sudo mkdir -p /opt/install
sudo wget -P /opt/install http://fits.googlecode.com/files/fits-0.6.2.zip
sudo unzip /opt/install/fits-0.6.2.zip -d /opt/install
sudo chmod +x /opt/install/fits-0.6.2/fits.sh
sudo cp -r /opt/install/fits-0.6.2/* /usr/local/bin/
sudo ln -s /usr/local/bin/fits.sh /usr/local/bin/fits
```

Installing the Oracle instant clicent requites the basic client, the SDK, and sqlplus. Each of these will be downloaded as a zip file and should be unziped to `/opt/oracle/`. Once that is done you should set the `LD_LIBRARY_PATH` and create the required symlinks using:

```bash
LD_LIBRARY_PATH=/opt/oracle/instantclient_12_1
export LD_LIBRARY_PATH
sudo ln -s /opt/oracle/instantclient_12_1/libclntsh.so.12.1 /opt/oracle/instantclient_12_1/libclntsh.so
```

### Installing ImageMagick
**Note:**
If you install ImageMagick using homebrew, and you see an error like this when you run the specs:
"Magick::ImageMagickError: no decode delegate for this image format (something.tif)"

Reinstall with a switch for libtiff:

```bash
brew install imagemagick --with-libtiff
```

### Installing ffmpeg & fits & ghostscript

See the instructions in the [Sufia README]() about [installing fits](https://github.com/projecthydra/sufia#install-fitssh) and [installing ffmpeg](https://github.com/projecthydra/sufia#if-you-want-to-enable-transcoding-of-video-install-ffmpeg-version-10). 
Ghostscript maintains installation instructions [here](http://ghostscript.com/doc/current/Install.htm).

## Installing and Configuring Absolute

### Install dependencies with Bundler

```bash
bundle install
```

### Set up config files
```bash
cp config/database.yml.sample config/database.yml
cp config/initializers/secret_token.rb.sample config/initializers/secret_token.rb
cp config/solr.yml.sample config/solr.yml
cp config/redis.yml.sample config/redis.yml
cp config/fedora.yml.sample config/fedora.yml
cp config/devise.yml.sample config/devise.yml
cp config/handle.yml.sample config/handle.yml
```
!!! Important. Open config/devise.yml and generate a new id
!!! Edit config/initializers/secret_token.rb and config/devise.yml replace the sample keys with your own keys.  You can use rake to generate a new secret key:

```bash
rake secret
```

### Set up database

```bash
rake db:schema:load
rake db:seed
```

### Get a copy of hydra-jetty
```bash
rake jetty:clean
rake jetty:config
rake jetty:start
```

to include the `subject_sort` field that is used to order the facets you need to copy the updated `schema.xml` file into jetty

```bash
cp solr_conf/conf/schema.xml jetty/solr/development-core/conf/schema.xml
cp solr_conf/conf/schema.xml jetty/solr/test-core/conf/schema.xml
```

### Install the handle server

when objects are created the application automatically updates the handle.net identifiers to match the newly created or updated items. The handle server requires java to run. The handle server can be installed with

```bash
wget http://www.handle.net/hs-source/hsj-7.3.1.tar.gz
sudo mkdir -p /hs/svr_1
sudo tar -xzf hsj-7.3.1.tar.gz -C /hs
rm hsj-7.3.1.tar.gz
```

Now that the handle server is installed on the server it has to be configured and started. Use

```bash
/hs/bin/hdl-setup-server /hs/srv_1
```

and enter the requested information about the handle server. Once the server is configured you can use

```bash
/hs/bin/hdl-server /hs/svr_1
```

to start the handle server.

## Development

### Starting the workers

```bash
RAILS_ENV=development QUEUE=* VERBOSE=1 rake resque:work

# or start the workers in the background
RAILS_ENV=development QUEUE=* VERBOSE=1 rake -s resque:work > /dev/null 2>1&

# run the schedule workers
RAILS_ENV=development bundle exec resque-scheduler
```

If the workers do not start after deploying the application they can be started with the command

```bash
cd /opt/absolute/current && bundle exec resque-pool -d -E production -c config/resque-pool.yml -p /opt/absolute/shared/tmp/pids/resque-pool.pid -e /opt/absolute/shared/log/resque-pool.stderr.log -o /opt/absolute/shared/log/resque-pool.stdout.log
```

## Developer notes

### Explaining what partials are being used

If you set an environment variable like this:

```bash
EXPLAIN_PARTIALS=true rails s
```

you'll get helpful comments in the source like this:

```html
<!-- START PARTIAL app/views/shared/_header.html.erb -->
```

### Importing fedora objects from Case Western's existing fedora

Information about importing object is now on [the wiki](https://github.com/curationexperts/absolute/wiki/Migration-Script)

### Exporting the imported URLs to a Handle.net batch file:

```
rake export:handles

Exported 223 records to handles-2014-08-06T11:48:51.txt
```

Then take this file and import them using the handle.net batch tool.

### Setup for automatic handle generation

When a new work is created or new files are added to existing works the application will create a task to update the related handles on the handle server. This requires that the location of the handle server is listed in the `handle.yml` file.

The task will take the PIDs and locations for the created/updated items and create a batch update file that incldes creation of new handles and udpates to existing handles. This will then be run against the handle server to update the saved handles.

## Deploying to the Case vm with Oracle

First, set up an ssh config entry:

```
Host casehydraprod
  Hostname digital.case.edu
  User deploy
  IdentityFile /path/to/my/private/key
  ForwardAgent no
```

Next, connect to casehydradev via ssh to test the config. (If this fails, your public keys are missing or outdated on the digital.case.edu server - let the team know.)

Next, make sure that you are on the master branch with the command 

```
git checkout master
```

Finally, deploy code and update the server with the command

```
bundle exec cap casehydraprod deploy
```

The code is now on the server and the application should be running. If the resque workers are not running you can start them by connecting to the vm over SSH and running the command in the section about [starting the workers](https://github.com/KelvinSmithLibrary/absolute#starting-the-workers).
