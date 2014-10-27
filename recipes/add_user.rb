include_recipe "ipl_windows::add_ftp_site"

# add "inside" members
Chef::EncryptedDataBagItem.load('account_data', 'accounts')['users'].each do |usr|
 
  user usr['name'] do
    action [:create, :manage]
    password usr['password']

  end
end

# add FTPUsers group
group "FTPUsers" do
  action [:create, :manage]
  users = Chef::EncryptedDataBagItem.load('account_data', 'accounts')['users']
  members users.map { |e| e['name'] }

end
