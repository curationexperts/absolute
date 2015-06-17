require 'json'
require 'net/http'

class CreateHandleJob
  @queue = :handle

  def self.perform(pids)
    create_file(pids)
    #update_handle
  end

  def create_file(pids)
    File.open("/tmp/#{filename}", 'w') do |f|
      f.print authenticate
      pids.each do |pid|
        if pid_exists?(pid)
          f.print command("CREATE")
        else
          f.print command("UPDATE")
        end
      end
    end
  end

  def command(verb, link)
    command = "#{verb} #{namespace}/#{pid}\n"
    command += "2 URL 86400 1110 UTF8 #{link}\n\n"
  end

  def update_handle
    %x{#{params['root_path']}/bin/hdl-genericbatch /tmp/#{filename} #{File.join(Rails.root, 'log', 'handles', "handle-#{Time.now.to_formatted_s(:iso8601).first(19)}.log")}}
    %x{rm #{@filename}}
  end

  def authenticate
    auth = "AUTHENTICATE PUBKEY:300:0.NA/#{namespace}\n"
    auth += "#{params['root_path']}#{params['server']}/admpriv.bin | #{params['password']}\n\n"
  end

  # make sure that the response code from the handle server is 1
  def pid_exists?(pid)
    data = JSON.parse(Net::HTTP.get(URI.parse("http://hdl.handle.net/#{namepsace}/#{pid}")))
    data['responseCode'] == 1
  end

private

  def filename
    @filename ||= "handles-#{Time.now.to_formatted_s(:iso8601).first(19)}.txt"
  end

  def namespace
    @namespace unless @namespace.nil?
    @namespace = params['namespace']
  end

  def domain
    @domain unless @domain.nil?
    @domain = params['domain']
  end

  def params
    @params ||= YAML::load(ERB.new(IO.read(File.join(Rails.root, 'config', 'handle.yml'))).result)['handle']
  end

end
