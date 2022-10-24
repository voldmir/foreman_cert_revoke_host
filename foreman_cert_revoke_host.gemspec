$LOAD_PATH.push File.expand_path('lib', __dir__)

require_relative 'lib/foreman_cert_revoke_host/version'

Gem::Specification.new do |s|
  s.name          = "foreman_cert_revoke_host"
  s.version       = ForemanCertRevokeHost::VERSION
  s.authors       = ["Vladimir Savchenko"]
  s.email         = ["voldmir@mail.ru"]

  s.description = 'Plugin to revoke certificate from host properties'
  s.extra_rdoc_files = ['README.md']
  s.files = Dir['{app,lib,config,locale}/**/*'] + ['README.md']
  s.homepage      = "https://github.com/voldmir/foreman_cert_revoke_host"
  s.license = 'GPL-3.0'
  s.summary = 'Plugin to revoke certificate from host properties'
  s.test_files = Dir['test/**/*']
  s.add_runtime_dependency "foreman", "~> 1.24"
  
end

