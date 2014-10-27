appcmd = "#{node['iis']['home']}\\appcmd"

powershell_script 'modify ssl settings' do
  not_if do
    `#{appcmd} list site "IPL FTP" /config | grep ssl` =~ /controlChannelPolicy="SslAllow"/
  end
  code <<-EOS
  #{appcmd} set site "IPL FTP" /ftpServer.security.ssl.controlchannelpolicy:SslAllow
  #{appcmd} set site "IPL FTP" /ftpServer.security.ssl.datachannelpolicy:SslAllow
  EOS
end

powershell_script 'modify authentication settings' do
  not_if do
    `#{appcmd} list site "IPL FTP" /config | grep basicAuthentication` =~ /enabled="true"/
  end
  code <<-EOS
  #{appcmd} set site "IPL FTP" /ftpServer.security.authentication.basicAuthentication.enabled:true
  EOS
end

powershell_script 'modify user isolation settings' do
  not_if do
    `#{appcmd} list site "IPL FTP" /config  | grep userIsolation` =~ /mode="StartInUsersDirectory"/
  end
  code <<-EOS
  #{appcmd} set site "IPL FTP" /ftpServer.userIsolation.mode:StartInUsersDirectory
  EOS
end

powershell_script 'modify authorization rule settings' do
  not_if do
    `#{appcmd} list config -section:system.ftpServer/security/authorization` =~ /accessType="Allow" users="\*" permissions="Read, Write"/
end
  code <<-EOS
  #{appcmd} set config -section:system.ftpServer/security/authorization /+"[accessType='Allow',users='*',permissions='Read, Write']"
  EOS
end
