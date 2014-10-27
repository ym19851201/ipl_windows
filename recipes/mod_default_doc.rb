powershell_script "add index.asp as defaultDocument" do
  not_if do
    `#{appcmd} list config /section:defaultDocument` =~ /index\.asp/
  end
  code "#{appcmd} set config \/section:defaultDocument \"\/+files.[value='index.asp']\""
end
