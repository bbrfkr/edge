require 'serverspec'
require 'docker'
require 'inifile'
require 'active_support'
require 'active_support/core_ext'

default = IniFile.load("Projects/#{ ENV['TEST_PROJECT'] }/properties/default.ini").to_h
test_case = IniFile.load(ENV['TEST_CASE_FILE']).to_h
test_case = default.deep_merge!(test_case)

set :backend, :docker
set :docker_url, ENV["DOCKER_HOST"]
set :docker_image, ENV['TEST_IMAGE']
if test_case != false
  set_property test_case
else
  set_property ({}) 
end

if ENV['DOCKER_TLS_VERIFY'] != 0
  if ENV["DOCKER_CERT_PATH"] != nil
    Docker.options = {
        client_cert: File.join(ENV["DOCKER_CERT_PATH"], 'cert.pem'),
        client_key: File.join(ENV["DOCKER_CERT_PATH"], 'key.pem'),
        ssl_ca_file: File.join(ENV["DOCKER_CERT_PATH"], 'ca.pem'),
        scheme: 'https'
    }
  else
    Docker.options = {
        client_cert: File.join(ENV["HOME"], '.docker/cert.pem'),
        client_key: File.join(ENV["HOME"], '.docker/key.pem'),
        ssl_ca_file: File.join(ENV["HOME"], '.docker/ca.pem'),
        scheme: 'https'
    }
  end
end

