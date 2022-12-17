module ForemanCertRevokeHost
  module HostsControllerExt
    extend ActiveSupport::Concern

    included do
      alias_method :find_resource_for_revoke, :find_resource
      before_action :find_resource_for_revoke, only: [:cert_revoke]
    end

    def cert_revoke
      if (result = revoke)[:status]
        process_success :redirect => :back, :success_msg => result[:msg]
      else
        process_error :redirect => :back, :error_msg => result[:msg]
      end
    end

    module DestroyOverrides
      def destroy
        super
        revoke
      end
    end

    private

    def revoke
      begin
        url = @host.puppet_ca_proxy_id.nil? ?
          Feature.where(:name => "Puppet CA").map { |feature| feature.smart_proxies.map { |p| p.url } }.flatten.first :
          SmartProxy.where(:id => @host.puppet_ca_proxy_id).pluck(:url).first

        raise ProxyAPI::ProxyException.new("no url", RuntimeError.new, _("PuppetCA URL not found.")) unless url

        puppetca = ProxyAPI::Puppetca.new(:url => url)
        raise ProxyAPI::ProxyException.new(url, RuntimeError.new, _("Certificate not found")) if @host.certname.nil?
        puppetca.del_certificate @host.certname
      rescue ProxyAPI::ProxyException => e
        return { :status => false, :msg => e.message }
      end
      return { :status => true, :msg => _("Successfully revoke certificate %s.") % @host }
    end

    def action_permission
      case params[:action]
      when "cert_revoke"
        :cert_revoke
      else
        super
      end
    end
  end
end
