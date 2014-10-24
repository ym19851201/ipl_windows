# add "inside" members
# node["web_server"]["members"].each do |k, v|
# data_bag_item('account_data', 'accounts')['users'].each do |usr|
Chef::EncryptedDataBagItem.load('account_data', 'accounts')['users'].each do |usr|
 
#   user k.to_s do
  user usr['name'] do
    action [:create, :manage]
#     password v
    password usr['password']

  end
end

# add FTPUsers group
group "FTPUsers" do
  action [:create, :manage]
#   members node["web_server"]["members"].keys
  users = Chef::EncryptedDataBagItem.load('account_data', 'accounts')['users']
  members users.map { |e| e['name'] }

end
