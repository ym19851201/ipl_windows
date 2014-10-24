include_recipe "ipl_iis"
include_recipe "ipl_iis::mod_isapi"

features = %w{IIS-ASP}

features.each do |feature|
  windows_feature feature do
    action :install
  end
end
