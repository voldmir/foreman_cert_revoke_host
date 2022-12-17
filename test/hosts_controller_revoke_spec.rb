require "rspec"
Dir[File.dirname(__FILE__) + "/models/*.rb"].each { |file| require file }
require_relative '..\app\controllers\concerns\foreman_cert_revoke_host\hosts_controller_ext'

RSpec.describe HostsController do
  ::HostsController.send(:include, ForemanCertRevokeHost::HostsControllerExt)

  it "cert_revoke method is included with class" do
    hc = HostsController.new({})
    expect(hc.methods.include?(:cert_revoke)).to eq(true)
  end

  it "class is respond to cert_revoke " do
    hc = HostsController.new({})
    expect(hc.respond_to?(:cert_revoke)).to eq(true)
  end

  it "PuppetCA URL not found" do
    hc = HostsController.new({ action: "cert_revoke", id: "host.example.loc", puppet_ca_proxy_id: 5, certname: "host.example.loc" })
    expect(hc.cert_revoke).to eq("{:redirect=>:back, :error_msg=>\"PuppetCA URL not found. for proxy no url\"}")
  end

  it "cert_revoke method get url from class Feature" do
    hc = HostsController.new({ action: "cert_revoke", id: "host.example.loc", puppet_ca_proxy_id: nil, certname: "host.example.loc" })
    expect(hc.cert_revoke).to eq("{:redirect=>:back, :success_msg=>\"Successfully revoke certificate host.example.loc.\"}")
  end

  it "cert_revoke method get url from class SmartProxy" do
    hc = HostsController.new({ action: "cert_revoke", id: "host.example.loc", puppet_ca_proxy_id: 1, certname: "host.example.loc" })
    expect(hc.cert_revoke).to eq("{:redirect=>:back, :success_msg=>\"Successfully revoke certificate host.example.loc.\"}")
  end

  it "cert_revoke empty certname" do
    hc = HostsController.new({ action: "cert_revoke", id: "host.example.loc", puppet_ca_proxy_id: 1, certname: nil })
    expect(hc.cert_revoke).to eq("{:redirect=>:back, :error_msg=>\"Certificate not found for proxy http://foreman.localhost:8000\"}")
  end

  it "host destroy" do
    hc = HostsController.new({ action: "cert_revoke", id: "host.example.loc", puppet_ca_proxy_id: 1, certname: nil })
    expect(hc.destroy).to eq("removed")
  end
end
