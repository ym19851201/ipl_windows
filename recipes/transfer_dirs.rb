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
    overwrite false
  end
end
