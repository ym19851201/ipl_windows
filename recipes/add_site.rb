appcmd = "#{node['ipl_iis']['home']}\\appcmd"

# Transfer directories to guest machine
%w{Bbs UserAdd Users Web bbs_dev keiba}.each do |dir|
  remote_directory "C:\\inetpub\\#{dir}" do
    source dir
    rights :read_execute, "IIS_IUSRS"
  end
end

# Transfer DB directory to guest machine
%w{mdb_data}.each do |dir|
  remote_directory "C:\\inetpub\\#{dir}" do
    source dir
    rights :full_control, "IIS_IUSRS"
    rights :full_control, "Users"
  end
end

%w{Web keiba}.each_with_index do |name, i|
  ipl_iis_site "C:\\inetpub\\#{name}" do
    action [:add, :start, :config, :restart]
    site_name name.upcase
    path "C:\\inetpub\\#{name}"
    # tmp
    port ('80' * (i + 1)).to_i
#     notifies :restart "ipl_iis_site[#{name}]"
  end
end

%w{Bbs UserAdd bbs_dev}.each do |name|
  ipl_iis_app name do
    if name == "UserAdd"
      url = "/#{name}"
    else
      url = "/web#{name.downcase}"
    end

    not_if do
      `#{appcmd} list app` =~ /"WEB#{url}"/
    end

    action :add
    app_name "WEB"
    path url
    physical_path "C:\\inetpub\\#{name}"
  end
end

powershell_script "add index.asp as defaultDocument" do
  not_if do
    `#{appcmd} list config /section:defaultDocument` =~ /index\.asp/
  end
  code "#{appcmd} set config \/section:defaultDocument \"\/+files.[value='index.asp']\""
end
