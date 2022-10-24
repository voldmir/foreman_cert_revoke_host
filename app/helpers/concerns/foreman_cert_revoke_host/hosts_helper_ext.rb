module ForemanCertRevokeHost::HostsHelperExt
    extend ActiveSupport::Concern
    
    def cert_revoke_host_dialog(host)
      _("Are you sure you want to revoke certificate host %s? This action is irreversible.") % host.name
    end
    
end