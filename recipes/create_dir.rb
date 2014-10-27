include_recipe "ipl_windows::add_ftp_site"
include_recipe "ipl_windows::add_user"

appcmd = "#{node['iis']['home']}\\appcmd"

# add ACL rights to Users group
directory 'C:\inetpub\ftproot' do
  action :create
  rights :read_execute, "Users", :applies_to_children => false
end

# create Inside/Outside directory and add ACL rights to FTPUsers group
%w{Inside Outside}.each do |dir|
  directory "C:\\inetpub\\ftproot\\#{dir}" do
    action :create
    rights :read_execute, "FTPUsers", :applies_to_children => false
  end
end

users = Chef::EncryptedDataBagItem.load('account_data', 'accounts')['users']

users.each do |usr|

  # create personal directory in FTP root directory
  directory "C:\\inetpub\\ftproot\\Inside\\#{usr['name']}" do

    action [:create]
    rights :modify, usr['name']

  end

  # create personal directory in Users directory
  directory "C:\\inetpub\\Users\\#{usr['name']}" do

    action [:create]
    rights :modify, usr['name']

  end

  # remove Users group ACL from personal directory
  powershell_script 'remove "Users" ACL' do
    code <<-EOS
    cacls C:\\inetpub\\ftproot\\Inside\\#{usr['name']} /e /r Users

    cacls C:\\inetpub\\Users\\#{usr['name']} /e /r Users

    EOS
  end
end

