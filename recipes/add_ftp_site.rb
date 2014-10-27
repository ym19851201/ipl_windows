appcmd = "#{node['iis']['home']}\\appcmd"

powershell_script 'add FTP site' do
  not_if do
    `#{appcmd} list site` =~ /IPL FTP/
  end
  code <<-EOS
  #{appcmd} add site /name:"IPL FTP" /bindings:"ftp://*:21" /physicalPath:"C:\\inetpub\\ftproot\\Inside"
  EOS
end

powershell_script 'add vdir to FTP site' do
  not_if do
    `#{appcmd} list site "IPL FTP" /config` =~ /physicalPath="C:\\inetpub\\Users"/
  end
  code <<-EOS
  #{appcmd} add vdir /app.name:"IPL FTP/" /path:/users /physicalPath:C:\\inetpub\\Users
  EOS
end

%w{Bbs bbs_dev keiba Web ftproot\\Outside}.each do |dir|
  powershell_script 'add vdir to FTP site' do
    not_if do
      `#{appcmd} list site "IPL FTP" /config`.include "physicalPath=\"C:\\inetpub\\#{dir}\""
    end
    if dir =~ /Outside/
      dir_name = "outside"
    else
      dir_name = dir.downcase
    end
    code <<-EOS
    #{appcmd} add vdir /app.name:"IPL FTP/" /path:/#{dir_name} /physicalPath:C:\\inetpub\\#{dir}
    EOS
  end
end

