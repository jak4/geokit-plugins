require 'plugins/geokit_cached'
if defined? Geokit
  require 'plugins/geokit_cached'
else
  message=%q(WARNING: geokit-plugins requires the Geokit gem. You either don't have the gem installed,
or you haven't told Rails to require it. If you're using a recent version of Rails: 
  config.gem "geokit" # in config/environment.rb
and of course install the gem: sudo gem install geokit)
  puts message
  Rails.logger.error message
end
