module ForemanCertRevokeHost::HostsControllerExt
  extend ActiveSupport::Concern
  
    def cert_revoke
      find_resource
      
      url = @host.puppet_ca_proxy_id.nil? ? 
    		Feature.where(:name => 'Puppet CA').map { |feature| feature.smart_proxies.map { |p| p.url } }.flatten.first :
    		SmartProxy.where(:id => @host.puppet_ca_proxy_id).pluck(:url).first
      
      return process_error(:error_msg => _("PuppetCA URL not found.")) unless url

      begin
        puppetca = ProxyAPI::Puppetca.new(:url => url)
        raise ProxyAPI::ProxyException.new(url, RuntimeError.new, _("Certificate not found")) if @host.certname.nil?
        puppetca.del_certificate @host.certname
      rescue ProxyAPI::ProxyException => e
        return process_error :redirect => :back, :error_msg => e.inspect
      end

      process_success :redirect => :back, :success_msg => _("Successfully revoke certificate %s.") % @host
    end
    
    private

    def action_permission
      case params[:action]
      when 'cert_revoke'
        :cert_revoke
      else
        super
      end
    end
    
end
