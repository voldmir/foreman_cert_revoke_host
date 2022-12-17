class Feature
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
