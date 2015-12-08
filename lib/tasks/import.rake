namespace :import do
  require 'import/object_importer'

  desc 'Import records from another fedora'
  task :pids, [:fedora_env] => :environment  do |t, args|
    importer = ObjectImporter.new(args.fedora_env, args.extras, true)
    importer.import!
  end

  desc 'Validate records from another fedora'
  task :validate, [:fedora_env] => :environment  do |t, args|
    importer = ObjectImporter.new(args.fedora_env, args.extras, true)
    importer.validate
  end

end
