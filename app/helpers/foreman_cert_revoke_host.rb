def foreman_cert_revoke_host_title_actions(host)
  [
    {
      :action => button_group(
        display_link_if_authorized(_("Revoke Certificate"),
                                                 hash_for_cert_revoke_host_path(:id => host).merge(:auth_object => host, :authorizer => authorizer, :permission => 'cert_revoke_hosts'),
                                                 { :data => { :confirm => cert_revoke_host_dialog(host)} , :method => :post, :class => 'btn btn-default' }),
      ),
      :priority => 100
    },

  ]
end
