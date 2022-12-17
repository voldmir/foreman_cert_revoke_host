module ForemanCertRevokeHost
  class Engine < ::Rails::Engine
    engine_name "foreman_cert_revoke_host"

    config.autoload_paths += Dir["#{config.root}/app/controllers/concerns"]
    config.autoload_paths += Dir["#{config.root}/app/helpers"]
    config.autoload_paths += Dir["#{config.root}/app/helpers/concerns"]
    config.autoload_paths += Dir["#{config.root}/app/lib"]

    initializer "foreman_cert_revoke_host.register_gettext",
                :after => :load_config_initializers do
      locale_dir = File.join(File.expand_path("../..", __dir__), "locale")
      locale_domain = "foreman_cert_revoke_host"

      Foreman::Gettext::Support.add_text_domain locale_domain, locale_dir
    end

    initializer "foreman_cert_revoke_host.register_plugin", :before => :finisher_hook do |_app|
      Foreman::Plugin.register :foreman_cert_revoke_host do
        requires_foreman "~> 1.24"

        security_block :foreman_cert_revoke_host do
          permission :cert_revoke_hosts, { :hosts => [:cert_revoke] }, :resource_type => "Host"
        end

        describe_host do
          title_actions_provider :foreman_cert_revoke_host_title_actions
        end
      end
    end

    config.to_prepare do
      begin
        ::HostsHelper.send(:include, ForemanCertRevokeHost::HostsHelperExt)
        ::HostsController.send(:include, ForemanCertRevokeHost::HostsControllerExt)
        ::HostsController.send(:prepend, ForemanCertRevokeHost::HostsControllerExt::DestroyOverrides)
      rescue => e
        Rails.logger.warn "ForemanCertRevokeHost: skipping engine hook (#{e})"
      end
    end
  end
end
