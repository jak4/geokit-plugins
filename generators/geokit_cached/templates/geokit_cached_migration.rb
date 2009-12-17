class <%= migration_name.underscore.camelize %> < ActiveRecord::Migration
  def self.up
    create_table :<%= table_name %> do |t|
      t.string        :street_name,                   :limit => 255
      t.string        :street_number,                 :limit => 10
      t.string        :zip,                           :limit => 10
      t.string        :country_code,                  :limit => 255
      t.string        :city,                          :limit => 255
      t.string        :state,                         :limit => 255
      t.string        :provider,      :null => false
      t.string        :precision,     :null => false
      
      t.with_options :precision => 15, :scale => 10 do |c|
        c.decimal :lat, :null => false
        c.decimal :lng, :null => false
      end
      
      <% unless options[:skip_timestamps] %>
            t.timestamps
      <% end -%>
    end
  end

  def self.down
    drop_table :<%= table_name %>
  end
end