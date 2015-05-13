# This file is used by Rack-based servers to start the application.

Foreigner::Adapter.register 'oracle_enhanced', Gem.loaded_specs['activerecord-oracle_enhanced-adapter'].full_gem_path

require ::File.expand_path('../config/environment',  __FILE__)
run Rails.application
