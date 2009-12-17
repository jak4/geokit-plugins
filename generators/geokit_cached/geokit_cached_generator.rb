class GeokitCachedGenerator < Rails::Generator::NamedBase 
  def manifest
    record do |m|
      # Check for class naming collisions.
      m.class_collisions class_path, class_name
      
      # Model class, spec and fixtures.
      m.template 'geokit_cached_model.rb',      File.join('app/models', class_path, "#{file_name}.rb")
      
      unless options[:skip_migration]
        m.migration_template 'geokit_cached_migration.rb', 'db/migrate', :assigns => {
          :migration_name => "Create#{class_name.pluralize.gsub(/::/, '')}"
        }, :migration_file_name => "create_#{file_path.gsub(/\//, '_').pluralize}"
      end
    end

  end
  
  protected
  
#  def banner
#    "Usage: #{$0} ajaxful_rating UserModelName"
#  end
end