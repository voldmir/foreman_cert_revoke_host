class SmartProxy
  def self.where(args = {})
    @@proxys = [
      { :id => 1, :feature_id => 1, :url => "http://foreman.localhost:8000" },
      { :id => 2, :feature_id => 2, :url => "http://sp01.localhost:8000" },
      { :id => 3, :feature_id => 3, :url => "http://sp02.localhost:8000" },
    ].select { |proxy| (proxy[:id] == args[:id]) || (proxy[:feature_id] == args[:feature_id]) }.map { |h| h.extend(H) }
    #  pp @proxys
    @proxys
    self
  end

  def self.pluck(args = {})
    p = @@proxys.map { |proxy| proxy.values_at(args) }.flatten
  end

  def self.all()
    @@proxys
  end
end
