module H
  def method_missing(sym, *)
    r = fetch(sym) { fetch(sym.to_s) { super } }
    Hash === r ? r.extend(H) : r
  end
end

module ActiveSupport
  module Concern
  end
end

module ProxyAPI
  class ProxyException < ::StandardError
    attr_accessor :url

    def initialize(url, exception, message, *params)
      super(message, *params)
      @url = url
    end

    def message
      super + " " + "for proxy" + " " + url
    end
  end

  class Puppetca
    def initialize(args)
    end

    def del_certificate(certname)
    end
  end
end

class Hosts
  attr_accessor :id, :puppet_ca_proxy_id, :certname

  def initialize(params)
    @id = params[:id]
    @puppet_ca_proxy_id = params[:puppet_ca_proxy_id]
    @certname = params[:certname]
  end

  def to_s
    @id.to_s
  end
end

class HostsController
  attr_reader :params

  def initialize(params = {})
    @params = params
  end

  private

  def find_resource
    @host = Hosts.new(params)
  end

  def process_success(*args)
    args.first.inspect
  end

  def process_error(*args)
    args.first.inspect
  end

  def _(str)
    str
  end
end

class SmartProxy
  def self.where(args = {})
    @proxys = [
      { :id => 1, :feature_id => 1, :url => "http://foreman.localhost:8000" },
      { :id => 2, :feature_id => 2, :url => "http://sp01.localhost:8000" },
      { :id => 3, :feature_id => 3, :url => "http://sp02.localhost:8000" },
    ].select { |proxy| (proxy[:id] == args[:id]) || (proxy[:feature_id] == args[:feature_id]) }.map { |h| h.extend(H) }
    #  pp @proxys
    @proxys
    self
  end

  def self.pluck(args = {})
    p = @proxys.map { |proxy| proxy.values_at(args) }.flatten
  end

  def self.all()
    @proxys
  end
end

class Feature
  #attr_reader :smart_proxies

  def initialize(smart_proxies)
    @smart_proxies = smart_proxies
  end

  def smart_proxies
    @smart_proxies
  end

  def self.where(args = {})
    w = [
      { :id => 1, :name => "Puppet CA" },
      { :id => 2, :name => "Puppet" },
      { :id => 3, :name => "Logs" },
    ].select { |proxy| (proxy[:id] == args[:id]) || (proxy[:name] == args[:name]) }
    w.map { |row| self.new(SmartProxy.where(:feature_id => row[:id]).all) }
  end
end
