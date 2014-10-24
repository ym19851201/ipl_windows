#
# Cookbook Name:: ipl_windows
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
include_recipe "ipl_windows::mod_asp"
include_recipe "ipl_windows::add_site"
include_recipe "ipl_windows::add_user"
include_recipe "ipl_windows::create_dir"
include_recipe "ipl_windows::add_ftp_site"
include_recipe "ipl_windows::mod_ftp_setting"

windows_path "C:\\Windows\\System32\\inetsrv" do
  action :add
end
