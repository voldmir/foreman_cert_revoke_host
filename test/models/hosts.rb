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
