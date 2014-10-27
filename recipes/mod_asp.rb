include_recipe "iis"
include_recipe "iis::mod_isapi"

features = %w{IIS-ASP}

features.each do |feature|
  windows_feature feature do
    action :install
  end
end
